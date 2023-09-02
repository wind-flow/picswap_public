import 'package:json_annotation/json_annotation.dart';

part 'nickname_model.g.dart';

@JsonSerializable()
class NicknameModel {
  final List<String> words;
  final String seed;
  NicknameModel({
    required this.words,
    required this.seed,
  });

  factory NicknameModel.fromJson(Map<String, dynamic> json) =>
      _$NicknameModelFromJson(json);
}
