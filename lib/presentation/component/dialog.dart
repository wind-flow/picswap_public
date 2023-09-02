import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../app/manager/colors_manager.dart';
import '../../app/manager/string_manager.dart';

// ignore: non_constant_identifier_names
AwesomeDialog CustomDialog(
    {required BuildContext context,
    String? title,
    String? btnOkText,
    String? desc,
    Widget? body,
    required void Function()? btnOkOnPress,
    void Function()? btnCancelOnPress}) {
  return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      btnOkColor: AppColor.primaryColor,
      btnCancelColor: AppColor.grey1Color,
      btnCancelText: AppStrings.cancel,
      btnOkText: btnOkText ?? AppStrings.ok,
      title: title,
      desc: desc,
      body: body,
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: btnCancelOnPress)
    ..show();
}
