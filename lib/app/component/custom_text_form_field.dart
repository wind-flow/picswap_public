import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../manager/colors_manager.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatter;
  final bool obscureText;
  final bool autofocus;
  final String? Function(String?)? validator;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextAlign textAlign;
  final Widget? suffixIcon;
  final int? maxLength;

  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.errorText,
    this.inputFormatter,
    this.obscureText = false,
    this.autofocus = false,
    this.validator,
    this.labelText,
    this.controller,
    this.textInputType,
    this.autovalidateMode,
    this.focusNode,
    required this.onChanged,
    this.textAlign = TextAlign.left,
    this.suffixIcon,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.white1Color,
        width: 1.0,
      ),
    );

    return TextFormField(
      focusNode: focusNode,
      maxLength: maxLength,

      autovalidateMode: autovalidateMode,
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColor.white1Color,
      // 비밀번호 입력할때
      obscureText: obscureText,
      inputFormatters: inputFormatter,
      autofocus: autofocus,
      validator: validator,
      onChanged: onChanged,
      textAlign: textAlign,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: AppColor.primaryTextColor,
          fontSize: 14.0,
        ),
        suffixIcon: suffixIcon,
        //          prefixIcon: Icon(
        //   Icons.name,
        //   color: Colors.black54,
        // ),
        errorMaxLines: 5,
        // errorStyle: TextStyle(color: AppColor.primaryColor),
        fillColor: AppColor.grey1Color,
        // false - 배경색 없음
        // true - 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: AppColor.primaryColor,
          ),
        ),
      ),
    );
  }
}
