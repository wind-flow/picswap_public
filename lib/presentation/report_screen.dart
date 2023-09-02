// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/model/report_model.dart';

import 'package:picswap/domain/provider/room_provider.dart';
import 'package:picswap/domain/provider/user_provider.dart';
import 'package:picswap/presentation/component/default_appbar.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/domain/model/room_model.dart';

import '../app/manager/colors_manager.dart';
import '../app/manager/enums.dart';
import '../app/utils/log.dart';
import '../domain/model/chat_model.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({
    super.key,
    required this.report,
    required this.room,
    required this.chatlist,
  });

  final ReportModel? report;
  final RoomModel? room;
  final List<ChatModel>? chatlist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen>
    with AfterLayoutMixin {
  ReportType _reportType = ReportType.abuse;
  final TextEditingController _reportTextController = TextEditingController();
  ReportModel report = ReportModel.init();

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    report = report.copyWith(chat: widget.chatlist);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    report = report.copyWith(
      id: widget.room!.id,
      me: user.uuid,
      target: user.isHost ? widget.room!.guest!.uuid : widget.room!.host!.uuid,
      chat: widget.chatlist,
    );

    return DefaultLayout(
      appBar: defaultAppbar(
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(roomInfoProvider(widget.room!.id).notifier)
                        .postReport(report);

                    Fluttertoast.showToast(msg: AppStrings.ok);
                    if (mounted) {
                      context.pop();
                    }
                  } catch (e, s) {
                    Log.d(s);
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
                icon: const Icon(Icons.send))
          ],
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                'Room ID : '.text.gray500.make(),
                widget.room!.id.text.gray500.make(),
              ],
            ).pSymmetric(v: AppPadding.p24),
            Row(
              children: [
                'YourID : '.text.gray500.make(),
                user.isHost
                    ? widget.room!.host!.uuid.text.gray500.make()
                    : widget.room!.guest!.uuid.text.gray500.make(),
              ],
            ),
            Row(
              children: [
                'Target ID : '.text.gray500.make(),
                user.isHost
                    ? widget.room!.guest!.uuid.text.gray500.make()
                    : widget.room!.host!.uuid.text.gray500.make(),
              ],
            ).pSymmetric(v: AppPadding.p24),
            Align(
                alignment: AlignmentDirectional.centerStart,
                child:
                    AppStrings.noticeReport.text.align(TextAlign.left).make()),
            DropdownButton(
              isExpanded: true,
              items: ReportType.values
                  .map((e) => DropdownMenuItem(
                        value: e.name,
                        child: Text(
                          e.name.toString().localize(),
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _reportType = ReportType.values
                      .firstWhere((element) => element.name == val);
                  report = report.copyWith(type: _reportType);
                });
              },
              value: _reportType.name,
            ).pSymmetric(h: AppPadding.p12),
            if (_reportType == ReportType.etc)
              SizedBox(
                width: double.infinity,
                height: 240,
                child: TextFormField(
                  controller: _reportTextController,
                  onChanged: (val) {
                    setState(() {
                      report = report.copyWith(content: val);
                    });
                  },
                  maxLength: 400,
                  maxLines: 10,
                  style: const TextStyle(color: AppColor.black1Color),
                  decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(AppSize.s12),
                      hintText: '',
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide()),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide())),
                ),
              ).pSymmetric(h: AppSize.s12),
          ],
        ).pSymmetric(h: AppPadding.p18),
      ),
    );
  }
}
