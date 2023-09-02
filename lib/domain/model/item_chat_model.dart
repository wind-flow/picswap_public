// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'item_chat_model.g.dart';

@JsonSerializable()
class ItemChatModel {
  final int chatFree;
  final int chatPurchase;

  ItemChatModel({
    required this.chatFree,
    required this.chatPurchase,
  });

  factory ItemChatModel.init() => ItemChatModel(chatFree: 10, chatPurchase: 0);

  factory ItemChatModel.fromJson(Map<String, dynamic> json) =>
      _$ItemChatModelFromJson(json);

  ItemChatModel copyWith({
    int? chatFree,
    int? chatPurchase,
  }) {
    return ItemChatModel(
      chatFree: chatFree ?? this.chatFree,
      chatPurchase: chatPurchase ?? this.chatPurchase,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatFree': chatFree,
      'chatPurchase': chatPurchase,
    };
  }

  factory ItemChatModel.fromMap(Map<String, dynamic> map) {
    return ItemChatModel(
      chatFree: map['chatFree'] as int,
      chatPurchase: map['chatPurchase'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ItemChatModel(chatFree: $chatFree, chatPurchase: $chatPurchase)';

  @override
  bool operator ==(covariant ItemChatModel other) {
    if (identical(this, other)) return true;

    return other.chatFree == chatFree && other.chatPurchase == chatPurchase;
  }

  @override
  int get hashCode => chatFree.hashCode ^ chatPurchase.hashCode;
}
