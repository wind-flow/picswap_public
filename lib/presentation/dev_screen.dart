import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/app/manager/colors_manager.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../app/manager/admob/admob_manager.dart';
import '../app/manager/enums.dart';
import '../app/utils/in_app_review.dart';

class DevScreen extends ConsumerStatefulWidget {
  const DevScreen({super.key});

  @override
  ConsumerState<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends ConsumerState<DevScreen> {
  final GlobalKey _openingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _createTutorial();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: 'dev',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                  key: _openingKey,
                  onPressed: () async {},
                  child: const Text('openning')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdmobManager(
                                  adType: AdType.interstitial,
                                )));
                  },
                  child: const Text('InitiateTest')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AdmobManager(
                        adType: AdType.rewarded,
                        // func: ref.read(userProvider.notifier).addCoin,
                      );
                    }));
                  },
                  child: const Text('Reward 광고보고 ticket 얻기')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdmobManager(
                                  adType: AdType.rewardedInterstitial,
                                  // func: ref.read(userProvider.notifier).addCoin,
                                )));
                  },
                  child: const Text('RewardInterstitial')),
              ElevatedButton(
                  onPressed: () async {
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  },
                  child: const Text('request App Review')),
              ElevatedButton(onPressed: () {}, child: const Text('state ++')),
              // ElevatedButton(
              //     onPressed: () async {
              //     },
              //     child: const Text('Native')),
            ],
          ),
        ));
  }

  void _createTutorial() {
    final targets = [
      TargetFocus(
          identify: 'opening button',
          keyTarget: _openingKey,
          alignSkip: Alignment.bottomCenter,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) => Text(
                'hihihi',
                style: TextStyle(color: AppColor.white1Color),
              ),
            )
          ])
    ];

    final tutoral = TutorialCoachMark(
        targets: targets,
        // colorShadow: Colors.black,
        onFinish: () {
          print('finish');
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          print("target: $target");
          print(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickTarget: (target) {
          print(target);
        },
        onSkip: () {
          print("skip");
        })
      ..show(context: context);
  }
}
