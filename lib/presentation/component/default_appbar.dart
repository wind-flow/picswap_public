import 'package:flutter/material.dart';
import 'package:picswap/app/manager/colors_manager.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';

import '../../app/manager/asset_manager.dart';
import '../../app/manager/values_manager.dart';

AppBar? defaultAppbar({List<Widget>? actions, Widget? leading}) {
  return AppBar(
    title: ImageAsset.splashLogo.toSvgWidget(width: AppSize.s80),
    leading: leading,
    centerTitle: true,
    backgroundColor: AppColor.primaryColor,
    actions: actions,
  );
}
