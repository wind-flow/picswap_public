import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'item_remove_ad_model.g.dart';

@JsonSerializable()
class ItemRemoveAdModel {
  final bool isActive;
  final int startDate;
  final int expiredDate;

  ItemRemoveAdModel({
    required this.isActive,
    required this.startDate,
    required this.expiredDate,
  });

  factory ItemRemoveAdModel.fromJson(Map<String, dynamic> json) =>
      _$ItemRemoveAdModelFromJson(json);

  factory ItemRemoveAdModel.init() => ItemRemoveAdModel(
      isActive: false,
      startDate: DateTime.now().millisecondsSinceEpoch,
      expiredDate: DateTime.now().millisecondsSinceEpoch);

  ItemRemoveAdModel copyWith({
    bool? isActive,
    int? startDate,
    int? expiredDate,
  }) {
    return ItemRemoveAdModel(
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      expiredDate: expiredDate ?? this.expiredDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isActive': isActive,
      'startDate': startDate,
      'expiredDate': expiredDate,
    };
  }

  factory ItemRemoveAdModel.fromMap(Map<String, dynamic> map) {
    return ItemRemoveAdModel(
      isActive: map['isActive'] as bool,
      startDate: map['startDate'] as int,
      expiredDate: map['expiredDate'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ItemRemoveAdModel(isActive: $isActive, startDate: $startDate, expiredDate: $expiredDate)';

  @override
  bool operator ==(covariant ItemRemoveAdModel other) {
    if (identical(this, other)) return true;

    return other.isActive == isActive &&
        other.startDate == startDate &&
        other.expiredDate == expiredDate;
  }

  @override
  int get hashCode =>
      isActive.hashCode ^ startDate.hashCode ^ expiredDate.hashCode;
}
