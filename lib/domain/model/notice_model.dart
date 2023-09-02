// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final String title;
  final String content;
  final String timeStamp;
  final int priority;

  NoticeModel({
    required this.title,
    required this.content,
    required this.timeStamp,
    this.priority = 9999,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);

  NoticeModel copyWith({
    String? title,
    String? content,
    String? timeStamp,
    int? priority,
  }) {
    return NoticeModel(
      title: title ?? this.title,
      content: content ?? this.content,
      timeStamp: timeStamp ?? this.timeStamp,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'timeStamp': timeStamp,
      'priority': priority,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'NoticeModel(title: $title, content: $content, timeStamp: $timeStamp, priority: $priority)';
  }

  @override
  bool operator ==(covariant NoticeModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.content == content &&
        other.timeStamp == timeStamp &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        timeStamp.hashCode ^
        priority.hashCode;
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      title: map['title'] as String,
      content: map['content'] as String,
      timeStamp: map['timeStamp'] as String,
      priority: map['priority'] as int,
    );
  }
}
