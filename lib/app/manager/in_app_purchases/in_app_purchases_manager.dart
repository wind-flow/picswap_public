import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchasesManager {
  static const _apiKey = '';

  InAppPurchasesManager() {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('');
    } else {
      configuration = PurchasesConfiguration('');
    }
    await Purchases.configure(configuration);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      return [];
    }
  }
}

final inAppPurchaseProvider = Provider<InAppPurchasesManager>((ref) {
  final InAppPurchasesManager inaAppPurchase = InAppPurchasesManager();
  inaAppPurchase.initPlatformState();

  return inaAppPurchase;
});
