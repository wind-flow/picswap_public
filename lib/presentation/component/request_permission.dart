import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picswap/app/manager/string_manager.dart';

class RequestionPermission extends ConsumerWidget {
  const RequestionPermission({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // key: _key,
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              SnackBar snackBar;
              if (await checkPermissionGranted()) {
                snackBar = SnackBar(content: Text(AppStrings.allowEverything));
              } else {
                snackBar = requestPermission(context);
              }
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text(AppStrings.permission)),
      ),
    );
  }

  Future<bool> checkPermissionGranted() async {
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.mediaLibrary,
      Permission.photos,
    ].request();

    bool permitted = true;
    statues.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) {
        permitted = false;
      }
    });

    return permitted;
  }

  static SnackBar requestPermission(BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text(AppStrings.noticeAllowPermission),
      action: SnackBarAction(
        label: AppStrings.goSetting,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          openAppSettings();
        },
      ),
    );
    return snackBar;
  }
}
