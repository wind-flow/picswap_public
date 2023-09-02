import 'package:flutter/material.dart';
import 'package:picswap/app/manager/font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFmaily, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFmaily,
    color: color,
  );
}

// regular text style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, AppFont.fontFamily, FontWeightManager.regular, color);
}

// light text style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, AppFont.fontFamily, FontWeightManager.light, color);
}

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, AppFont.fontFamily, FontWeightManager.medium, color);
}

// semi text style
TextStyle getSemiStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, AppFont.fontFamily, FontWeightManager.semiBold, color);
}

// bold text style
TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, AppFont.fontFamily, FontWeightManager.bold, color);
}
