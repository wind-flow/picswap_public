import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picswap/app/manager/asset_manager.dart';
import 'package:picswap/app/manager/colors_manager.dart';
import 'package:picswap/app/manager/routes.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/model/remote_config_model.dart';
import 'package:upgrader/upgrader.dart';

import '../app/manager/admob/app_open_ad_manager.dart';
import '../app/manager/constants.dart';
import '../app/manager/firebase/firebase_remote_config_manager.dart';
import '../domain/provider/user_item_provider.dart';
import '../domain/provider/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  RemoteConfigModel remoteConfig = RemoteConfigModel.init();
  final Appcast appcast = Appcast();
  String _authStatus = 'Unknown';

  final Upgrader upgrader = Upgrader(
    appcastConfig: AppcastConfiguration(
      url: AppConstants.appcastUrl,
      supportedOS: ['android'],
    ),
    debugLogging: !kReleaseMode,
    canDismissDialog: true,
    // messages: OtherMessages(),
    shouldPopScope: () => true,
    showIgnore: false,
    dialogStyle: Platform.isAndroid
        ? UpgradeDialogStyle.material
        : UpgradeDialogStyle.cupertino,
    showLater: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //Load AppOpen Ad
    appOpenAdManager.loadAd();

    Future.delayed(const Duration(seconds: 1)).then(
      (value) async {
        remoteConfig = FirebaseRemoteConfigManager.getVersionInfo();

        await init();

        appcast.parseAppcastItemsFromUri(AppConstants.appcastUrl);
        await upgrader.initialize();

        FlutterNativeSplash.remove();
        appOpenAdManager.showAdIfAvailable();

        upgrader.minAppVersion = remoteConfig.minVersion;

        if (compareVersions(remoteConfig.minVersion,
                Upgrader.sharedInstance.currentInstalledVersion()!) <=
            0) {
          if (!mounted) return;
          context.goNamed(AppRoutesPath.mainRoute);
        }
      },
    );
  }

  Future<void> init() async {
    await ref.read(userProvider.notifier).setInit();
    await ref.read(userItemProvider.notifier).getUserItemInfo();

    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      debugPrint("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: UpgradeAlert(
        upgrader: upgrader,
        child: Container(
          height: size.height,
          width: size.width,
          color: AppColor.primaryColor,
          // child: const Center(child: Text('splash')),
          child: Center(child: ImageAsset.splashLogo.toSvgWidget()),
        ),
      ),
    );
  }
}
