class AppConstants {
  // common
  static const String appName = 'picswap';

  static const String androidAppId = 'com.wittyapps.picswap';
  static const String iosAppId = 'com.wittyapps.picswap';
  static const String dynamicLinkPrefix = 'https://picswap.page.link';
  static const String imagePrefix = 'assets/images/';

  static const baseUrl = '';
  static const String nicknameUrl = 'https://nickname.hwanmoo.kr';

  static const String firebaseDatabaseUrl =
      'https://picswappublic-default-rtdb.asia-southeast1.firebasedatabase.app/';

  static const String email = 'cleverlywittyapps@gmail.com';

  static const String appcastUrl =
      'https://raw.githubusercontent.com/wind-flow/picswapappcast/main/appcast.xml';

  static const String privacyPolicyUrl =
      'https://cleverlywittyapps.notion.site/Privacy-Policy-2475b1481b5c4e998a23e5607266fc94';
  static const String termsAndConditionsUrl =
      'https://cleverlywittyapps.notion.site/Terms-Conditions-e908f72349ba410593f75e90bdcee1ad';
}

// final isFirstLaunchProvider = StateProvider<bool>((ref) {
//   bool? isFirstLaunch;
//   Future.delayed(Duration.zero, () async {
//     final pref = await ref.watch(preferenceStorageProvider);
//   });
//   return isFirstLaunch ?? true;
// });
