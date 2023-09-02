import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/manager/firebase/firebase_crashlytics_manager.dart';
import 'package:picswap/app/manager/firebase/firebase_dynamic_link_manager.dart';
import 'package:picswap/app/manager/firebase/firebase_remote_config_manager.dart';
import 'package:picswap/app/manager/link/deep_link_manager.dart';
import 'package:picswap/domain/provider/user_provider.dart';

class FirebaseManager {
  static initializeFirebase(WidgetRef ref) async {
    await FirebaseAppCheck.instance.activate(
        androidProvider:
            kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
        appleProvider:
            kDebugMode ? AppleProvider.debug : AppleProvider.appAttest);

    await FirebaseRemoteConfigManager.initialize();

    await FirebaseCrashlyticsManager.initialize();

    await FirebaseCrashlyticsManager.setUserIdentifier(
        ref.read(userProvider).uuid);

    // DeepLinkManager.handlePendingLink();

    // await FirebaseDynamicLinkManager.initialize(ref);
  }
}

class FbfsCollectionName {
  static const String firestorageCollectionUser =
      kDebugMode ? 'dev_user' : 'user';
  static const String firestorageCollectionUserItem =
      kDebugMode ? 'dev_userItem' : 'userItem';
  static const String firestorageCollectionNickname = 'nickname';
  static const String firestorageCollectionNotice =
      kDebugMode ? 'dev_notice' : 'notice';
  static const String firestorageCollectionReport =
      kDebugMode ? 'dev_report' : 'report';
}
