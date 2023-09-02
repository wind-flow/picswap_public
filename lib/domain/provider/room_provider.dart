import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:picswap/app/manager/string_manager.dart';

import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/model/fbrtdb_model.dart';
import 'package:picswap/domain/model/report_model.dart';
import 'package:picswap/domain/model/room_model.dart';
import 'package:picswap/domain/model/user_model.dart';
import 'package:picswap/domain/provider/firebase/firebase_firestore_provider.dart';
import 'package:picswap/domain/provider/user_provider.dart';

import '../../app/manager/enums.dart';
import '../../app/manager/firebase/firebase_manager.dart';
import '../../app/manager/image_manager.dart';
import '../../app/utils/log.dart';
import '../model/chat_model.dart';
import 'firebase/firebase_realtime_provider.dart';
import 'firebase/firebase_storage_provider.dart';

final roomStreamProvider =
    StreamProvider.family<RoomModel, String>((ref, roomId) async* {
  final fbrtdb = ref.watch(fbrtdbRoomProvider);
  final dbRef = fbrtdb.roomRef.child(roomId);

  // 데이터베이스 노드의 변경 사항을 청취합니다.
  final stream = dbRef.onValue;

  // 스트림에서 데이터를 읽어옵니다.
  await for (DatabaseEvent event in stream) {
    try {
      final roomJson = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(event.snapshot.value)));

      final dataList = RoomModel.fromMap(roomJson);

      yield dataList;
    } catch (e) {
      throw e.toString();
    }
  }
});

final chatStreamProvider =
    StreamProvider.family<List<ChatModel>, String>((ref, roomId) async* {
  final fbrtdb = ref.watch(fbrtdbRoomProvider);
  final enterTime = ref.watch(enterRoomTime);

  final dbRef = fbrtdb.messageRef
      .child(roomId)
      .orderByChild('timeStamp')
      .startAt(enterTime);

  // 데이터베이스 노드의 변경 사항을 청취합니다.
  final stream = dbRef.onValue;

  // 스트림에서 데이터를 읽어옵니다.
  await for (DatabaseEvent event in stream) {
    final messageList =
        Map<String, dynamic>.from(jsonDecode(jsonEncode(event.snapshot.value)))
            .values
            .toList();

    final List<ChatModel> chatList = [];
    for (var element in messageList) {
      try {
        final chat = ChatModel.fromJson(element);

        if (chat.timeStamp.compareTo(enterTime) > 0) {
          chatList.add(chat);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    chatList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    yield chatList.toList();
  }
});

final enterRoomTime = StateProvider<int>((ref) => 0);

final roomInfoProvider = StateNotifierProvider.autoDispose
    .family<RoomStateNotifier, RoomModel?, String>(
  (ref, roomId) {
    final user = ref.watch(userProvider);
    final fbrtdb = ref.watch(fbrtdbRoomProvider);
    final fbstorage = ref.watch(fbstorageProvider);
    final roomStream = ref.watch(roomStreamProvider(roomId));
    final chatStream = ref.watch(chatStreamProvider(roomId));

    return RoomStateNotifier(
        user: user,
        rtdb: fbrtdb,
        fbstorage: fbstorage,
        ref: ref,
        roomId: roomId,
        roomStream: roomStream,
        chatStream: chatStream);
  },
);

class RoomStateNotifier extends StateNotifier<RoomModel?> {
  final Ref ref;
  final UserModel user;
  final FbrtdbModel rtdb;
  final FirebaseStorage fbstorage;
  final AsyncValue<RoomModel> roomStream;
  final AsyncValue<List<ChatModel>> chatStream;
  StreamSubscription<DatabaseEvent>? roomRefListener;
  StreamSubscription<DatabaseEvent>? chatRefListener;
  String roomId;

  RoomStateNotifier({
    required this.ref,
    required this.user,
    required this.rtdb,
    required this.fbstorage,
    required this.roomStream,
    required this.chatStream,
    required this.roomId,
  }) : super(null) {
    roomStream.whenData((value) => (state = value));
  }

  Future<void> createRoom() async {
    try {
      ref
          .read(enterRoomTime.notifier)
          .update((state) => DateTime.now().millisecondsSinceEpoch);

      final chatModel = ChatModel(
          uuid: user.uuid,
          senderNickname: user.nickname,
          message: AppStrings.chatCreateMessage.localize(),
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          type: MessageType.alert);

      final room = RoomModel(
          id: roomId,
          host: user,
          hostPicUrl: null,
          guest: null,
          guestPicUrl: null,
          createTimeStamp: DateTime.now().millisecondsSinceEpoch,
          hostActiveTimeStamp: DateTime.now().millisecondsSinceEpoch);

      ref.read(userProvider.notifier).setHost(true);

      rtdb.roomRef.child(roomId).update(room.toMap());
      rtdb.messageRef.child(roomId).push().update(chatModel.toJson());
    } catch (e) {
      Log.e(e.toString());
      throw e.toString();
    }
  }

  Future<void> joinRoom() async {
    try {
      // 채팅방 정보 조회
      final roomInfo =
          await rtdb.roomRef.orderByChild("id").equalTo(roomId).once();

      // 해당 방이 없으면 에러 처리
      if (roomInfo.snapshot.value == null) {
        throw "Chat room not found: $roomId";
      }

      // 인원(2명) 모두 차면 입장 불가
      if (roomInfo.snapshot.children.first.child('guest').value != null) {
        throw "Room is Full: $roomId";
      }

      // 교환이 끝난방이면 입장 불가
      if (roomInfo.snapshot.children.first.child('isDone').value == true) {
        throw "Room is Done: $roomId";
      }

      ref
          .read(enterRoomTime.notifier)
          .update((state) => DateTime.now().millisecondsSinceEpoch);

      Future.delayed(const Duration(milliseconds: 500));

      final chat = ChatModel(
          uuid: user.uuid,
          senderNickname: user.nickname,
          message: AppStrings.chatEnterMessage(nickname: user.nickname),
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          type: MessageType.alert);

      ref.read(userProvider.notifier).setHost(false);

      await rtdb.roomRef.child('$roomId/guest/').update(user.toMap());
      await rtdb.roomRef
          .child('$roomId/guestActiveTimeStamp')
          .set(DateTime.now().millisecondsSinceEpoch);

      await rtdb.messageRef.child(roomId).push().update(chat.toJson());
    } catch (e) {
      Log.e(e.toString());
      throw e.toString();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isNullOrEmpty()) {
      return;
    }

    try {
      // 채팅방 정보 조회
      final roomInfo =
          await rtdb.roomRef.orderByChild("id").equalTo(roomId).once();
      if (roomInfo.snapshot.value == null) {
        // 해당 방이 없으면 에러 처리
        throw Exception("Chat room not found: $roomId");
      }

      // 채팅 메시지 생성
      final chatModel = ChatModel(
        uuid: user.uuid,
        senderNickname: user.nickname,
        message: text,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        type: MessageType.message,
      );

      // 채팅 메시지 업데이트
      await rtdb.messageRef.child(roomId).push().set(chatModel.toJson());

      await rtdb.roomRef
          .child(
              '$roomId/${user.isHost ? 'hostActiveTimeStamp' : 'guestActiveTimeStamp'}/')
          .set(DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      Log.e(e.toString());
      throw e.toString();
    }
  }

  Future<void> leaveChatRoom() async {
    try {
      // 채팅방에서 사용자 정보 삭제
      Query roomReference = rtdb.roomRef.orderByChild('id').equalTo(roomId);

      final roomSnapshot = await roomReference.once();

      if (roomSnapshot.snapshot.value == null) {
        // 해당 방이 없으면 에러 처리
        throw "Chat room not found: $roomId";
      }

      final userReference =
          rtdb.roomRef.child(roomId).orderByChild('uuid').equalTo(user.uuid);

      final userSnapshot = await userReference.once();

      final Map<dynamic, dynamic>? users =
          userSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (users != null) {
        ref.read(userProvider.notifier).setUrl(null);
        await userSnapshot.snapshot.child('${users.keys.first}').ref.remove();

        await rtdb.roomRef.update({
          '$roomId/${user.isHost ? 'hostPicUrl' : 'guestPicUrl'}': null,
          '$roomId/${user.isHost ? 'hostBlurPicUrl' : 'guestBlurPicUrl'}': null,
          '$roomId/${user.isHost ? 'hostIsReady' : 'guesthostIsReady'}': null,
        });

        roomReference = rtdb.roomRef.orderByChild('id').equalTo(roomId);
        final room = (await roomReference.once()).snapshot.child(roomId);

        if (room.child('guest').exists || room.child('host').exists) {
          final chatModel = ChatModel(
            uuid: user.uuid,
            senderNickname: user.nickname,
            message: AppStrings.chatExitMessage(nickname: user.nickname),
            timeStamp: DateTime.now().millisecondsSinceEpoch,
            type: MessageType.alert,
          );

          // 채팅 메시지 업데이트
          await rtdb.messageRef.child(roomId).push().set(chatModel.toJson());

          await rtdb.roomRef
              .child(
                  '$roomId/${user.isHost ? 'hostActiveTimeStamp' : 'guestActiveTimeStamp'}')
              .set(DateTime.now().millisecondsSinceEpoch);
        } else {
          // 방 삭제
          room.ref.remove();

          // 메세지 삭제
          await rtdb.messageRef.ref.child(roomId).ref.remove();
        }

        ref.read(userProvider.notifier).setUrl(null);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  void onReady(RoomModel roomInfo) async {
    await rtdb.roomRef
        .child('$roomId/${user.isHost ? 'hostIsReady' : 'guestIsReady'}')
        .set(user.isHost ? !(roomInfo.hostIsReady) : !(roomInfo.guestIsReady));

    await rtdb.roomRef
        .child(
            '$roomId/${user.isHost ? 'hostActiveTimeStamp' : 'guestActiveTimeStamp'}')
        .set(DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> uploadPicture(ImageSource imageSource) async {
    final String prefix = user.isHost ? 'host' : 'guest';

    try {
      final File? file = await ImageManager.pickImage(imageSource);
      final img.Image image = img.decodeImage(file!.readAsBytesSync())!;
      final img.Image blurredImage =
          img.copyResize(image, width: 600, height: 600);
      img.Image blurredImageCopy = blurredImage.clone();
      blurredImageCopy = img.gaussianBlur(blurredImageCopy, radius: 30);
      final Uint8List blurredImageBytes = img.encodeJpg(blurredImageCopy);

      final Reference storageRefBlur =
          fbstorage.ref('$roomId/${prefix}_${user.uuid}_blur/');
      final Reference storageRef =
          fbstorage.ref('$roomId/${prefix}_${user.uuid}/');

      final SettableMetadata metadata = SettableMetadata(
        contentLanguage: 'en',
        contentType: 'image/jpeg',
        customMetadata: {'token': user.token},
      );

      final List<Future<dynamic>> futures = [
        storageRefBlur.putData(blurredImageBytes, metadata),
        storageRef.putData(file.readAsBytesSync(), metadata),
      ];
      await Future.wait(futures);

      final String downloadImgUrl = await storageRef.getDownloadURL();
      final String downloadBlurImgUrl = await storageRefBlur.getDownloadURL();

      await rtdb.roomRef.update({
        '$roomId/${user.isHost ? 'hostPicUrl' : 'guestPicUrl'}': downloadImgUrl,
        '$roomId/${user.isHost ? 'hostBlurPicUrl' : 'guestBlurPicUrl'}':
            downloadBlurImgUrl,
      });
      await rtdb.roomRef
          .child(
              '$roomId/${user.isHost ? 'hostActiveTimeStamp' : 'guestActiveTimeStamp'}')
          .set(DateTime.now().millisecondsSinceEpoch);

      ref.read(userProvider.notifier).setUrl(downloadImgUrl);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  bool isReady(RoomModel roomInfo) {
    return roomInfo.guestIsReady && roomInfo.hostIsReady;
  }

  UserModel? isMe(RoomModel roomInfo) {
    if (user.isHost) {
      return roomInfo.host;
    } else {
      return roomInfo.guest;
    }
  }

  Future<void> postReport(ReportModel reportModel) async {
    try {
      final fbfs = ref.watch(fbfsInstanceProvider);
      Map<String, dynamic>? reportListSnapshot = (await fbfs
              .collection(FbfsCollectionName.firestorageCollectionReport)
              .doc(reportModel.target)
              .get())
          .data();
      reportModel = reportModel.copyWith(reportTime: DateTime.now().toString());

      if (reportListSnapshot?['reportList'] != null) {
        List<dynamic> temp = reportListSnapshot!['reportList'] as List<dynamic>;

        List<ReportModel> reportList = [];

        reportList = temp.map((e) => ReportModel.fromJson(e)).toList();

        final isAlreadyReport = reportList.firstWhere(
            (element) =>
                (element.id == reportModel.id) &&
                (element.me == reportModel.me) &&
                (element.target == reportModel.target),
            orElse: () => ReportModel.init());

        if (isAlreadyReport != ReportModel.init()) {
          throw AppStrings.alreadyReport;
        }

        debugPrint('${[
          ...reportList.map((e) => e.toJson()).toList(),
          reportModel.toJson()
        ]}');

        await fbfs
            .collection(FbfsCollectionName.firestorageCollectionReport)
            .doc(reportModel.target)
            .set({
          'reportList': [
            ...reportList.map((e) => e.toJson()).toList(),
            reportModel.toJson()
          ]
        });
      } else {
        debugPrint(reportModel.toJson().toString());
        await fbfs
            .collection(FbfsCollectionName.firestorageCollectionReport)
            .doc(reportModel.target)
            .set({
          'reportList': [reportModel.toJson()]
        });
      }
    } catch (e, s) {
      Log.e(e.toString());
      Log.e(s.toString());
      throw e.toString();
    }
  }

  void onDone() async {
    rtdb.roomRef.child('$roomId/isDone').set(true);
    // rtdb.roomRef.child('$roomId/timeStamp').update(ServerValue.timestamp);
  }

  // Future<void> test() async {
  //   final roomReference = rtdb.roomRef.orderByChild('id').equalTo(roomId);
  //   final room = await roomReference.once();

  //   Log.d(
  //       '${room.snapshot.child(roomId).value} \n ${room.snapshot.child('guest').value}');
  //   // listenChatRoom();
  //   // print(state.toString());
  // }
}

// final uploadPictureFutureProvider =
//     FutureProvider.family((ref, String roomId) async {
//   final roomController = ref.read(roomInfoProvider(roomId).notifier);
//   return roomController.uploadPicture(ImageSource.gallery);
// });
