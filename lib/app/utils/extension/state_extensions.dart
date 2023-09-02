import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

extension StateExtension on State {
  void showLoading(bool show) {
    if (show) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }
  }
}
