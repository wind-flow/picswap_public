import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/manager/firebase/firebase_manager.dart';
import 'package:picswap/domain/model/notice_model.dart';
import 'package:picswap/domain/provider/firebase/firebase_firestore_provider.dart';

import '../../app/utils/log.dart';

final noticeProvider = FutureProvider<List<NoticeModel>>((ref) async {
  final fbfs = ref.watch(fbfsInstanceProvider);
  List<NoticeModel> noticeList = [];
  await fbfs
      .collection(FbfsCollectionName.firestorageCollectionNotice)
      .get()
      .then((value) {
    for (var docSnapshot in value.docs) {
      Log.d(
          '${docSnapshot.data()} ${docSnapshot.data().toString()} ${docSnapshot.data().runtimeType}');
      final noticeModel = NoticeModel.fromMap(docSnapshot.data());
      noticeList.add(noticeModel);
    }
  });
  Log.d(noticeList.toString());

  noticeList.sort(((a, b) {
    if (a.priority.compareTo(b.priority) == 0) {
      return a.timeStamp.compareTo(b.timeStamp);
    }
    return a.priority.compareTo(b.priority);
  }));
  Log.d(noticeList.toString());
  return noticeList;
});
