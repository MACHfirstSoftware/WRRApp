import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/purchases_service.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/ui/landing/subscription_page/paywall_widget.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class SubscriptionUtil {
  static Future getPlans(
      {required BuildContext context, required String userId}) async {
    PageLoader.showLoader(context);
    final offerings = await PurchasesService.fetchOffers();
    Navigator.pop(context);
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          context: context,
          type: SnackBarType.error,
          messageText: "No Plans Found"));
    } else {
      final _packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      showSheet(_packages, context, userId);
    }
  }

  static Future showSheet(
      List<Package> _packages, BuildContext context, String userId) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        context: context,
        builder: (context) => PaywalWidget(
              personId: userId,
              packages: _packages,
              onClickedPackage: (package) async {
                PageLoader.showLoader(context);
                final res = await PurchasesService.purchasePackage(package);

                res.when(success: (PurchaserInfo info) async {
                  // await UserService.setAppUserId(
                  //     userId: userId, appUserId: info.originalAppUserId);
                  await SubscriptionService.addSubscription(
                      personId: userId, isPremium: true);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context: context,
                      type: SnackBarType.success,
                      messageText: "Successfully subscribed"));
                }, failure: (NetworkExceptions err) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context: context,
                      type: SnackBarType.error,
                      messageText: NetworkExceptions.getErrorMessage(err)));
                }, responseError: (ResponseError responseError) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context: context,
                      type: SnackBarType.error,
                      messageText: responseError.error));
                });
              },
            ));
  }
}
