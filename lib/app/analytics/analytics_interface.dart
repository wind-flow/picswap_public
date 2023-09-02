import 'package:flutter/material.dart';

abstract class AnalyticsInterface {
  NavigatorObserver getNavigatorObserver();
  void sendEvent(String eventName, Map<String, Object>? parameters);
}
