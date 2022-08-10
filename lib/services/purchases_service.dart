import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class PurchasesService {
  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(Platform.isAndroid
        ? Constant.revenueCatApiKeyPlayStore
        : Constant.revenueCatApiKeyAppStore);
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
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      log(purchaserInfo.entitlements.all["premium"].toString());

      if (purchaserInfo.entitlements.all["premium"] != null &&
          purchaserInfo.entitlements.all["premium"]!.isActive) {
        // Unlock that great "pro" content
        // print("purchase success");
        return ApiResult.success(data: purchaserInfo);
      } else {
        // print("purchase not success");
        return ApiResult.responseError(
            responseError:
                ResponseError(error: "Purchasing unsuccessful", errorCode: 0));
      }
    } on PlatformException catch (e) {
      log(e.toString());
      // print("purchase not success platform");
      // var errorCode = PurchasesErrorHelper.getErrorCode(e);
      // print(errorCode);
      // if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
      //   // print(e.message);
      //   return ApiResult.responseError(
      //       responseError: ResponseError(
      //           error: e.message ?? "Something went wrong", errorCode: 0));
      // }
      // if (errorCode != PurchasesErrorCode.) {
      //   // print(e.message);
      //   return ApiResult.responseError(
      //       responseError: ResponseError(
      //           error: e.message ?? "Something went wrong", errorCode: 0));
      // }
      return ApiResult.responseError(
          responseError:
              ResponseError(error: "Purchasing unsuccessful", errorCode: 0));
    } catch (e) {
      // print("purchase not success catch");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<bool> login({required String userId}) async {
    try {
      final result = await Purchases.logIn(userId);
      log(result.purchaserInfo.toString());
      return result.purchaserInfo.entitlements.all["premium"]?.isActive ??
          false;
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
