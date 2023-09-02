import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'item_token_model.g.dart';

@JsonSerializable()
class ItemTokenModel {
  final int tokenFree;
  final int tokenPurchase;

  ItemTokenModel({
    required this.tokenFree,
    required this.tokenPurchase,
  });

  factory ItemTokenModel.init() =>
      ItemTokenModel(tokenFree: 1, tokenPurchase: 0);

  factory ItemTokenModel.fromJson(Map<String, dynamic> json) =>
      _$ItemTokenModelFromJson(json);

  ItemTokenModel copyWith({
    int? tokenFree,
    int? tokenPurchase,
  }) {
    return ItemTokenModel(
      tokenFree: tokenFree ?? this.tokenFree,
      tokenPurchase: tokenPurchase ?? this.tokenPurchase,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokenFree': tokenFree,
      'tokenPurchase': tokenPurchase,
    };
  }

  factory ItemTokenModel.fromMap(Map<String, dynamic> map) {
    return ItemTokenModel(
      tokenFree: map['tokenFree'] as int,
      tokenPurchase: map['tokenPurchase'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'TokenModel(tokenFree: $tokenFree, tokenPurchase: $tokenPurchase)';

  @override
  bool operator ==(covariant ItemTokenModel other) {
    if (identical(this, other)) return true;

    return other.tokenFree == tokenFree && other.tokenPurchase == tokenPurchase;
  }

  @override
  int get hashCode => tokenFree.hashCode ^ tokenPurchase.hashCode;
}
