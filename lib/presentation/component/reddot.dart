import 'package:flutter/widgets.dart';

import '../../app/manager/colors_manager.dart';

class RedDotWidget extends StatelessWidget {
  const RedDotWidget({super.key, this.top, this.right, this.color});

  final double? top;
  final double? right;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? 6.0,
      right: right ?? 10,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color ?? AppColor.yellow1Color),
      ),
    );
  }
}
