import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:picswap/app/model/model_with_id.dart';
import 'package:picswap/domain/model/chat_model.dart';

import 'user_model.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel implements IModelWithId {
  @override
  final String id;
  final UserModel? host;
  final String? hostPicUrl;
  final String? hostBlurPicUrl;
  final bool hostIsReady;
  final UserModel? guest;
  final String? guestPicUrl;
  final String? guestBlurPicUrl;
  final bool guestIsReady;
  final bool isDone;
  final int createTimeStamp;
  final int hostActiveTimeStamp;
  final int? guestActiveTimeStamp;

  RoomModel({
    required this.id,
    required this.host,
    this.hostPicUrl,
    this.hostBlurPicUrl,
    this.hostIsReady = false,
    this.guest,
    this.guestPicUrl,
    this.guestBlurPicUrl,
    this.guestIsReady = false,
    this.isDone = false,
    required this.createTimeStamp,
    required this.hostActiveTimeStamp,
    this.guestActiveTimeStamp,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  RoomModel copyWith({
    String? id,
    UserModel? host,
    String? hostPicUrl,
    String? hostBlurPicUrl,
    bool? hostIsReady,
    UserModel? guest,
    String? guestPicUrl,
    String? guestBlurPicUrl,
    bool? guestIsReady,
    bool? isDone,
    int? createTimeStamp,
    int? hostActiveTimeStamp,
    int? guestActiveTimeStamp,
  }) {
    return RoomModel(
      id: id ?? this.id,
      host: host ?? this.host,
      hostPicUrl: hostPicUrl ?? this.hostPicUrl,
      hostBlurPicUrl: hostBlurPicUrl ?? this.hostBlurPicUrl,
      hostIsReady: hostIsReady ?? this.hostIsReady,
      guest: guest ?? this.guest,
      guestPicUrl: guestPicUrl ?? this.guestPicUrl,
      guestBlurPicUrl: guestBlurPicUrl ?? this.guestBlurPicUrl,
      guestIsReady: guestIsReady ?? this.guestIsReady,
      isDone: isDone ?? this.isDone,
      createTimeStamp: createTimeStamp ?? this.createTimeStamp,
      hostActiveTimeStamp: hostActiveTimeStamp ?? this.hostActiveTimeStamp,
      guestActiveTimeStamp: guestActiveTimeStamp ?? this.guestActiveTimeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'host': host?.toMap(),
      'hostPicUrl': hostPicUrl,
      'hostBlurPicUrl': hostBlurPicUrl,
      'hostIsReady': hostIsReady,
      'guest': guest?.toMap(),
      'guestPicUrl': guestPicUrl,
      'guestBlurPicUrl': guestBlurPicUrl,
      'guestIsReady': guestIsReady,
      'isDone': isDone,
      'createTimeStamp': createTimeStamp,
      'hostActiveTimeStamp': hostActiveTimeStamp,
      'guestActiveTimeStamp': guestActiveTimeStamp,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      host: map['host'] != null
          ? UserModel.fromMap(map['host'] as Map<String, dynamic>)
          : null,
      hostPicUrl:
          map['hostPicUrl'] != null ? map['hostPicUrl'] as String : null,
      hostBlurPicUrl: map['hostBlurPicUrl'] != null
          ? map['hostBlurPicUrl'] as String
          : null,
      hostIsReady: map['hostIsReady'] as bool,
      guest: map['guest'] != null
          ? UserModel.fromMap(map['guest'] as Map<String, dynamic>)
          : null,
      guestPicUrl:
          map['guestPicUrl'] != null ? map['guestPicUrl'] as String : null,
      guestBlurPicUrl: map['guestBlurPicUrl'] != null
          ? map['guestBlurPicUrl'] as String
          : null,
      guestIsReady: map['guestIsReady'] as bool,
      isDone: map['isDone'] as bool,
      createTimeStamp: map['createTimeStamp'] as int,
      hostActiveTimeStamp: map['hostActiveTimeStamp'] as int,
      guestActiveTimeStamp: map['guestActiveTimeStamp'] != null
          ? map['guestActiveTimeStamp'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'RoomModel(id: $id, host: $host, hostPicUrl: $hostPicUrl, hostBlurPicUrl: $hostBlurPicUrl, hostIsReady: $hostIsReady, guest: $guest, guestPicUrl: $guestPicUrl, guestBlurPicUrl: $guestBlurPicUrl, guestIsReady: $guestIsReady, isDone: $isDone, createTimeStamp: $createTimeStamp, hostActiveTimeStamp: $hostActiveTimeStamp, guestActiveTimeStamp: $guestActiveTimeStamp)';
  }

  @override
  bool operator ==(covariant RoomModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.host == host &&
        other.hostPicUrl == hostPicUrl &&
        other.hostBlurPicUrl == hostBlurPicUrl &&
        other.hostIsReady == hostIsReady &&
        other.guest == guest &&
        other.guestPicUrl == guestPicUrl &&
        other.guestBlurPicUrl == guestBlurPicUrl &&
        other.guestIsReady == guestIsReady &&
        other.isDone == isDone &&
        other.createTimeStamp == createTimeStamp &&
        other.hostActiveTimeStamp == hostActiveTimeStamp &&
        other.guestActiveTimeStamp == guestActiveTimeStamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        host.hashCode ^
        hostPicUrl.hashCode ^
        hostBlurPicUrl.hashCode ^
        hostIsReady.hashCode ^
        guest.hashCode ^
        guestPicUrl.hashCode ^
        guestBlurPicUrl.hashCode ^
        guestIsReady.hashCode ^
        isDone.hashCode ^
        createTimeStamp.hashCode ^
        hostActiveTimeStamp.hashCode ^
        guestActiveTimeStamp.hashCode;
  }
}
