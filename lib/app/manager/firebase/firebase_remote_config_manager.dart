import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/domain/model/remote_config_model.dart';

import '../../utils/log.dart';

class FirebaseRemoteConfigManager {
  final Ref ref;

  FirebaseRemoteConfigManager({required this.ref});

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 0),
      ),
    );

    await remoteConfig.fetch();

    await remoteConfig.fetchAndActivate();
  }

  static List<String> getProfanityWords() {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final profanityWordsRow =
        remoteConfig.getAll()['profanity_words']?.asString() ?? '[]';
    final profanityWords = jsonDecode(profanityWordsRow) as List<dynamic>;
    return profanityWords.map((word) => word.toString()).toList();
  }

  static RemoteConfigModel getVersionInfo() {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final rawData = remoteConfig.getAll()['version'];
    Log.d(rawData?.asString());

    final version = jsonDecode(rawData?.asString() ??
        '{"appInfo": "picswap", "minVersion": "1.0.0", "latestVersion": "1.0.1"}');

    final remoteConfigJson = RemoteConfigModel.fromJson(version);

    return remoteConfigJson;
  }
}

final remoteConfigProvider = Provider((ref) {
  final remoteConfig = FirebaseRemoteConfig.instance;
  return remoteConfig;
});
