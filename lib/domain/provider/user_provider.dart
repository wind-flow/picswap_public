import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/manager/firebase/firebase_manager.dart';

import 'package:picswap/domain/model/user_model.dart';
import 'package:picswap/domain/provider/firebase/firebase_firestore_provider.dart';
import 'package:picswap/main.dart';

import '../../app/utils/log.dart';

final fbAuthInstanceProvider = Provider((ref) {
  try {
    final fbAuthInstance = FirebaseAuth.instance;
    return fbAuthInstance;
  } catch (e) {
    throw e.toString();
  }
});

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel>((ref) {
  final fbfs = ref.watch(fbfsInstanceProvider);
  final fbAuth = ref.watch(fbAuthInstanceProvider);
  return UserStateNotifier(fbfs: fbfs, ref: ref, fbAuth: fbAuth);
});

class UserStateNotifier extends StateNotifier<UserModel> {
  final Ref ref;
  final FirebaseFirestore fbfs;
  final FirebaseAuth fbAuth;

  UserStateNotifier({
    required this.ref,
    required this.fbfs,
    required this.fbAuth,
  }) : super(UserModel.init());

  Future<void> setInit() async {
    UserCredential userCredential = await fbAuth.signInAnonymously();

    final user = userCredential.user;
    String token = '';

    state = state.copyWith(uuid: user?.uid);

    try {
      if (user == null) {
        user?.reload();
      } else {
        token = await user.getIdToken();

        state =
            state.copyWith(uuid: user.uid, token: token, nickname: '테스트닉네임');

        await getUserInfo();
      }
    } catch (e, s) {
      Log.e('${e.toString()} $s');

      if (token == '') {
        rethrow;
      }
    }
  }

  Future<String> getNickname({required String locale}) async {
    try {
      final roomNumberInt = Random().nextInt(10);
      final result = await fbfs
          .collection(FbfsCollectionName.firestorageCollectionNickname)
          .doc(roomNumberInt.toString())
          .get();

      final nickName = result.data()?[locale];

      return nickName;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserInfo() async {
    try {
      final result = await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUser)
          .doc(state.uuid)
          .get();

      if (result.exists) {
        state = UserModel.fromJson(result.data()!);

        return state;
      } else {
        await postUserInfo();
        return null;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> postUserInfo() async {
    // final nickname = await getNickname(locale: locale);
    state = state.copyWith(nickname: '테스트닉네임');
    try {
      await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUser)
          .doc(state.uuid)
          .set(state.toMap());
    } catch (e) {
      Log.e(e.toString());
      throw e.toString();
    }
  }

  void setHost(bool isHost) async {
    state = state.copyWith(isHost: isHost);
    await fbfs
        .collection(FbfsCollectionName.firestorageCollectionUser)
        .doc(state.uuid)
        .update({'isHost': state.isHost});
  }

  void setNickname(String nickname) async {
    state = state.copyWith(nickname: nickname);
    await fbfs
        .collection(FbfsCollectionName.firestorageCollectionUser)
        .doc(state.uuid)
        .update({'nickname': state.nickname});
  }

  void setUrl(String? url) async {
    if (url == null) {
      state = state.copyWith(pictureUrl: '');
    } else {
      state = state.copyWith(pictureUrl: url);
    }

    await fbfs
        .collection(FbfsCollectionName.firestorageCollectionUser)
        .doc(state.uuid)
        .update({'pictureUrl': state.pictureUrl});
  }
}

  // Future<void> putNickname() async {
  //   final result = await ref.read(nicknameRepository).getNickname();
  //   final nicknameList = result.words;
  //   print(nicknameList.toString());
  //   int index = 60;

  //   for (final nickname in nicknameList) {
  //     await fbfs
  //         .collection('nickname')
  //         .doc(index.toString())
  //         .set({index.toString(): nickname});
  //     index++;
  //   }
  // }

  // Future<String> nicknameGenerate() async {
  //   // final result = await ref.read(nicknameRepository).getNickname();
  //   final nick = await getNickname();
  //   // final nickname = result.words.first;
  //   setNickname(nickname);
  //   return result.words.first;
  // }
