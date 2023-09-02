import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle? {
  TextStyle? withOpacity(
    BuildContext context,
    double opacity,
  ) {
    Color? color = this?.color ?? DefaultTextStyle.of(context).style.color;
    return this?.copyWith(color: color?.withOpacity(opacity));
  }

  TextStyle? withColor(
    BuildContext context,
    Color color,
  ) {
    return this?.copyWith(color: color);
  }
}
