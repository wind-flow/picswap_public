import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/manager/storage/storage_key.dart';
import 'package:uuid/uuid.dart';

import '../manager/storage/secure_storage.dart';

class DeviceUtils {
  static Future<String> getDeviceId() async {
    String? deviceId;
    if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      deviceId = await androidIdPlugin.getId();
    } else if (Platform.isIOS) {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    String? result = deviceId;
    if (deviceId == null) {
      FutureProvider((ref) async {
        final storage = ref.read(secureStorageProvider);
        final savedDeviceId =
            await storage.read(key: AppStorageKeys.deviceIdKey);
        if (savedDeviceId == null) {
          final uuid = const Uuid().v1();
          await storage.write(key: AppStorageKeys.deviceIdKey, value: uuid);
          result = uuid;
        } else {
          result = savedDeviceId;
        }
      });
    }

    return result!;
  }

  static bool isNotchDevice(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom > 0;
  }

  static double getTopNotchHeight(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  static double getBottomNotchHeight(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static double getPaddingTop(BuildContext context, int paddingTop) {
    return getTopNotchHeight(context) + paddingTop;
  }

  static double getPaddingBottom(BuildContext context, int paddingBottom) {
    return getBottomNotchHeight(context) + paddingBottom;
  }

  static double getSafeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        getTopNotchHeight(context) -
        getBottomNotchHeight(context);
  }

  static Future<int> getAndroidBuildVersion() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }

  static Future<bool> isAndroidSmallerThanT() async {
    if (Platform.isIOS) {
      return false;
    }

    return await getAndroidBuildVersion() < 33;
  }

  static String getLocale() {
    if (Platform.localeName.length >= 5) {
      return Platform.localeName.substring(0, 5);
    }
    return Platform.localeName;
  }

  static Future<String> getDeviceName() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return '${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}';
    } else {
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.utsname.machine ?? 'iPhone';
    }
  }

  static Future<String> getOSVersion() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return 'Android ${androidDeviceInfo.version.release} (SDK ${androidDeviceInfo.version.sdkInt})';
    } else {
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return '${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}';
    }
  }
}
