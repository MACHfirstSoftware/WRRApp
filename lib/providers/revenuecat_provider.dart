import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';

class RevenueCatProvider with ChangeNotifier {
  RevenueCatProvider(SubscriptionStatus status) {
    _subscriptionStatus = status;
    init();
  }

  SubscriptionStatus _subscriptionStatus = SubscriptionStatus.free;
  SubscriptionStatus get subscriptionStatus => _subscriptionStatus;

  Future init() async {
    // print("init call in revenue");
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    // print("updatePurchaseStatus call in revenue");
    final purchaserInfo = await Purchases.getPurchaserInfo();
    bool entitlements =
        purchaserInfo.entitlements.all["premium"]?.isActive ?? false;
    // print(entitlements.isNotEmpty);
    _subscriptionStatus =
        entitlements ? SubscriptionStatus.premium : SubscriptionStatus.free;

    notifyListeners();
  }

  setSubscriptionStatus(SubscriptionStatus status, {bool isInit = false}) {
    _subscriptionStatus = status;
    if (!isInit) {
      notifyListeners();
    }
  }
}
