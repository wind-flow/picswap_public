import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/manager/enums.dart';

part 'chat_model.g.dart';
part 'chat_model.freezed.dart';

@freezed
class ChatModel with _$ChatModel {
  factory ChatModel({
    required String uuid,
    required String senderNickname,
    required String message,
    required int timeStamp,
    required MessageType type,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}
