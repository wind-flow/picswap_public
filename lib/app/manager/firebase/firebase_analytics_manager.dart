// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:picswap/app/analytics/analytics_interface.dart';

// class FirebaseAnalyticsManager implements AnalyticsInterface {
//   static Future<void> initialize() async {
//     await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
//         kReleaseMode && true); //Config.instance.isProd;
//   }

//   @override
//   FirebaseAnalyticsObserver getNavigatorObserver() {
//     return FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
//   }

//   @override
//   void sendEvent(String eventName, Map<String, Object>? parameters) {
//     FirebaseAnalytics.instance
//         .logEvent(name: eventName, parameters: parameters);
//   }
// }
