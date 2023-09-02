import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SecureShot {
  static const _channel = MethodChannel('secureShotChannel');

  static void on() {
    if (Platform.isAndroid) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      _channel.invokeMethod("secureIOS");
    }
  }

  static void off() {
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      _channel.invokeMethod("unSecureIOS");
    }
  }
}
