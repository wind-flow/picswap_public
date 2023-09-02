import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';

class LocalizationWidget extends StatelessWidget {
  const LocalizationWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      fallbackLocale: const Locale('en', 'US'),
      assetLoader: CsvAssetLoader(),
      // path: 'assets/translations',
      path: 'assets/translations/langs.csv',
      child: child,
    );
  }
}
