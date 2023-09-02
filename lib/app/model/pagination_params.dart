import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final String? next;

  const PaginationParams({
    this.next,
  });

  PaginationParams copyWith({
    String? next,
    int? count,
  }) {
    return PaginationParams(
      next: next ?? this.next,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
