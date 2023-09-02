import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'coin_model.g.dart';

@JsonSerializable()
class CoinModel {
  final int coinAd;
  final int coinPurchase;

  CoinModel({
    required this.coinAd,
    required this.coinPurchase,
  });

  factory CoinModel.init() => CoinModel(coinAd: 0, coinPurchase: 0);

  factory CoinModel.fromJson(Map<String, dynamic> json) =>
      _$CoinModelFromJson(json);

  CoinModel copyWith({
    int? coinAd,
    int? coinPurchase,
  }) {
    return CoinModel(
      coinAd: coinAd ?? this.coinAd,
      coinPurchase: coinPurchase ?? this.coinPurchase,
    );
  }

  @override
  String toString() =>
      'CoinModel(coinAd: $coinAd, coinPurchase: $coinPurchase)';

  Map<String, dynamic> toMap() {
    return {
      'coinAd': coinAd,
      'coinPurchase': coinPurchase,
    };
  }

  factory CoinModel.fromMap(Map<String, dynamic> map) {
    return CoinModel(
      coinAd: map['coinAd']?.toInt() ?? 0,
      coinPurchase: map['coinPurchase']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
}
