import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrashlyticsManager {
  static Future<void> initialize() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  static Future<void> setUserIdentifier(String identifier) async {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
    }
  }

  static Future<void> recordError(error, StackTrace? stackTrace) async {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
      );
    }
  }

  static void record(String message) {
    try {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.log(message);
      }
    } catch (e) {
      // exception occur when firebase is not initialized
    }
  }
}
