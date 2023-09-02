// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'remote_config_model.g.dart';

@JsonSerializable()
class RemoteConfigModel {
  final String appInfo;
  final String minVersion;
  final String latestVersion;

  RemoteConfigModel({
    required this.appInfo,
    required this.minVersion,
    required this.latestVersion,
  });

  factory RemoteConfigModel.init() => RemoteConfigModel(
      appInfo: '', minVersion: '1.0.0', latestVersion: '1.0.0');

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigModelFromJson(json);

  RemoteConfigModel copyWith({
    String? appInfo,
    String? minVersion,
    String? latestVersion,
  }) {
    return RemoteConfigModel(
      appInfo: appInfo ?? this.appInfo,
      minVersion: minVersion ?? this.minVersion,
      latestVersion: latestVersion ?? this.latestVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appInfo': appInfo,
      'minVersion': minVersion,
      'latestVersion': latestVersion,
    };
  }

  factory RemoteConfigModel.fromMap(Map<String, dynamic> map) {
    return RemoteConfigModel(
      appInfo: map['appInfo'] as String,
      minVersion: map['minVersion'] as String,
      latestVersion: map['latestVersion'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'RemoteConfigModel(appInfo: $appInfo, minVersion: $minVersion, latestVersion: $latestVersion)';

  @override
  bool operator ==(covariant RemoteConfigModel other) {
    if (identical(this, other)) return true;

    return other.appInfo == appInfo &&
        other.minVersion == minVersion &&
        other.latestVersion == latestVersion;
  }

  @override
  int get hashCode =>
      appInfo.hashCode ^ minVersion.hashCode ^ latestVersion.hashCode;
}
