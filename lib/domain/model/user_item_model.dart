// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:picswap/domain/model/coin_model.dart';
import 'package:picswap/domain/model/item_remove_ad_model.dart';
import 'package:picswap/domain/model/item_token_model.dart';

import 'item_chat_model.dart';

part 'user_item_model.g.dart';

@JsonSerializable()
class UserItemModel {
  final String uuid;
  final CoinModel coin;
  final ItemTokenModel token;
  final ItemChatModel chat;
  final ItemRemoveAdModel removeAd;
  final int flag;

  UserItemModel({
    required this.uuid,
    required this.coin,
    required this.token,
    required this.chat,
    required this.removeAd,
    this.flag = 0,
  });

  factory UserItemModel.init() {
    return UserItemModel(
      coin: CoinModel.init(),
      token: ItemTokenModel.init(),
      uuid: '',
      chat: ItemChatModel.init(),
      removeAd: ItemRemoveAdModel.init(),
    );
  }

  factory UserItemModel.fromJson(Map<String, dynamic> json) =>
      _$UserItemModelFromJson(json);

  UserItemModel copyWith({
    String? uuid,
    CoinModel? coin,
    ItemTokenModel? token,
    ItemChatModel? chat,
    ItemRemoveAdModel? removeAd,
    int? flag,
  }) {
    return UserItemModel(
      uuid: uuid ?? this.uuid,
      coin: coin ?? this.coin,
      token: token ?? this.token,
      chat: chat ?? this.chat,
      removeAd: removeAd ?? this.removeAd,
      flag: flag ?? this.flag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'coin': coin.toMap(),
      'token': token.toMap(),
      'chat': chat.toMap(),
      'removeAd': removeAd.toMap(),
      'flag': flag,
    };
  }

  factory UserItemModel.fromMap(Map<String, dynamic> map) {
    return UserItemModel(
      uuid: map['uuid'] as String,
      coin: CoinModel.fromMap(map['coin'] as Map<String, dynamic>),
      token: ItemTokenModel.fromMap(map['token'] as Map<String, dynamic>),
      chat: ItemChatModel.fromMap(map['chat'] as Map<String, dynamic>),
      removeAd:
          ItemRemoveAdModel.fromMap(map['removeAd'] as Map<String, dynamic>),
      flag: map['flag'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserItemModel(uuid: $uuid, coin: $coin, token: $token, chat: $chat, removeAd: $removeAd, flag: $flag)';
  }

  @override
  bool operator ==(covariant UserItemModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.coin == coin &&
        other.token == token &&
        other.chat == chat &&
        other.removeAd == removeAd &&
        other.flag == flag;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        coin.hashCode ^
        token.hashCode ^
        chat.hashCode ^
        removeAd.hashCode ^
        flag.hashCode;
  }
}
