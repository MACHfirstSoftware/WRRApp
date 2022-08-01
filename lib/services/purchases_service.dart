import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';

class PurchasesService {
  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(Constant.revenueCatApiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      // print("OFFERINGS");
      // inspect(offerings);
      // log(offerings.toString());
      final current = offerings.current;
      // print("CURRENT");
      // log(current.toString());
      return current == null ? [] : [current];
    } catch (e) {
      // print(e);
      return [];
    }
  }

  static Future<ApiResult<PurchaserInfo>> purchasePackage(
      Package package) async {
    try {
      // PurchaserInfo purchaserInfo =
      final purchase = await Purchases.purchasePackage(package);
      log(purchase.toString());
      // print("APP USER ID : ${purchase.originalAppUserId}");
      return ApiResult.success(data: purchase);
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        // print(e.message);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: e.message ?? "Something went wrong", errorCode: 0));
      }
      return ApiResult.responseError(
          responseError: ResponseError(
              error: e.message ?? "Something went wrong", errorCode: 0));
    }
  }

  static Future<bool> login({required String appUserId}) async {
    try {
      final result = await Purchases.logIn(appUserId);
      log(result.purchaserInfo.activeSubscriptions.isNotEmpty.toString());
      return result.purchaserInfo.activeSubscriptions.isNotEmpty;
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
