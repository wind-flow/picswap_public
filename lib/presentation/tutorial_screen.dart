import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/app/manager/asset_manager.dart';
import 'package:picswap/app/manager/colors_manager.dart';
import 'package:picswap/app/manager/routes.dart';
import 'package:picswap/app/manager/storage/preference_storage.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';
import 'package:picswap/main.dart';
import 'package:velocity_x/velocity_x.dart';

import '../domain/provider/user_provider.dart';

class TutorialGuideScreen extends ConsumerStatefulWidget {
  const TutorialGuideScreen({super.key});

  @override
  ConsumerState<TutorialGuideScreen> createState() =>
      _TutorialGuideScreenState();
}

class _TutorialGuideScreenState extends ConsumerState<TutorialGuideScreen> {
  int currentIdx = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      await init();
    });
    FlutterNativeSplash.remove();
    super.initState();
  }

  Future<void> init() async {
    ref.read(userProvider.notifier).setInit();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentIdx = value;
                    });
                  },
                  children: [
                    guidePage(
                      imageAsset: ImageAsset.tutorial(locale: locale, step: 1),
                      description: AppStrings.tutorialContent1,
                    ),
                    guidePage(
                      imageAsset: ImageAsset.tutorial(locale: locale, step: 2),
                      description: AppStrings.tutorialContent2,
                    ),
                    guidePage(
                      imageAsset: ImageAsset.tutorial(locale: locale, step: 3),
                      description: AppStrings.tutorialContent3,
                    ),
                    guidePage(
                      imageAsset: ImageAsset.tutorial(locale: locale, step: 4),
                      description: AppStrings.tutorialContent4,
                    ),
                    guidePage(
                      imageAsset: ImageAsset.tutorial(locale: locale, step: 5),
                      description: AppStrings.tutorialContent5,
                    ),
                  ],
                ).pSymmetric(h: AppPadding.p16),
              ),
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Center(
                    child: DotsIndicator(
                      dotsCount: 5,
                      position: currentIdx,
                      decorator: const DotsDecorator(
                        color: AppColor.grey1Color, // Inactive color
                        activeColor: AppColor.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () async {
                        final pref = await ref.watch(preferenceStorageProvider);
                        pref.setBool('isFirstLaunch', false);

                        if (!mounted) return;
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.goNamed(AppRoutesPath.mainRoute);
                        }
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: AppSize.s24,
                            color: AppColor.primaryColor),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget guidePage({
    required String imageAsset,
    required String description,
  }) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Image.asset(
          'assets/images/$imageAsset',
          // fit: BoxFit.fill,
          height: size.height * 0.5,
        ),
        // const Spacer(),
        Center(
          child: Text(
            description,
            style: const TextStyle(fontSize: AppSize.s16),
          ),
        ),
      ],
    );
  }
}
