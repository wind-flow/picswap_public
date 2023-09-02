import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:picswap/app/manager/enums.dart';

part 'item_store_model.g.dart';

@JsonSerializable()
class ItemInfoModel {
  final ItemGrade itemGrade;
  final int needCoin;
  final int itemCount;
  final ItemType itemType;

  ItemInfoModel({
    required this.itemGrade,
    required this.needCoin,
    required this.itemCount,
    this.itemType = ItemType.token,
  });

  factory ItemInfoModel.init() =>
      ItemInfoModel(itemGrade: ItemGrade.bronze, needCoin: 0, itemCount: 0);

  factory ItemInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ItemInfoModelFromJson(json);

  ItemInfoModel copyWith({
    ItemGrade? itemGrade,
    int? needCoin,
    int? itemCount,
    ItemType? itemType,
  }) {
    return ItemInfoModel(
      itemGrade: itemGrade ?? this.itemGrade,
      needCoin: needCoin ?? this.needCoin,
      itemCount: itemCount ?? this.itemCount,
      itemType: itemType ?? this.itemType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemGrade': itemGrade,
      'needCoin': needCoin,
      'itemCount': itemCount,
      'itemType': itemType.index,
    };
  }

  factory ItemInfoModel.fromMap(Map<String, dynamic> map) {
    return ItemInfoModel(
        itemGrade: ItemGrade.values.byName(map['itemGrade'] as String),
        needCoin: map['needCoin'] as int,
        itemCount: map['itemCount'] as int,
        itemType: ItemType.values.byName(map['itemType'] as String));
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ItemInfoModel(itemGrade: $itemGrade, needCoin: $needCoin, itemCount: $itemCount, itemType: $itemType)';
  }

  @override
  bool operator ==(covariant ItemInfoModel other) {
    if (identical(this, other)) return true;

    return other.itemGrade == itemGrade &&
        other.needCoin == needCoin &&
        other.itemCount == itemCount &&
        other.itemType == itemType;
  }

  @override
  int get hashCode {
    return itemGrade.hashCode ^
        needCoin.hashCode ^
        itemCount.hashCode ^
        itemType.hashCode;
  }
}
