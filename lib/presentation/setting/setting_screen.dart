import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:picswap/app/manager/constants.dart';
import 'package:picswap/app/manager/string_manager.dart';
import 'package:picswap/app/utils/extension/string_extensions.dart';
import 'package:picswap/domain/provider/user_provider.dart';
import 'package:upgrader/upgrader.dart';

import '../../app/layout/default_layout.dart';
import '../../app/manager/colors_manager.dart';
import '../../app/manager/device_manager.dart';
import '../../app/manager/routes.dart';
import '../../app/utils/log.dart';
import '../../domain/model/user_model.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool isPush = true;
  String appVersion = AppStrings.unknown;

  @override
  void initState() {
    appVersion =
        Upgrader.sharedInstance.currentInstalledVersion() ?? AppStrings.unknown;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return DefaultLayout(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppRoutesPath.settingRoute.localize(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        child: ListView(
          children: [
            // ListTile(
            //   leading: const Icon(
            //     Icons.notifications,
            //   ),
            //   title: const Text('푸쉬알람받기'),
            //   trailing: Switch(
            //       value: isPush,
            //       onChanged: (value) {
            //         setState(() => isPush = !isPush);
            //       }),
            // ),
            settingItem(
                leading: const Icon(Icons.mail_sharp),
                content: AppStrings.sendMail,
                func: () {
                  _sendEmail(user);
                }),
            // settingItem(
            //     leading: const Icon(Icons.info), content: '정보', func: () {}),
            settingItem(
                leading: const Icon(Icons.newspaper),
                content: AppStrings.notice,
                func: () => context.pushNamed(AppRoutesPath.noticeRoute)),
            settingItem(
                leading: const Icon(Icons.info),
                content: AppStrings.version,
                trail: Text(appVersion),
                func: () {}),
            // settingItem(Icons.note_alt_outlined, '개인정보 취급방침',
            //     const Icon(Icons.arrow_forward_ios_rounded), () {}),
            // settingItem(Icons.logout, '로그아웃',
            //     const Icon(Icons.arrow_forward_ios_rounded), () {
            //   // ref.read(authProvider.notifier).logout();
            // }),
          ],
        ));
  }

  void _sendEmail(UserModel user) async {
    String body = '''
==================
identifier : ${(await getDeviceDetails()).identifier}
name : ${(await getDeviceDetails()).name}
version : ${(await getDeviceDetails()).version}
id : ${user.uuid}
''';

    final Email email = Email(
      body: body,
      subject: '[picswap Request]',
      recipients: [AppConstants.email],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = AppStrings.failWriteEmail;
      Log.d(error.toString());
      if (!mounted) return;
      AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              title: title,
              btnOkText: AppStrings.ok,
              btnOkOnPress: () {})
          .show();
    }
  }
}

ListTile settingItem(
    {Widget? leading,
    required String content,
    Widget? trail = const Icon(Icons.arrow_forward_ios_rounded),
    required VoidCallback func}) {
  return ListTile(
    leading: leading,
    title: Text(content),
    trailing: trail,
    onTap: func,
  );
}
