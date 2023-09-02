import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:picswap/app/manager/constants.dart';
import 'package:picswap/app/utils/log.dart';

import 'package:go_router/go_router.dart';
import 'package:picswap/domain/provider/room_provider.dart';
import 'package:picswap/domain/provider/user_provider.dart';
import 'package:picswap/main.dart';

import '../../../domain/provider/user_item_provider.dart';
import '../routes.dart';

class FirebaseDynamicLinkManager {
  static Future<void> initialize(WidgetRef ref) async {
    getInitialLink();
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData event) async {
      Log.d('dynamicLink = ${event.link}');
      if (event.link.queryParameters.containsKey('roomId')) {
        String link = event.link.path.split('/').last;
        String roomId = event.link.queryParameters['roomId']!;
        Log.d('$link/$roomId'.toString());

        try {
          final nickname =
              await ref.read(userProvider.notifier).getNickname(locale: locale);

          await ref.read(userProvider.notifier).setInit();
          await ref.read(userItemProvider.notifier).getUserItemInfo();
          ref.read(userProvider.notifier).setNickname(nickname);
          FlutterNativeSplash.remove();

          await ref.read(roomInfoProvider(roomId).notifier).joinRoom();

          navigatorKey.currentContext!
              .pushNamed(link, pathParameters: {'roomId': roomId});
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        }
      }
    }).onError((error) {
      Log.d('dynamicLink error = ${error.toString()}');
    });
  }

  static Future<Uri?> getInitialLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    return data?.link;
  }

  static Future<String> getShortLink(String screenName, String id) async {
    String dynamicLinkPrefix = AppConstants.dynamicLinkPrefix;
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('$dynamicLinkPrefix/$screenName?roomId=$id'),
      androidParameters: const AndroidParameters(
        packageName: AppConstants.androidAppId,
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: AppConstants.iosAppId,
        minimumVersion: '0',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }
}
