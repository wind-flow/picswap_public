// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picswap/app/manager/enums.dart';
import 'package:picswap/presentation/tutorial_screen.dart';
import 'package:picswap/presentation/dev_screen.dart';
import 'package:picswap/presentation/my_screen.dart';
import 'package:picswap/presentation/setting/notice_screen.dart';
import 'package:picswap/presentation/setting/setting_screen.dart';
import 'package:picswap/presentation/splash_screen.dart';

import '../../presentation/main_screen.dart';
import '../../presentation/store_screen.dart';
import '../../presentation/swap_screen.dart';
import 'admob/admob_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>(
  (ref) {
    // watch - rebuild when value change
    // read - use if need only function
    // final provider = ref.read(authProvider);

    return GoRouter(
      observers: [
        // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
      ],
      routes: AppRoutes.routes,
      initialLocation: '/${AppRoutesPath.splashRoute}',
      navigatorKey: navigatorKey,
    );
  },
);

class AppRoutes {
  static List<GoRoute> get routes => [
        GoRoute(
          path: '/${AppRoutesPath.splashRoute}',
          name: AppRoutesPath.splashRoute,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/${AppRoutesPath.mainRoute}',
          name: AppRoutesPath.mainRoute,
          builder: (_, __) => const MainScreen(),
        ),
        GoRoute(
            path: '/${AppRoutesPath.swapRoute}/:roomId',
            name: AppRoutesPath.swapRoute,
            builder: (_, state) => SwapScreen(
                  roomId: state.pathParameters['roomId']!,
                )),
        GoRoute(
            path: '/${AppRoutesPath.admobRoute}/:adType/:func',
            name: AppRoutesPath.admobRoute,
            builder: (_, state) {
              return AdmobManager(
                adType: AdType.values.byName(state.pathParameters['adType']!),
              );
            }),
        GoRoute(
            path: '/${AppRoutesPath.settingRoute}',
            name: AppRoutesPath.settingRoute,
            builder: (_, state) {
              return const SettingScreen();
            },
            routes: [
              GoRoute(
                  path: AppRoutesPath.noticeRoute,
                  name: AppRoutesPath.noticeRoute,
                  builder: (_, state) => const NoticeScreen()),
            ]),
        GoRoute(
            path: '/${AppRoutesPath.developerRoute}',
            name: AppRoutesPath.developerRoute,
            builder: (_, state) {
              return const DevScreen();
            }),
        GoRoute(
            path: '/${AppRoutesPath.tutorialRoute}',
            name: AppRoutesPath.tutorialRoute,
            pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const TutorialGuideScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                        position: animation.drive(tween), child: child);
                  },
                )),
        GoRoute(
            path: '/${AppRoutesPath.storeRoute}',
            name: AppRoutesPath.storeRoute,
            pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const StoreScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                        position: animation.drive(tween), child: child);
                  },
                )),
        // GoRoute(
        //     path: '/${AppRoutesPath.myRoute}',
        //     name: AppRoutesPath.myRoute,
        //     pageBuilder: (context, state) => CustomTransitionPage(
        //           key: state.pageKey,
        //           child: const MyProfileScreen(),
        //           transitionsBuilder:
        //               (context, animation, secondaryAnimation, child) {
        //             const begin = Offset(0.0, 1.0);
        //             const end = Offset.zero;
        //             const curve = Curves.ease;

        //             var tween = Tween(begin: begin, end: end)
        //                 .chain(CurveTween(curve: curve));

        //             return SlideTransition(
        //                 position: animation.drive(tween), child: child);
        //           },
        //         )),
      ];
}

class AppRoutesPath {
  static const String splashRoute = 'Splash';

  static const String mainRoute = 'Main';
  static const String tutorialRoute = 'Tutorial';

  static const String swapRoute = 'Swap';

  static const String myRoute = 'my';
  static const String storeRoute = 'store';
  static const String settingRoute = 'setting';
  static const String noticeRoute = 'notice';

  static const String admobRoute = 'Admob';

  static const String developerRoute = 'developer';
  static const String developerUserRoute = 'developer/user';
  static const String developerLogRoute = 'developer/log';
}
