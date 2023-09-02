// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:picswap/app/manager/asset_manager.dart';
import 'package:picswap/app/utils/extension/image_extensions.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({
    super.key,
    required this.e,
  });
  final String e;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ImageAsset.errorImage.toSvgWidget(),
          Text(e.toString()),
          const Spacer(),
        ],
      ),
    );
  }
}
