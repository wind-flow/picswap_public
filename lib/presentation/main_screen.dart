import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:picswap/app/component/custom_text_form_field.dart';
import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/app/manager/admob/admob_manager.dart';
import 'package:picswap/app/manager/asset_manager.dart';
import 'package:picswap/app/manager/constants.dart';
import 'package:picswap/app/manager/routes.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/main.dart';

import 'package:picswap/presentation/component/dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/manager/colors_manager.dart';
import '../app/manager/enums.dart';
import '../app/manager/storage/preference_storage.dart';

import '../domain/provider/firebase/firebase_realtime_provider.dart';
import '../domain/provider/room_provider.dart';
import '../domain/provider/user_item_provider.dart';
import '../domain/provider/user_provider.dart';
import 'component/default_appbar.dart';

String forceExitRoomId = '';

@immutable
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin, AfterLayoutMixin<MainScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _roomIdController = TextEditingController();
  String roomId = '';
  String? nickname;
  GlobalKey key = GlobalKey();

  bool selected = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.text = ref.read(userProvider).nickname;

    init();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    final regex = RegExp('${AppStrings.privacy}|${AppStrings.terms}');

    // ignore: avoid_single_cascade_in_expression_statements
    CustomDialog(
      context: context,
      btnOkText: AppStrings.agree,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppStrings.EULATitle.text.align(TextAlign.center).xl2.make(),
            const Divider(
              thickness: 3,
            ),
            AppStrings.EULAContent.text.make(),
            const SizedBox(height: AppSize.s24),
            Text.rich(
              buildTextSpan(context, AppStrings.EUCLContentLink, regex),
            )
          ],
        ).pSymmetric(h: AppSize.s16),
      ),
      btnOkOnPress: () {},
    );

    final pref = await ref.watch(preferenceStorageProvider);
    final isFirst = pref.getBool('isFirst') ?? true;
    if (isFirst) {
      pref.setBool('isFirst', false);
    }
  }

  @override
  void dispose() {
    super.dispose();

    // _banner.dispose();
  }

  init() async {
    //watch면 에러남
    // ref.watch(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider);
    final userItem = ref.watch(userItemProvider);

    return DefaultLayout(
      appBar: defaultAppbar(
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(AppRoutesPath.storeRoute);
              },
              icon: const Icon(Icons.store)),
          IconButton(
              onPressed: () {
                context.pushNamed(AppRoutesPath.settingRoute);
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      child: SafeArea(
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSize.s48),
            // logo
            ImageAsset.mainLogoPink.toSvgWidget(
              height: size.height * 0.15,
              width: size.width,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppSize.s72),
            // set nickname part
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4), // 그림자 색상
                          spreadRadius: -15.0, // 그림자 확산 범위
                          blurRadius: 40.0, // 그림자 흐림 정도
                          offset: const Offset(0, 10), // 그림자 위치 (가로, 세로)
                        ),
                      ],
                    ),
                    child: CustomTextFormField(
                        maxLength: 30,
                        controller: _nicknameController,
                        suffixIcon: AbsorbPointer(
                            absorbing: _nicknameController.text.isEmpty,
                            child: IconButton(
                                onPressed: () async {
                                  try {
                                    nickname = await ref
                                        .read(userProvider.notifier)
                                        .getNickname(locale: locale);

                                    ref
                                        .read(userProvider.notifier)
                                        .setNickname(nickname!);
                                    setState(() {
                                      _nicknameController.text = nickname!;
                                    });
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: AppStrings.errorGenNickname);
                                  }
                                },
                                icon: const Icon(Icons.autorenew_outlined))),
                        onChanged: (val) {}),
                  ),
                ),
                IconButton(
                    iconSize: AppSize.s36,
                    icon: Icon(Icons.check,
                        color: _nicknameController.text.isEmpty
                            ? AppColor.grey4Color
                            : AppColor.primaryColor),
                    onPressed: () async {
                      ref
                          .read(userProvider.notifier)
                          .setNickname(_nicknameController.text);
                    }),
              ],
            ),
            const SizedBox(height: AppSize.s24),
            // room create button
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                infoButton(
                    AppStrings.createRoom,
                    [user.nickname, user.token, user.uuid]
                            .any((element) => element.isNullOrEmpty())
                        ? null
                        : () async {
                            CustomDialog(
                                context: context,
                                title: AppStrings.noticeConsumeToken(
                                    userItem: userItem),
                                btnOkOnPress: () async {
                                  try {
                                    roomId = await generateRoomId();

                                    await ref
                                        .read(userItemProvider.notifier)
                                        .consumeToken();

                                    await ref
                                        .read(roomInfoProvider(roomId).notifier)
                                        .createRoom();

                                    // ref
                                    //     .read(fbAnalytics)
                                    //     .sendEvent('create Room', {
                                    //   'time': enterRoomTime,
                                    //   'screen': 'main_screen',
                                    //   'uuid': user.uuid,
                                    //   'leftTokenFree':
                                    //       userItem.token.tokenFree,
                                    //   'leftTokenPurchase':
                                    //       userItem.token.tokenPurchase
                                    // });

                                    if (mounted) {
                                      context.pushNamed(AppRoutesPath.swapRoute,
                                          pathParameters: {'roomId': roomId});
                                    }
                                  } catch (e) {
                                    debugPrint(e.toString());
                                    Fluttertoast.showToast(msg: e.toString());
                                  }
                                },
                                btnCancelOnPress: () {});
                          }),

                // room join button
                infoButton(
                    AppStrings.joinRoom,
                    [user.nickname, user.token, user.uuid]
                            .any((element) => element.isNullOrEmpty())
                        ? null
                        : () {
                            AwesomeDialog(
                                context: context,
                                animType: AnimType.scale,
                                dialogType: DialogType.noHeader,
                                btnOkColor: AppColor.primaryColor,
                                btnCancelColor: AppColor.grey1Color,
                                btnCancelText: AppStrings.cancel,
                                btnOkText: AppStrings.join,
                                body: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('${AppStrings.roomNo} : ',
                                            style: const TextStyle(
                                                fontSize: AppSize.s16)),
                                        Expanded(
                                            child: TextField(
                                          controller: _roomIdController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            setState(() {
                                              roomId = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintText:
                                                  AppStrings.enterRoomNumber,
                                              suffixIcon: IconButton(
                                                onPressed:
                                                    _roomIdController.clear,
                                                icon: const Icon(Icons.clear),
                                                color: AppColor.primaryColor,
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: AppColor.primaryColor,
                                              ))),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                                title: AppStrings.joinRoom,
                                btnOkOnPress: () async {
                                  try {
                                    if (roomId.isNullOrEmpty()) {
                                      Fluttertoast.showToast(
                                          msg: AppStrings.enterRoomNumber);
                                      return;
                                    }

                                    await ref
                                        .read(roomInfoProvider(roomId).notifier)
                                        .joinRoom();

                                    if (!mounted) return;

                                    await context.pushNamed(
                                      AppRoutesPath.swapRoute,
                                      pathParameters: {'roomId': roomId},
                                    );
                                  } catch (e) {
                                    debugPrint(e.toString());
                                    Fluttertoast.showToast(msg: e.toString());
                                  }
                                },
                                btnCancelOnPress: () {
                                  setState(() {
                                    _roomIdController.clear();
                                  });
                                }).show();
                          }),
              ],
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       print(userItem.toString());
            //     },
            //     child: const Text('Go DevScreen')),
            const SizedBox(height: AppSize.s36),

            SizedBox(
              height: AppSize.s60,
              width: AppSize.s12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.grey4Color),
                      onPressed: () {
                        context.pushNamed(AppRoutesPath.tutorialRoute);
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.help_center_outlined, size: AppSize.s36),
                          Spacer(),
                          Text('Tutorial'),
                        ],
                      )),
                ],
              ),
            ),
            const Spacer(),
            // const SizedBox(child: AdmobManager(adType: AdType.native)),
            const SizedBox(child: AdmobManager(adType: AdType.banner)),
          ],
        ),
      ).pSymmetric(h: AppSize.s24),
    );
  }

  Future<String> generateRoomId() async {
    final random = Random();
    const idLength = 10;
    DatabaseEvent snapshot;
    String roomId;

    do {
      final roomNumberInt = random.nextInt(1000000000); // pow(10, idLength);
      roomId = roomNumberInt.toString().padLeft(idLength, '0');
      try {
        final rtdb = ref.watch(fbrtdbRoomProvider);
        snapshot =
            await rtdb.roomRef.orderByChild('roomId').equalTo(roomId).once();
      } on FirebaseException catch (e) {
        debugPrint(e.toString());
        throw e.toString();
      } catch (e) {
        debugPrint(e.toString());
        throw e.toString();
      }
    } while (snapshot.snapshot.exists);

    return roomId;
  }

  SizedBox infoButton(String info, VoidCallback? onPressed) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.pink1Color,
            foregroundColor: AppColor.white1Color),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              info,
              style: const TextStyle(fontSize: AppSize.s24),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan buildTextSpan(BuildContext context, String eclu, RegExp regex) {
    final List<TextSpan> children = [];

    final matches = regex.allMatches(eclu);

    int currentPosition = 0;

    for (final match in matches) {
      final matchText = match.group(0); // 매치된 텍스트
      final matchStart = match.start; // 매치의 시작 위치

      // 정규표현식 이전 텍스트를 추가 (하이퍼링크 아님)
      final beforeMatchText = eclu.substring(currentPosition, matchStart);
      if (beforeMatchText.isNotEmpty) {
        children.add(TextSpan(text: beforeMatchText));
      }

      // 정규표현식에 매치되는 텍스트를 하이퍼링크로 추가
      children.add(
        TextSpan(
          text: matchText,
          style: const TextStyle(
            color: AppColor.grey4Color,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (matchText == AppStrings.privacy) {
                final privacy = Uri.parse(AppConstants.privacyPolicyUrl);
                launchUrl(privacy);
              } else if (matchText == AppStrings.terms) {
                final terms = Uri.parse(AppConstants.termsAndConditionsUrl);
                launchUrl(terms);
              }
              // 특정 패턴을 터치했을 때 실행할 동작을 여기에 추가
              // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage()));
            },
        ),
      );

      currentPosition = match.end; // 다음 검색 위치 설정
    }

    // 나머지 텍스트 추가
    final remainingText = eclu.substring(currentPosition);
    if (remainingText.isNotEmpty) {
      children.add(TextSpan(text: remainingText));
    }

    return TextSpan(children: children);
  }
}
