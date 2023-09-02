import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/app/manager/routes.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/manager/values_manager.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/model/item_store_model.dart';
import 'package:picswap/domain/provider/user_provider.dart';
import 'package:picswap/presentation/component/dialog.dart';
import 'package:picswap/presentation/error_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/manager/admob/admob_manager.dart';
import '../app/manager/colors_manager.dart';
import '../app/manager/enums.dart';

import '../app/utils/log.dart';
import '../domain/provider/store_provider.dart';
import '../domain/provider/user_item_provider.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  @override
  void initState() {
    // final coinPurchaseOfferings = offerings
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userItem = ref.watch(userItemProvider);

    return DefaultLayout(
        appBar: AppBar(
            title: Text(AppRoutesPath.storeRoute.localize()),
            centerTitle: true,
            backgroundColor: AppColor.primaryColor,
            leading: IconButton(
                onPressed: () => context.pop(), icon: const Icon(Icons.close))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.white1Color.withOpacity(0.5)),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSize.s24),
                      Row(
                        children: [
                          Text(user.nickname,
                              style: const TextStyle(
                                fontSize: 24,
                              )),
                        ],
                      ),
                      const SizedBox(height: AppSize.s24),
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Coin',
                                style: TextStyle(fontSize: AppSize.s20),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  '${userItem.coin.coinAd + userItem.coin.coinPurchase}',
                                  style: const TextStyle(fontSize: AppSize.s20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: AppSize.s16),
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                const Text(
                                  'Item',
                                  style: TextStyle(fontSize: AppSize.s20),
                                ),
                                Text(
                                  ref
                                      .read(userItemProvider.notifier)
                                      .totalItemCount()
                                      .toString(),
                                  style: const TextStyle(fontSize: AppSize.s20),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryColor),
                                onPressed: () async {
                                  final isAdShow = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const AdmobManager(
                                      adType: AdType.rewardedInterstitial,
                                    );
                                  }));

                                  // ref
                                  //     .read(fbAnalytics)
                                  //     .sendEvent('seeAdForCoin', {
                                  //   'time': enterRoomTime,
                                  //   'screen': 'store_screen',
                                  //   'uuid': ref.watch(userProvider).uuid,
                                  // });
                                },
                                child: Text(
                                  AppStrings.getCoin,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s24),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: ExpansionTile(
                          title: AppStrings.noticeReadBeforePurchaseTitle.text
                              .make(),
                          textColor: AppColor.primaryColor,
                          iconColor: AppColor.primaryColor,
                          collapsedBackgroundColor: AppColor.white1Color,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppStrings.noticeReadBeforePurchaseContent,
                                style: const TextStyle(fontSize: AppSize.s16),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSize.s12),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.itemList,
                            style: const TextStyle(fontSize: AppSize.s18),
                          )),
                      const SizedBox(height: AppSize.s24),
                      //아이템 목록
                      ref.watch(getStoreInfoFutureProvider).when(data: (data) {
                        data.sort((a, b) => a.needCoin.compareTo(b.needCoin));
                        return Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ItemType.token.name.toString().localize(),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: AppSize.s20,
                                  color: AppColor.grey4Color),
                            ),
                          ),
                          const SizedBox(height: AppSize.s12),
                          Row(
                            children: data
                                .where((element) =>
                                    element.itemType == ItemType.token)
                                .map((element) => itemCard(item: element))
                                .toList(),
                          ),
                          const SizedBox(height: AppSize.s12),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     ItemType.chat.name.toString().localize(),
                          //     textAlign: TextAlign.start,
                          //     style: const TextStyle(
                          //         fontSize: AppSize.s20,
                          //         color: AppColor.grey4Color),
                          //   ),
                          // ),
                          // const SizedBox(height: AppSize.s12),
                          // Container(
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: AppMargin.m8),
                          //   // width: AppSize.s36,
                          //   height: AppSize.s72,
                          //   decoration: BoxDecoration(
                          //       border: Border.all(),
                          //       borderRadius: BorderRadius.circular(AppSize.s8),
                          //       color: AppColor.grey2Color),
                          //   child: const Center(child: Text('Comming Soon')),
                          // )
                          // Row(
                          //   children: data
                          //       .where((element) =>
                          //           element.itemType == ItemType.chat)
                          //       .map((element) => itemCard(item: element))
                          //       .toList(),
                          // ),
                        ]);
                      }, error: (error, stackTrace) {
                        return ErrorScreen(e: error.toString());
                      }, loading: () {
                        return const CircularProgressIndicator();
                      })
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget itemCard({required ItemInfoModel item, void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap ??
            () {
              CustomDialog(
                  context: context,
                  title: AppStrings.confirmPurchase(item: item),
                  btnOkOnPress: () async {
                    try {
                      await ref
                          .read(userItemProvider.notifier)
                          .buyItem(item: item);

                      // ref.read(fbAnalytics).sendEvent('create Room', {
                      //   'time': enterRoomTime,
                      //   'screen': 'store_screen',
                      //   'uuid': ref.watch(userProvider).uuid,
                      //   'itemInfo': item.toString(),
                      // });

                      Fluttertoast.showToast(
                          msg: AppStrings.noticePurchaseSuccess);
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  btnCancelOnPress: () {});
            },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppMargin.m8),
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(AppSize.s16)),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(item.itemType.name.localize(),
                        style: Theme.of(context).textTheme.displaySmall)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('+${item.itemCount}',
                        style: Theme.of(context).textTheme.displaySmall)),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: AppColor.subPrimaryColor,
                    ),
                    Text(
                      '${item.needCoin}',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: AppColor.primaryColor),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
