import 'dart:collection';

import 'package:picswap/app/manager/firebase/firebase_dynamic_link_manager.dart';
import 'package:picswap/app/manager/firebase/firebase_messaging_manager.dart';
import 'package:picswap/app/utils/log.dart';

class DeepLinkManager {
  static void handlePendingLink() async {
    final uri = await FirebaseDynamicLinkManager.getInitialLink() ??
        await FirebaseMessagingManager.getInitialMessage();
    handleUri(uri);
  }

  static void handleUri(Uri? uri) {
    handleUrl(uri?.toString());
  }

  static void handleUrl(String? deepLinkUrl) {
    if (deepLinkUrl != null) {
      Log.d('deepLinkUrl = $deepLinkUrl');
      final route = deepLinkUrl.replaceAll('picswap:/', '');
      final linkData = route.split('?');
      Map<String, dynamic>? parameters;
      if (linkData.length > 1) {
        parameters = HashMap();
        linkData[1].split('&').forEach((element) {
          final parameterKeyValue = element.split('=');
          parameters![parameterKeyValue.first] = parameterKeyValue.last;
        });
      }
      Log.d('host = ${linkData.first}, parameters = $parameters');

      // Get.toNamed(
      //   linkData.first,
      //   arguments: parameters,
      // );
    }
  }
}
