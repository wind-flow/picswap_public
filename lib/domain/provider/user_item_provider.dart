import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/manager/enums.dart';
import 'package:picswap/app/manager/firebase/firebase_manager.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/domain/model/coin_model.dart';
import 'package:picswap/domain/model/item_chat_model.dart';
import 'package:picswap/domain/model/item_remove_ad_model.dart';
import 'package:picswap/domain/model/item_store_model.dart';
import 'package:picswap/domain/model/item_token_model.dart';

import 'package:picswap/domain/model/user_item_model.dart';
import 'package:picswap/domain/model/user_model.dart';
import 'package:picswap/domain/provider/firebase/firebase_firestore_provider.dart';
import 'package:picswap/domain/provider/user_provider.dart';

import '../../app/utils/log.dart';

final userItemProvider =
    StateNotifierProvider<UserItemStateNotifier, UserItemModel>((ref) {
  final user = ref.watch(userProvider);
  final userController = ref.read(userProvider.notifier);
  final fbfs = ref.watch(fbfsInstanceProvider);
  return UserItemStateNotifier(
      ref: ref, user: user, userController: userController, fbfs: fbfs);
});

class UserItemStateNotifier extends StateNotifier<UserItemModel> {
  final Ref ref;
  final UserModel user;
  final UserStateNotifier userController;
  final FirebaseFirestore fbfs;

  UserItemStateNotifier({
    required this.ref,
    required this.user,
    required this.userController,
    required this.fbfs,
  }) : super(UserItemModel.init()) {
    getUserItemInfo();
  }

  Future<void> getUserItemInfo() async {
    try {
      final result = await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUserItem)
          .doc(user.uuid)
          .get();
      if (result.exists) {
        if (mounted) {
          state = UserItemModel.fromJson(result.data()!);
        }
      } else {
        await postUserItemInfo();
      }
    } catch (e, s) {
      Log.e(e, s);
      throw e.toString();
    }
  }

  Future<void> postUserItemInfo() async {
    try {
      state = UserItemModel(
        uuid: user.uuid,
        coin: CoinModel.init(),
        token: ItemTokenModel.init(),
        chat: ItemChatModel.init(),
        removeAd: ItemRemoveAdModel.init(),
      );

      await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUserItem)
          .doc(user.uuid)
          .set(state.toMap());
    } catch (e) {
      Log.e(e.toString());
      throw e.toString();
    }
  }

  Future<void> getCoin({int addCoin = 1}) async {
    try {
      await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUserItem)
          .doc(user.uuid)
          .update({'coin.coinAd': state.coin.coinAd + addCoin});
    } catch (e) {
      Log.e(e.toString());
    } finally {
      await getUserItemInfo();
    }
  }

  Future<bool> buyItem({required ItemInfoModel item}) async {
    if (state.coin.coinAd < item.needCoin &&
        state.coin.coinPurchase < item.needCoin) {
      throw AppStrings.coinNotEnough;
    }

    Map<String, int> requestJsonItem;

    switch (item.itemType) {
      case ItemType.token:
        requestJsonItem = {
          '${ItemType.token.name}.${ItemType.token.name}Purchase':
              state.token.tokenPurchase + item.itemCount,
        };
        break;
      case ItemType.chat:
        requestJsonItem = {
          // '${ItemType.chat.name}.${ItemType.chat.name}Purchase':
          //     state.token.tokenPurchase + item.itemCount,
        };

        break;
    }

    if (state.coin.coinAd >= item.needCoin) {
      requestJsonItem = {
        'coin.coinAd': state.coin.coinAd - item.needCoin,
        ...requestJsonItem
      };
    } else if (state.coin.coinPurchase >= item.needCoin) {
      requestJsonItem = {
        'coin.coinPurchase': state.coin.coinPurchase - item.needCoin,
        ...requestJsonItem
      };
    }
    try {
      await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUserItem)
          .doc(user.uuid)
          .update(requestJsonItem);
      await getUserItemInfo();
    } catch (e) {
      throw e.toString();
    }

    return true;
  }

  Future<bool> consumeToken() async {
    if (state.token.tokenFree <= 0 && state.token.tokenPurchase <= 0) {
      throw AppStrings.itemNotEnough(item: ItemType.token.name);
    }

    Map<String, int> requestJsonItem = {};

    if (state.token.tokenFree > 0) {
      requestJsonItem = {
        'token.tokenFree': state.token.tokenFree - 1,
      };
    } else if (state.token.tokenPurchase > 0) {
      requestJsonItem = {
        'token.tokenPurchase': state.token.tokenPurchase - 1,
      };
    }

    try {
      await fbfs
          .collection(FbfsCollectionName.firestorageCollectionUserItem)
          .doc(user.uuid)
          .update(requestJsonItem);
      await getUserItemInfo();
    } catch (e) {
      throw e.toString();
    }

    return true;
  }

  // Future<bool> consumeChat() async {
  //   if (state.token.tokenFree <= 0 && state.token.tokenPurchase <= 0) {
  //     throw '교환권이 부족합니다';
  //   }

  //   Map<String, int> requestJsonItem = {};

  //   if (state.token.tokenFree > 0) {
  //     requestJsonItem = {
  //       'token.tokenFree': state.token.tokenFree - 1,
  //     };
  //   } else if (state.token.tokenPurchase > 0) {
  //     requestJsonItem = {
  //       'coin.tokenPurchase': state.token.tokenPurchase - 1,
  //     };
  //   }

  //   try {
  //     await fbfs
  //         .collection(FbfsCollectionName.firestorageCollectionUserItem)
  //         .doc(user.uuid)
  //         .update(requestJsonItem);
  //     await getUserItemInfo();
  //   } catch (e) {
  //     throw e.toString();
  //   }

  //   return true;
  // }

  int totalItemCount() {
    final result = state.token.tokenPurchase;
    return result;
  }
}
