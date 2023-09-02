import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:picswap/app/manager/enums.dart';

import 'chat_model.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  @JsonSerializable(explicitToJson: true)
  factory ReportModel({
    required String id,
    required String me,
    required String target,
    required ReportType type,
    required String? content,
    required List<ChatModel>? chat,
    String? reportTime,
  }) = _ReportModel;

  factory ReportModel.init() {
    return ReportModel(
        id: '',
        me: '',
        target: '',
        type: ReportType.abuse,
        content: '',
        chat: []);
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}
