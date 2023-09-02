import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:picswap/app/manager/colors_manager.dart';

import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/log.dart';
import 'package:picswap/domain/provider/user_item_provider.dart';

import '../enums.dart';
import 'ad_helper.dart';

class AdmobManager extends ConsumerStatefulWidget {
  const AdmobManager({
    Key? key,
    required this.adType,
    this.func,
    this.nativeAdFunc,
  }) : super(key: key);
  final AdType adType;
  final Future<void> Function()? func;
  final void Function(bool)? nativeAdFunc;
  @override
  ConsumerState<AdmobManager> createState() => _AdmobManagerState();
}

class _AdmobManagerState extends ConsumerState<AdmobManager> {
  AppOpenAd? _appOpenAd;
  BannerAd? _banner;

  NativeAd? _nativeAd;
  bool isLoadedNativeAd = false;
  bool isClosedNativeAd = false;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  RewardedInterstitialAd? _rewardedInterstitialAd;

  String test = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    switch (widget.adType) {
      case AdType.opening:
        break;
      case AdType.banner:
        break;
      case AdType.interstitial:
        _loadInterstitialAd();
        break;
      case AdType.native:
        _loadNativeAd();
        break;
      case AdType.rewarded:
        _loadRewardAd();
        break;
      case AdType.rewardedInterstitial:
        _loadRewardedInterstitialAd();
        break;
    }
  }

  void _loadAppOpeningAd() {
    AppOpenAd.load(
      adUnitId: AdHelper.openingAdUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('dismiss');
              context.pop();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: AdHelper.nativeAdUnitId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint(ad.responseInfo?.responseId);
            setState(() {
              isLoadedNativeAd = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            debugPrint('${error.message}, ${error.code}');
            setState(() {
              isClosedNativeAd = !isClosedNativeAd;
            });
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {
            Log.d('onAdClicked ${ad.toString()}');
            setState(() {
              isClosedNativeAd = !isClosedNativeAd;
            });
          },
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {
            Log.d('onAdImpression ${ad.toString()}');
          },
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {
            Log.d('onAdClosed ${ad.toString()}');
            setState(() {
              isClosedNativeAd = !isClosedNativeAd;
            });
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {
            Log.d('onAdOpened ${ad.toString()}');
            setState(() {
              isClosedNativeAd = !isClosedNativeAd;
            });
          },
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {
            Log.d('onAdWillDismissScreen ${ad.toString()}');
          },
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {
            Log.d('onPaidEvent ${ad.toString()}');
          },
        ),
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  void _loadRewardAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  Fluttertoast.showToast(msg: '광고 불러오기 실패');
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  Fluttertoast.showToast(msg: '광고 시청 취소');
                  context.pop();
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {
                  debugPrint(ad.toString());
                });
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            setState(() {
              _rewardedAd = ad;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void _showRewardedAdmob(Future<void> Function()? func) {
    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      await ref.read(userItemProvider.notifier).getCoin();

      debugPrint(reward.type);
      debugPrint(reward.amount.toString());

      // Log.d('hihihi : ${ad.toString()} \n ${reward.toString()} ');
      // print(ad.adUnitId);
      // print(ad.responseInfo?.responseId ?? '');

      context.pop();
    });
  }

  /// Loads a rewarded ad.
  void _loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: AdHelper.rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {
              Log.d(ad.toString());
            },
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {
              Log.d(ad.toString());
              Fluttertoast.showToast(msg: 'onAdImpression');
            },
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              Fluttertoast.showToast(msg: 'Ad Loading is failed');
              // Fluttertoast.showToast(
              //     msg:
              //         '${ad.toString()} ${ad.responseInfo?.loadedAdapterResponseInfo?.adError}');
              setState(() {
                test = 'onAdFailedToShowFullScreenContent';
              });

              context.pop(false);
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              Log.d(ad.toString());
              context.pop();
              // Dispose the ad here to free resources.
              ad.dispose();
            },
          );

          debugPrint('$ad loaded.');

          // Keep a reference to the ad so you can show it later.
          setState(() {
            _rewardedInterstitialAd = ad;
          });
        },

        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError err) {
          setState(() {
            test = 'onAdFailedToLoad';
          });
          debugPrint('${err.toString()} ${err.message} ${err.domain}');

          context.pop(false);

          Log.e(
              '${err.domain} ${err.message} ${err.code} ${err.responseInfo.toString()} ');

          Fluttertoast.showToast(
              msg: 'Failed to load Ad(If you use VPN, try to turn off)');
          debugPrint('RewardedInterstitialAd failed to load: $err');
        },
      ),
    );
  }

  void _showRewardedInterstitalAdmob(Future<void> Function()? func) async {
    await _rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      try {
        debugPrint(reward.type);
        debugPrint(reward.amount.toString());

        await ref.read(userItemProvider.notifier).getCoin(addCoin: 4);

        context.pop();
      } catch (e) {
        throw e.toString();
      }
    });
  }

  @override
  void dispose() {
    switch (widget.adType) {
      case AdType.banner:
        _banner?.dispose();
      case AdType.interstitial:
        _interstitialAd?.dispose();
      case AdType.native:
        _nativeAd?.dispose();
      case AdType.rewarded:
        _rewardedAd?.dispose();
      case AdType.opening:
        _appOpenAd?.dispose();
      case AdType.rewardedInterstitial:
        _rewardedInterstitialAd?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.adType) {
      case AdType.opening:
        _loadAppOpeningAd();
        return Container();
      case AdType.banner:
        _banner = BannerAd(
          listener: BannerAdListener(
            onAdFailedToLoad: (Ad ad, LoadAdError error) {},
            onAdLoaded: (_) {},
          ),
          size: AdSize.banner,
          adUnitId: AdHelper.bannerAdUnitId,
          request: const AdRequest(),
        )..load();

        return SizedBox(
            height: AppSize.s60,
            width: MediaQuery.of(context).size.width,
            child: AdWidget(ad: _banner!));
      case AdType.interstitial:
        _interstitialAd?.show();
        return Container();
      case AdType.native:
        return isLoadedNativeAd
            ? Visibility(
                visible: !isClosedNativeAd,
                child: Stack(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _nativeAd!)),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: AppColor.grey1Color,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isClosedNativeAd = !isClosedNativeAd;
                                });
                              },
                              icon: const Icon(Icons.close)),
                        )),
                  ],
                ),
              )
            : Container();

      case AdType.rewarded:
        _showRewardedAdmob(widget.func);
        return Container();
      case AdType.rewardedInterstitial:
        _showRewardedInterstitalAdmob(widget.func);
        return Container();
    }
  }

  // RewardedInterstitialAd
}
