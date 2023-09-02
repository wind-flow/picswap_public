import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:picswap/app/manager/link/deep_link_manager.dart';
import 'package:picswap/app/utils/device_utils.dart';
import 'package:picswap/app/utils/log.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

class LocalNotificationManager {
  static const notificationChannelId = 'high_importance_channel';

  static Future<void> initializeLocalNotification() async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      notificationChannelId,
      'Notifications',
      description: 'Question & Comment notifications',
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
    await flutterLocalNotificationsPlugin?.initialize(
      const InitializationSettings(
        android:
            AndroidInitializationSettings('@mipmap/ic_launcher_adaptive_back'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onDidReceiveLocalNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveLocalNotificationResponse,
    );
  }

  static Future<bool?> requestLocalNotificationPermission() async {
    if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else {
      if (await DeviceUtils.isAndroidSmallerThanT()) {
        return true;
      }
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      return flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  static Future<void> showNotification(Map<String, dynamic> data) async {
    if (flutterLocalNotificationsPlugin == null) {
      await initializeLocalNotification();
    }
    flutterLocalNotificationsPlugin?.show(
      data.hashCode,
      data['title']?.toString(),
      data['body']?.toString(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'Notifications',
          channelDescription: 'Question & Comment notifications',
        ),
      ),
      payload: data['deepLink']?.toString(),
    );
  }

  static Future<void> clearNotification() async {
    await flutterLocalNotificationsPlugin?.cancelAll();
  }

  static void _onDidReceiveLocalNotificationResponse(
      NotificationResponse notification) {
    Log.d(
        'didReceiveLocalNotificationResponse = ${notification.notificationResponseType}, ${notification.id}, ${notification.actionId}, ${notification.input}, ${notification.payload}');
    DeepLinkManager.handleUrl(notification.payload);
  }
}
