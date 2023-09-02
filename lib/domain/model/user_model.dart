// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uuid;
  final String nickname;
  final String? pictureUrl;
  final bool isHost;
  final String token;
  final String? createTime;
  final int flag;
  // final DeviceInfo deviceinfo;

  factory UserModel.init() {
    return UserModel(
        uuid: '',
        nickname: '',
        token: '',
        flag: 0,
        createTime: DateTime.now().toString());
  }

  UserModel({
    required this.uuid,
    required this.nickname,
    this.pictureUrl,
    this.isHost = true,
    required this.token,
    this.createTime,
    this.flag = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserModel copyWith({
    String? uuid,
    String? nickname,
    String? pictureUrl,
    bool? isHost,
    String? token,
    String? createTime,
    int? flag,
  }) {
    return UserModel(
      uuid: uuid ?? this.uuid,
      nickname: nickname ?? this.nickname,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      isHost: isHost ?? this.isHost,
      token: token ?? this.token,
      createTime: createTime ?? this.createTime,
      flag: flag ?? this.flag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'nickname': nickname,
      'pictureUrl': pictureUrl,
      'isHost': isHost,
      'token': token,
      'createTime': createTime,
      'flag': flag,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uuid: map['uuid'] as String,
      nickname: map['nickname'] as String,
      pictureUrl:
          map['pictureUrl'] != null ? map['pictureUrl'] as String : null,
      isHost: map['isHost'] as bool,
      token: map['token'] as String,
      createTime:
          map['createTime'] != null ? map['createTime'] as String : null,
      flag: map['flag'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserModel(uuid: $uuid, nickname: $nickname, pictureUrl: $pictureUrl, isHost: $isHost, token: $token, createTime: $createTime, flag: $flag)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.nickname == nickname &&
        other.pictureUrl == pictureUrl &&
        other.isHost == isHost &&
        other.token == token &&
        other.createTime == createTime &&
        other.flag == flag;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        nickname.hashCode ^
        pictureUrl.hashCode ^
        isHost.hashCode ^
        token.hashCode ^
        createTime.hashCode ^
        flag.hashCode;
  }
}
