// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';

// class CommonNavigatorObserver extends RouteObserver<ModalRoute<dynamic>> {
//   CommonNavigatorObserver(
//     this.onScreenChanged,
//   );

//   final nameExtractor = defaultNameExtractor;
//   final routeFilter = defaultRouteFilter;
//   final Function(String) onScreenChanged;

//   void _sendScreenView(Route<dynamic> route) {
//     final String? screenName = nameExtractor(route.settings);
//     if (screenName != null) {
//       onScreenChanged(screenName);
//     }
//   }

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);
//     if (routeFilter(route)) {
//       _sendScreenView(route);
//     }
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//     if (newRoute != null && routeFilter(newRoute)) {
//       _sendScreenView(newRoute);
//     }
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);
//     if (previousRoute != null && routeFilter(previousRoute) && routeFilter(route)) {
//       _sendScreenView(previousRoute);
//     }
//   }
// }