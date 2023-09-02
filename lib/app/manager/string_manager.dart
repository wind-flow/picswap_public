import 'package:picswap/app/manager/constants.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/model/item_store_model.dart';

import '../../domain/model/user_item_model.dart';

class AppStrings {
  // ignore: non_constant_identifier_names
  static String EULATitle = 'EULATitle'.localize();
  // ignore: non_constant_identifier_names
  static String EULAContent = 'EULAContent'.localize();
  // ignore: non_constant_identifier_names
  static String EUCLContentLink = 'EUCLContentLink'.localize();
  static String agree = 'agree'.localize();
  static String terms = 'termsAndConditions'.localize();
  static String privacy = 'privacyPolicy'.localize();

  static String nickname = 'nickname'.localize();
  static String generator = 'generator'.localize();
  static String ok = 'ok'.localize();
  static String cancel = 'cancel'.localize();

  static String roomNo = 'roomNo'.localize();
  static String createRoom = 'createRoom'.localize();
  static String joinRoom = 'joinRoom'.localize();
  static String create = 'create'.localize();
  static String join = 'join'.localize();
  static String enterRoomNumber = 'enterRoomNumber'.localize();
  static String noGuest = 'noGuest'.localize();
  static String isDone = 'isDone'.localize();

  static String camera = 'camera'.localize();
  static String gallery = 'gallery'.localize();
  static String click = 'click'.localize();
  static String ready = 'ready'.localize();

  static String confirmExit = 'confirmExit'.localize();

  static String sendMessage = 'sendMessage'.localize();
  static String chatNotify = 'chatNotify'.localize();

  static String noTargetReport = 'noTargetReport'.localize();
  static String alreadyReport = 'alreadyReport'.localize();
  static String notYetPic = 'notYetPic'.localize();
  static String noticeReport = 'noticeReport'.localize();

  static String store = 'store'.localize();

  static String noticeConsumeToken({required UserItemModel userItem}) {
    return 'noticeConsumeToken'.localize(namedArgs: {
      'totalToken':
          (userItem.token.tokenFree + userItem.token.tokenPurchase).toString(),
      'tokenFree': userItem.token.tokenFree.toString(),
      'tokenPurchase': userItem.token.tokenPurchase.toString(),
    });
  }

  static String getCoin = 'getCoin'.localize();
  static String itemList = 'itemList'.localize();
  static String noticeReadBeforePurchaseTitle =
      'noticeReadBeforePurchaseTitle'.localize();

  static String noticeReadBeforePurchaseContent =
      'noticeReadBeforePurchaseContent'.localize();

  static String noticePurchaseSuccess = 'noticePurchaseSuccess'.localize();

  static String unknown = 'unknown'.localize();

  static String confirmPurchase({required ItemInfoModel item}) {
    return 'confirmPurchase'
        .localize(namedArgs: {'needCoin': item.needCoin.toString()});
  }

  static String coinNotEnough = 'coinNotEnough'.localize();
  static String itemNotEnough({required String item}) {
    return 'itemNotEnough'.localize(namedArgs: {'item': item});
  }

  static String notice = 'notice'.localize();
  static String sendMail = 'sendMail'.localize();
  static String version = 'version'.localize();

  static String noticeAllowPermission = 'noticeAllowPermission'.localize();
  static String allowEverything = 'allowEverything'.localize();
  static String goSetting = 'goSetting'.localize();
  static String permission = 'permission'.localize();
  static String failWriteEmail =
      'failWriteEmail'.localize(namedArgs: {'mail': AppConstants.email});

  static String chatCreateMessage = 'chatCreateMessage'.localize();

  static String chatEnterMessage({required String nickname}) {
    return 'chatEnterMessage'.localize(namedArgs: {'nickname': nickname});
  }

  static String chatExitMessage({required String nickname}) {
    return 'chatExitMessage'.localize(namedArgs: {'nickname': nickname});
  }

  static String deactiveNoti = 'deactiveNoti'.localize();
  static String roomRemoved = 'roomRemoved'.localize();

  static String tutorialContent1 = 'tutorialContent1'.localize();
  static String tutorialContent2 = 'tutorialContent2'.localize();
  static String tutorialContent3 = 'tutorialContent3'.localize();
  static String tutorialContent4 = 'tutorialContent4'.localize();
  static String tutorialContent5 = 'tutorialContent5'.localize();

// ErrorMessage
  static String errorGenNickname = 'errorGenNickname'.localize();
  static String errorGenRoomNo = 'errorGenRoomNo'.localize();
  static String errorNetworkCantConnect = 'errorNetworkCantConnect'.localize();
}

class AppErrorMessage {
  static String errorGenNickname = 'Fail to generate nickname'.localize();
}
