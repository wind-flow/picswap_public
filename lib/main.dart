import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:picswap/app/component/localization_widget.dart';
import 'package:picswap/app/manager/asset_manager.dart';
import 'package:picswap/app/manager/colors_manager.dart';
import 'package:picswap/app/manager/firebase/firebase_manager.dart';
import 'package:picswap/app/manager/font_manager.dart';
import 'package:picswap/app/manager/notification/local_notification_manager.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/firebase_options.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:upgrader/upgrader.dart';
import 'app/manager/firebase/firebase_crashlytics_manager.dart';
import 'app/manager/routes.dart';
import 'app/utils/log.dart';
import 'presentation/main_screen.dart';

String locale = '';

Future<void> main() async {
  runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      debugPrint('Data connection is available.');
    } else {
      debugPrint(AppStrings.errorNetworkCantConnect.localize());
      Future.delayed(const Duration(seconds: 5), () {
        Fluttertoast.showToast(
            msg: AppStrings.errorNetworkCantConnect.localize());
      }).then((value) => Platform.isIOS ? exit(0) : SystemNavigator.pop());
    }

    //todo: token 로컬을 위해 isar 셋팅하자
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await EasyLocalization.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await LocalNotificationManager.initializeLocalNotification();
    await MobileAds.instance.initialize();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Upgrader.sharedInstance.initialize();
    await Upgrader.clearSavedSettings();

    // if (kDebugMode) {
    //   // Only for debug mode.
    //   try {
    //     final emulatorHost = defaultTargetPlatform == TargetPlatform.android
    //         ? "10.0.2.2"
    //         : "localhost";
    //     FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
    //     FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    //     FirebaseFunctions.instance.useFunctionsEmulator(emulatorHost, 5001);
    //     FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    //   } catch (e) {
    //     // ignore: avoid_print
    //     print(e);
    //   }
    // }

    // await Hive.initFlutter();

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) return stack.vmTrace;
      if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
      return stack;
    };
    runApp(Builder(builder: (context) {
      return const ProviderScope(
        observers: [
          // LoggerProvider(),
        ],
        child: LocalizationWidget(
          child: _App(),
        ),
      );
    }));
  }, (error, stack) async {
    Log.e(error);
    Log.e(stack);
    FirebaseCrashlyticsManager.recordError(error, stack);

    await FirebaseFunctions.instance
        .httpsCallable('forceExit')
        .call({'roomId': forceExitRoomId});
  });
}

class _App extends ConsumerStatefulWidget {
  const _App();

  @override
  ConsumerState<_App> createState() => _AppState();
}

class _AppState extends ConsumerState<_App> {
  @override
  void initState() {
    FlutterError.onError = (FlutterErrorDetails details) {};

    MobileAds.instance.updateRequestConfiguration(RequestConfiguration());
    Future.delayed(Duration.zero, () async => await init());

    super.initState();
  }

  Future<void> init() async {
    await FirebaseManager.initializeFirebase(ref);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    locale = EasyLocalization.of(context)!.currentLocale.toString();

    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.2,
      overlayWidget: overlayWidget(),
      child: MaterialApp.router(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            fontFamily: AppFont.fontFamily,
            primaryColor: AppColor.primaryColor,
            textTheme: const TextTheme(
                displaySmall: TextStyle(
              fontSize: AppSize.s20,
              fontWeight: FontWeight.w500,
            ))),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateTitle: (_) => 'app_name'.localize(),
        routerConfig: router,
      ),
    );
  }

  Widget overlayWidget() {
    return const Center(
      child: SizedBox(
        width: AppSize.s60,
        height: AppSize.s60,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulseSync,
          colors: [AppColor.primaryColor],
          strokeWidth: 3,
        ),
      ),
    );
  }
}
