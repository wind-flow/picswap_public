import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:picswap/app/manager/link/deep_link_manager.dart';
import 'package:picswap/app/manager/notification/local_notification_manager.dart';
import 'package:picswap/app/utils/device_utils.dart';
import 'package:picswap/app/utils/log.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Log.d('onBackgroundMessage = ${message}');
}

class FirebaseMessagingManager {
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      Log.d('onTokenRefresh = $fcmToken');

      final deviceId = await DeviceUtils.getDeviceId();
      Platform.operatingSystem;
      fcmToken;
      deviceId;
    }).onError((err) {
      Log.d('onTokenRefresh error = $err');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage rm) {
      Log.d('onMessage = ${rm.data.toString()}');
      if (Platform.isAndroid) {
        LocalNotificationManager.showNotification(rm.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rm) {
      Log.d('onMessageOpenedApp = ${rm.data.toString()}');
      DeepLinkManager.handleUrl(rm.data['deepLink']?.toString());
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<Uri?> getInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data['deepLink'] != null) {
      return Uri.parse(initialMessage.data['deepLink'].toString());
    }
    return null;
  }

  static Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      Log.d('getToken failed = $e');
    }
    return null;
  }
}
