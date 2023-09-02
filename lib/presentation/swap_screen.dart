import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_debounce/easy_throttle.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/app/manager/colors_manager.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/model/chat_model.dart';
import 'package:picswap/domain/model/report_model.dart';
import 'package:picswap/domain/model/room_model.dart';

import 'package:picswap/domain/provider/room_provider.dart';
import 'package:picswap/domain/provider/user_provider.dart';
import 'package:picswap/presentation/component/reddot.dart';

import 'package:picswap/presentation/error_screen.dart';
import 'package:picswap/presentation/report_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/component/secure_shot.dart';
import '../app/manager/admob/admob_manager.dart';
import '../app/manager/asset_manager.dart';
import '../app/manager/enums.dart';
import '../app/utils/log.dart';
import '../domain/model/user_model.dart';
import 'component/chat_bubbles.dart';
import 'component/default_appbar.dart';
import 'component/image_box.dart';

import 'component/request_permission.dart';
import 'main_screen.dart';

class SwapScreen extends ConsumerStatefulWidget {
  final String roomId;
  const SwapScreen({
    super.key,
    required this.roomId,
  });

  @override
  ConsumerState<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends ConsumerState<SwapScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late final ScrollController _chatScrollController;

  static const _PANEL_HEADER_HEIGHT = 64.0;
  late final AnimationController _animationController;

  String partnerUrl = '';

  Timer? _timer;
  Timer? _activeTimer;
  int showCount = 5;
  int hideCount = 10;

  bool _isNewChatComming = false;
  int _chatListLenght = 0;

  ReportModel? report = ReportModel.init();
  RoomModel? room;
  List<ChatModel>? chatlist;

  @override
  void initState() {
    forceExitRoomId = widget.roomId;

    if (!ref.read(userProvider).pictureUrl.isNullOrEmpty()) {
      ref.read(userProvider.notifier).setUrl(null);
    }

    _chatScrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 100), value: -1, vsync: this);
    SecureShot.on();
    super.initState();
  }

  void _scrollToBottom() {
    _chatScrollController.animateTo(
      _chatScrollController.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _activeTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    SecureShot.off();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        // await FirebaseFunctions.instance.httpsCallable('forceExit').call({
        //   'roomId': widget.roomId,
        //   'user': ref.watch(userProvider).toString()
        // });
        break;
      case AppLifecycleState.hidden:
        debugPrint("app in hidden");
        break;
    }
  }

  void _showCountDown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (showCount < 0) {
          _timer?.cancel();
          ref.read(roomInfoProvider(widget.roomId).notifier).onDone();
        } else {
          // debugPrint('$showCount count?');
          showCount--;
        }
      });
    });
  }

  void _checkDeactiveStatus({
    required UserModel user,
    required RoomModel roomInfo,
  }) {
    _activeTimer?.cancel();
    _activeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final activeTime = roomInfo.guestActiveTimeStamp;

      final timeDiff = DateTime.now().millisecondsSinceEpoch - (activeTime!);

      if (180000 > timeDiff && timeDiff > 90000) {
        EasyThrottle.throttle('deactiveNoti', const Duration(seconds: 100),
            () => Fluttertoast.showToast(msg: AppStrings.deactiveNoti));
      } else if (timeDiff > 180000) {
        _activeTimer?.cancel();

        EasyThrottle.throttle('deactiveExit', const Duration(seconds: 180), () {
          ref.read(roomInfoProvider(widget.roomId).notifier).leaveChatRoom();

          context.pop();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AdmobManager(adType: AdType.interstitial),
            ),
          );
        });
      }
    });
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _animationController.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Animation<RelativeRect> _getPanelAnimation(double size) {
    final double top = size - _PANEL_HEADER_HEIGHT;

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, 0),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final roomController = ref.read(roomInfoProvider(widget.roomId).notifier);

    return WillPopScope(
      onWillPop: () async {
        return await AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                body: Center(
                    child: Text(
                  AppStrings.confirmExit,
                  style: const TextStyle(fontSize: AppSize.s24),
                )),
                btnOkColor: AppColor.primaryColor,
                btnOkOnPress: () async {
                  await roomController.leaveChatRoom();

                  context.pop();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AdmobManager(adType: AdType.interstitial),
                    ),
                  );
                },
                btnCancelColor: AppColor.grey4Color,
                btnCancelOnPress: () {},
                btnCancelText: AppStrings.cancel,
                btnOkText: AppStrings.ok)
            .show();
      },
      child: DefaultLayout(
        appBar: defaultAppbar(
          actions: [
            Stack(
              children: [
                PopupMenuButton<MenuType>(
                  // 선택된 버튼에 따라 원하는 로직 수행. (여기서는 SnackBar 표시)
                  onSelected: (MenuType result) async {
                    switch (result) {
                      // case MenuType.share:
                      //   Share.share(
                      //     await FirebaseDynamicLinkManager.getShortLink(
                      //       AppRoutesPath.swapRoute,
                      //       widget.roomId,
                      //     ),
                      //   );
                      //   break;
                      case MenuType.chat:
                        _animationController.fling(
                            velocity: _isPanelVisible ? -1.0 : 1.0);
                        if (!_isPanelVisible) {
                          setState(() {
                            _isNewChatComming = false;
                          });
                        }
                        break;
                      case MenuType.report:
                        if ((room?.isDone ?? false) &&
                            (user.isHost && room?.guest != null ||
                                !user.isHost && room?.host != null)) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ReportScreen(
                              report: report!,
                              room: room,
                              chatlist: chatlist,
                            );
                          }));
                        } else {
                          if (!(room?.isDone ?? false)) {
                            Fluttertoast.showToast(msg: AppStrings.notYetPic);
                          } else {
                            Fluttertoast.showToast(
                                msg: AppStrings.noTargetReport);
                          }
                        }
                      // case MenuType.block:
                      // case MenuType.refresh:
                      // setState(() {});
                    }
                  },
                  // itemBuilder 에서 PopMenuItem 리스트 리턴해줘야 함.
                  itemBuilder: (BuildContext buildContext) {
                    return [
                      for (final value in MenuType.values)
                        PopupMenuItem(
                          value: value,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      Icon(
                                        switch (value) {
                                          // MenuType.share => Icons.share,
                                          MenuType.chat => Icons.message,
                                          MenuType.report =>
                                            Icons.report_rounded,
                                          // MenuType.block => Icons.block,
                                          // MenuType.refresh => Icons.refresh,
                                        },
                                        color: AppColor.subPrimaryColor,
                                      ),
                                      if (_isNewChatComming &&
                                          value == MenuType.chat &&
                                          !_isPanelVisible)
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColor.red1Color),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  Text(value.name),
                                ],
                              ),
                            ],
                          ),
                        )
                    ];
                  },
                ),
                if (_isNewChatComming && !_isPanelVisible) const RedDotWidget()
              ],
            ),
          ],
          leading: IconButton(
              onPressed: () {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        body: Center(
                            child: Text(
                          AppStrings.confirmExit,
                          style: const TextStyle(fontSize: AppSize.s24),
                        )),
                        btnOkColor: AppColor.primaryColor,
                        btnOkOnPress: () async {
                          await roomController.leaveChatRoom();
                          if (mounted) {
                            context.pop();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdmobManager(
                                    adType: AdType.interstitial),
                              ),
                            );
                          }
                        },
                        btnCancelColor: AppColor.grey4Color,
                        btnCancelOnPress: () {},
                        btnOkText: AppStrings.ok,
                        btnCancelText: AppStrings.cancel)
                    .show();
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        child: SingleChildScrollView(
            child: ref.watch(roomStreamProvider(widget.roomId)).when(
                  data: (roomInfo) {
                    if (roomInfo.guest != null && room != roomInfo) {
                      setState(() {
                        room = roomInfo;
                      });
                    }

                    final isCanChatState =
                        roomInfo.host == null || !roomInfo.isDone;

                    if (!roomInfo.isDone) {
                      if (roomInfo.hostIsReady && roomInfo.guestIsReady) {
                        EasyThrottle.throttle(
                          'showCountDown',
                          const Duration(seconds: 5),
                          () => _showCountDown(),
                        );
                      }
                    }

                    if (!user.isHost && roomInfo.guest != null) {
                      _checkDeactiveStatus(user: user, roomInfo: roomInfo);
                    }

                    final size = MediaQuery.of(context).size;
                    final Animation<RelativeRect> animation =
                        _getPanelAnimation(size.height);

                    partnerUrl = roomInfo.isDone && showCount < 0
                        ? user.isHost
                            ? roomInfo.guestPicUrl ?? ''
                            : roomInfo.hostPicUrl ?? ''
                        : user.isHost
                            ? roomInfo.guestBlurPicUrl ?? ''
                            : roomInfo.hostBlurPicUrl ?? '';

                    return SafeArea(
                      bottom: true,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  //guest쪽 이미지
                                  ImageBox(
                                    roomId: widget.roomId,
                                    onTap: () {
                                      if (roomInfo.isDone && showCount < 0) {
                                        setState(() {
                                          partnerUrl = user.isHost
                                              ? roomInfo.guestPicUrl ?? ''
                                              : roomInfo.hostPicUrl ?? '';
                                        });
                                      }
                                    },
                                    url: partnerUrl,
                                    customWidget: roomInfo.guest == null
                                        ? LoadingAnimationWidget
                                            .threeRotatingDots(
                                            size: 80,
                                            color: AppColor.green2Color,
                                          )
                                        : SizedBox(
                                            width: AppSize.s12,
                                            height: AppSize.s12,
                                            child: ImageAsset.waitIconImage
                                                .toSvgWidget(
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(AppPadding.p24),
                                    child: Container(
                                      width: AppSize.s18,
                                      height: AppSize.s18,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: roomInfo.guest == null
                                              ? AppColor.grey1Color
                                              : user.isHost
                                                  ? roomInfo.guestIsReady
                                                      ? AppColor.avatar3Color
                                                      : AppColor.red1Color
                                                  : roomInfo.hostIsReady
                                                      ? AppColor.avatar3Color
                                                      : AppColor.red1Color),
                                    ),
                                  ),
                                  if (roomController.isReady(roomInfo) &&
                                      showCount >= 0 &&
                                      !roomInfo.isDone)
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          '$showCount',
                                          style: const TextStyle(
                                              fontSize: AppSize.s72,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),

                                  // native 광고 넣을곳

                                  // Stack(
                                  //   fit: StackFit.expand,
                                  //   children: [
                                  //     GestureDetector(
                                  //       onTap: () {
                                  //         print('afsdhi');
                                  //       },
                                  //       child: Container(
                                  //         color: Colors.red,
                                  //         height: 60,
                                  //         width: 60,
                                  //       ),
                                  //     ),
                                  //     const AdmobManager(adType: AdType.native),
                                  //   ],
                                  // )

                                  // if (!roomInfo.isDone && user.isHost
                                  //     ? !roomInfo.guestBlurPicUrl.isNullOrEmpty()
                                  //     : !roomInfo.hostBlurPicUrl.isNullOrEmpty())
                                  // const AdmobManager(adType: AdType.native),
                                ],
                              ),
                              // geust & host 구분 경계선 UI
                              Container(
                                color: AppColor.subPrimaryColor,
                                width: double.infinity,
                                height: AppSize.s72,
                                child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'No: ${widget.roomId}',
                                      style: const TextStyle(
                                          color: AppColor.white1Color,
                                          fontSize: AppSize.s16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: widget.roomId));
                                          Fluttertoast.showToast(
                                              msg: widget.roomId);
                                        },
                                        icon: const Icon(
                                          Icons.copy,
                                          color: AppColor.white1Color,
                                        )),
                                    const Spacer(),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColor.primaryColor,
                                          disabledBackgroundColor:
                                              AppColor.subPrimaryColor,
                                        ),
                                        onPressed:
                                            user.pictureUrl.isNullOrEmpty() ||
                                                    roomInfo.isDone ||
                                                    (roomInfo.hostIsReady &&
                                                        roomInfo.guestIsReady)
                                                ? null
                                                : () {
                                                    roomController
                                                        .onReady(roomInfo);
                                                  },
                                        child: Text(
                                          AppStrings.ready,
                                          style: const TextStyle(
                                              color: AppColor.white1Color),
                                        ))
                                  ],
                                ).pSymmetric(h: AppPadding.p16),
                              ),
                              // host UI
                              Stack(
                                children: [
                                  ImageBox(
                                    roomId: widget.roomId,
                                    onTap: roomInfo.isDone ||
                                            roomInfo.guest == null
                                        ? () {
                                            Fluttertoast.showToast(
                                                msg: roomInfo.isDone
                                                    ? AppStrings.isDone
                                                    : AppStrings.noGuest);
                                          }
                                        : () {
                                            AwesomeDialog(
                                              context: context,
                                              animType: AnimType.scale,
                                              dialogType: DialogType.noHeader,
                                              body: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: roomInfo.isDone
                                                        ? null
                                                        : () async {
                                                            try {
                                                              context
                                                                  .loaderOverlay
                                                                  .show();
                                                              context.pop();

                                                              await roomController
                                                                  .uploadPicture(
                                                                      ImageSource
                                                                          .camera);
                                                            } catch (e) {
                                                              if (!mounted) {
                                                                return;
                                                              }

                                                              Log.d(
                                                                  e.toString());

                                                              if (e
                                                                  .toString()
                                                                  .contains(
                                                                      'photo_access_denied')) {
                                                                SnackBar
                                                                    snackBar =
                                                                    RequestionPermission
                                                                        .requestPermission(
                                                                            context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              } else {
                                                                Log.d(e
                                                                    .toString());
                                                                Fluttertoast.showToast(
                                                                    msg: AppStrings
                                                                        .cancel
                                                                        .localize());
                                                              }
                                                            } finally {
                                                              // ignore: use_build_context_synchronously
                                                              context
                                                                  .loaderOverlay
                                                                  .hide();
                                                            }
                                                          },
                                                    child: Column(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .camera_alt_sharp,
                                                          size: AppSize.s48,
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                        TextButton(
                                                            onPressed: null,
                                                            child: Text(
                                                              AppStrings.camera,
                                                              style: const TextStyle(
                                                                  color: AppColor
                                                                      .black1Color),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      try {
                                                        context.pop();
                                                        context.loaderOverlay
                                                            .show();
                                                        await roomController
                                                            .uploadPicture(
                                                                ImageSource
                                                                    .gallery);
                                                      } catch (e) {
                                                        if (!mounted) {
                                                          return;
                                                        }

                                                        if (e.toString().contains(
                                                            'photo_access_denied')) {
                                                          SnackBar snackBar =
                                                              RequestionPermission
                                                                  .requestPermission(
                                                                      context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: AppStrings
                                                                  .cancel
                                                                  .localize());
                                                          Log.d(e.toString());
                                                        }
                                                      } finally {
                                                        // ignore: use_build_context_synchronously
                                                        context.loaderOverlay
                                                            .hide();
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        const Icon(
                                                          Icons.photo_rounded,
                                                          size: AppSize.s48,
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                        TextButton(
                                                            onPressed: null,
                                                            child: Text(
                                                              AppStrings
                                                                  .gallery,
                                                              style: const TextStyle(
                                                                  color: AppColor
                                                                      .black1Color),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ).show();
                                          },
                                    url: user.pictureUrl ?? '',
                                    customWidget: Column(
                                      children: [
                                        ImageAsset.emptyImage
                                            .toSvgWidget(fit: BoxFit.cover),
                                        Text(
                                          AppStrings.click,
                                          style: const TextStyle(
                                              fontSize: AppSize.s24),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: AppSize.s18,
                                    height: AppSize.s18,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: user.isHost
                                            ? roomInfo.hostIsReady
                                                ? AppColor.avatar3Color
                                                : AppColor.red1Color
                                            : roomInfo.guestIsReady
                                                ? AppColor.avatar3Color
                                                : AppColor.red1Color),
                                  ).p(AppPadding.p24)
                                ],
                              ),
                              const SizedBox(
                                  child: AdmobManager(adType: AdType.banner)),
                            ],
                          ),
                          //Chatting UI
                          PositionedTransition(
                            rect: animation,
                            child: Material(
                              color: Colors.white.withOpacity(0),
                              elevation: 12,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: AppSize.s60,
                                      decoration: const BoxDecoration(
                                          color: AppColor.primaryColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(AppSize.s12),
                                              topRight: Radius.circular(
                                                  AppSize.s12))),
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded),
                                        onPressed: () {
                                          setState(() {
                                            _isNewChatComming = false;
                                          });

                                          _animationController.fling(
                                              velocity:
                                                  _isPanelVisible ? -1.0 : 1.0);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: AppColor.pink3Color,
                                      child: ref
                                          .watch(
                                              chatStreamProvider(widget.roomId))
                                          .when(
                                              data: (chatList) {
                                                if (roomInfo.guest != null &&
                                                    chatlist != chatList) {
                                                  setState(() {
                                                    report = report?.copyWith(
                                                        chat: chatList);
                                                    chatlist = chatList;
                                                  });
                                                }

                                                if (_chatListLenght !=
                                                    chatList.length) {
                                                  setState(() {
                                                    _isNewChatComming = true;
                                                    _chatListLenght =
                                                        chatList.length;
                                                  });
                                                }

                                                return ListView.builder(
                                                    controller:
                                                        _chatScrollController,
                                                    shrinkWrap: true,
                                                    itemCount: chatList.length,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      if (chatList[index]
                                                              .type ==
                                                          MessageType.alert) {
                                                        return Opacity(
                                                          opacity: 0.6,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      AppPadding
                                                                          .p48),
                                                              color: AppColor
                                                                  .grey2Color,
                                                            ),
                                                            child: Text(
                                                              chatList[index]
                                                                  .message,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ).p(AppPadding.p4),
                                                          ),
                                                        ).pSymmetric(
                                                            h: AppPadding.p24,
                                                            v: AppPadding.p12);
                                                      } else if (chatList[index]
                                                              .type ==
                                                          MessageType.message) {
                                                        return ChatBubbles(
                                                          nickname: chatList[
                                                                  index]
                                                              .senderNickname,
                                                          message:
                                                              chatList[index]
                                                                  .message,
                                                          isMe: user.nickname ==
                                                              chatList[index]
                                                                  .senderNickname,
                                                        );
                                                      }
                                                      return null;
                                                    }));
                                              },
                                              error: (error, stackTrace) {
                                                Log.d(error.toString());

                                                return ErrorScreen(
                                                    e: error.toString());
                                              },
                                              loading: () =>
                                                  const CircularProgressIndicator()),
                                    ),
                                  ),
                                  AbsorbPointer(
                                    absorbing: isCanChatState,
                                    child: Container(
                                      color: AppColor.white1Color,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: TextFormField(
                                            controller: _textEditingController,
                                            decoration: InputDecoration(
                                                filled: true,
                                                hintText: isCanChatState
                                                    ? AppStrings.chatNotify
                                                    : AppStrings.sendMessage,
                                                fillColor: isCanChatState
                                                    ? AppColor.grey6Color
                                                    : AppColor.white1Color),
                                          )),
                                          IconButton(
                                              onPressed: () {
                                                roomController.sendMessage(
                                                    _textEditingController
                                                        .text);
                                                setState(() {
                                                  _textEditingController
                                                      .clear();
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollToBottom();
                                                });
                                              },
                                              icon: Icon(
                                                Icons.send_rounded,
                                                color: isCanChatState
                                                    ? AppColor.grey6Color
                                                    : AppColor.black1Color,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: ((error, stackTrace) {
                    Log.d(stackTrace.toString());
                    return ErrorScreen(e: '');
                  }),
                  loading: () => const CircularProgressIndicator(),
                )),
      ),
    );
  }

  // Native 예제
  // Expanded(
  //   child: Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           print('afsdhi');
  //         },
  //         child: Container(
  //           color: Colors.red,
  //           height: 60,
  //           width: 60,
  //         ),
  //       ),
  //       const AdmobManager(adType: AdType.native),
  //     ],
  //   ),
  // )
}
