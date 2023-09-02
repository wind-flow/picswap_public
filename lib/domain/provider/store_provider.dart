// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/manager/enums.dart';
import 'package:picswap/app/manager/in_app_purchases/in_app_purchases_manager.dart';

import 'package:picswap/domain/model/item_store_model.dart';
import 'package:picswap/domain/provider/firebase/firebase_firestore_provider.dart';

import '../../app/utils/log.dart';

final storeProvider =
    StateNotifierProvider<StoreStateNotifier, List<ItemInfoModel>>((ref) {
  final fbfs = ref.watch(fbfsInstanceProvider);
  return StoreStateNotifier(ref: ref, fbfs: fbfs);
});

class StoreStateNotifier extends StateNotifier<List<ItemInfoModel>> {
  final Ref ref;
  final FirebaseFirestore fbfs;
  StoreStateNotifier({
    required this.ref,
    required this.fbfs,
  }) : super([]);

  Future<List<ItemInfoModel>> getStoreInfo() async {
    final result = await fbfs.collection('itemStore').get();
    ItemInfoModel item;
    for (var element in result.docs) {
      element.data().forEach((key, value) {
        item = ItemInfoModel.fromJson({'itemGrade': key, ...value});
        item = item.copyWith(itemType: ItemType.values.byName(element.id));

        state.add(item);
      });
    }
    return state;
  }
}

final getStoreInfoFutureProvider = FutureProvider<List<ItemInfoModel>>(
    (ref) async => await ref.read(storeProvider.notifier).getStoreInfo());

// final getStoreInfoFutureProvider = FutureProvider((ref) async {
//   final offerings = await InAppPurchasesManager.fetchOffers();

//   return offerings.first;
// });
