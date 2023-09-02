import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/app/layout/default_layout.dart';
import 'package:picswap/app/manager/routes.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/provider/setting_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app/manager/colors_manager.dart';
import '../../app/manager/values_manager.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    final notice = ref.watch(noticeProvider);
    return DefaultLayout(
        title: AppRoutesPath.noticeRoute.localize(),
        child: notice.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data[index].title,
                        style: const TextStyle(fontSize: AppSize.s20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data[index].timeStamp,
                        style: const TextStyle(
                            fontSize: AppSize.s14, color: AppColor.grey4Color),
                      ),
                    ),
                  ],
                ),
                collapsedBackgroundColor: AppColor.white1Color,
                children: [
                  Container(
                    color: AppColor.grey5Color,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data[index].content,
                        style: const TextStyle(fontSize: AppSize.s20),
                      ),
                    ).pOnly(
                        left: AppPadding.p16,
                        top: AppPadding.p12,
                        right: 0,
                        bottom: AppPadding.p12),
                  )
                ],
              );
            },
          );
        }, error: (error, strackTrace) {
          return Text(error.toString());
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
