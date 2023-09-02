// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:picswap/app/manager/firebase/firebase_analytics_manager.dart';

// class AnalyticsManager {
//   static final services = [
//     FirebaseAnalyticsManager(),
//   ];

//   static List<NavigatorObserver> getNavigatorObservers() {
//     if (_isProduction()) {
//       return services.map((element) => element.getNavigatorObserver()).toList();
//     }
//     return List.empty();
//   }

//   static void sendEvent(String eventName, Map<String, Object>? parameters) {
//     if (_isProduction()) {
//       for (final element in services) {
//         element.sendEvent(eventName, parameters);
//       }
//     }
//   }

//   static bool _isProduction() {
//     return kReleaseMode && true; //Config.instance.isProd;
//   }
// }
