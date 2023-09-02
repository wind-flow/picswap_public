import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picswap/app/manager/constants.dart';

extension ImageExtension on String {
  String toImagePath() {
    return '${AppConstants.imagePrefix}$this';
  }

  Widget toSvgWidget({
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
  }) {
    return SvgPicture.asset(
      toImagePath(),
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
    );
  }

  Widget toAssetWidget({
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
  }) {
    return Image.asset(
      toImagePath(),
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
    );
  }
}
