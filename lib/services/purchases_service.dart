import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/config.dart';

class PurchasesService {
  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(Constant.revenueCatApiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } catch (e) {
      return [];
    }
  }
}
