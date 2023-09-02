import 'package:flutter/material.dart';

class AppColor {
  static const primaryColor = Color(0xFFFF7575);
  static const subPrimaryColor = Color(0xFFFFABAB);

  static const primaryTextColor = black1Color;

  static const green1Color = Color(0xFF1B3B4A);
  static const green2Color = Color(0xFF496674);

  static const grey1Color = Color(0xFFD6D6D6);
  static const grey2Color = Color(0xFFC5C8CE);
  static const grey3Color = Color(0xFFE9EBEE);
  static const grey4Color = Color(0xFF646F7C);
  static const grey5Color = Color(0xFFF5F5F5);
  static const grey6Color = Color(0xFFDBDBDB);
  static const grey7Color = Color(0xFF858585);
  static const grey8Color = Color(0xFFF3F3F3);
  static const grey9Color = Color(0xFFF9F9F9);

  static const black1Color = Color(0xFF000000);
  static const black2Color = Color(0xFF181702);
  static const black3Color = Color(0xFF000000);
  static const black4Color = Color(0xFF231F20);
  static const black5Color = Color(0xFF3D393A);
  static const black6Color = Color(0xFF231916);
  static const black7Color = Color(0xFF1E1E1E);
  static const black8Color = Color(0xFF25282D);
  static const black9Color = Color(0xFF171717);

  // static const Grey1Color = Color(value)

  static const white1Color = Color(0xFFFFFFFF);
  static const white1ColorWithOpacity10 = Color(0x1AFFFFFF);
  static const white1ColorWithOpacity30 = Color(0x4DFFFFFF);
  static const white1ColorWithOpacity34 = Color(0x57FFFFFF);
  static const white1ColorWithOpacity40 = Color(0x66FFFFFF);

  static const red1Color = Color(0xFFFF6247);

  static const pink1Color = Color(0xFFFF7171);
  static const pink2Color = Color(0xFFF03072);
  static const pink3Color = Color(0xFFFFD2D2);

  static const yellow1Color = Color(0xFFFEE500);

  static const transparent = Colors.transparent;

  static const dividerColor = grey3Color;
  static const windowBackgroundColor = Color(0xFFD9D9D9);

  static const avatar1Color = Color(0xFFDF6B00);
  static const avatar2Color = Color(0xFFDFAE00);
  static const avatar3Color = Color(0xFF42C505);
  static const avatar4Color = Color(0xFF04C899);
  static const avatar5Color = Color(0xFF0476C8);
  static const avatar6Color = Color(0xFF003BD1);
  static const avatar7Color = Color(0xFF7500D1);
  static const avatar8Color = Color(0xFFCD00D1);
  static const avatar9Color = Color(0xFFD10064);
  static const splashBackgroundColor = Color(0xFF1A2526);

  static const purple1Color = Color(0xFFbaa3f9);
  static const blue1Color = Color.fromRGBO(28, 196, 204, 1);
  static const blue2Color = Color.fromRGBO(28, 196, 204, 0.1);

  static const red2Color = Color.fromRGBO(240, 48, 114, 0.07);

  static const INPUT_BORDER_COLOR = Color(0xFFF3F2F2);
  static const INPUT_BG_COLOR = Color(0xFFFBFBFB);

  static const avatarColors = [
    avatar1Color,
    avatar2Color,
    avatar3Color,
    avatar4Color,
    avatar5Color,
    avatar6Color,
    avatar7Color,
    avatar8Color,
    avatar9Color,
  ];
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
