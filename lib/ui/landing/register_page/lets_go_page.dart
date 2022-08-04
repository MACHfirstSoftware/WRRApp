import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/purchases_service.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/subscription_page/paywall_widget.dart';
import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class LetsGoPage extends StatefulWidget {
  final String userId;
  final String email;
  final String password;
  const LetsGoPage(
      {Key? key,
      required this.userId,
      required this.email,
      required this.password})
      : super(key: key);

  @override
  State<LetsGoPage> createState() => _LetsGoPageState();
}

class _LetsGoPageState extends State<LetsGoPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getPlans();
    });

    super.initState();
  }

  // _subscription() async {
  //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
  //   int sId = await Navigator.of(context).push(
  //     HeroDialogRoute(builder: (context) => const SubscriptionScreen()),
  //   );
  //   PageLoader.showLoader(context);
  //   final subscriptionResponse =
  //       await SubscriptionService.addSubscription(widget.userId, sId);
  //   Navigator.pop(context);
  //   subscriptionResponse.when(success: (bool success) async {
  //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
  //         context: context,
  //         messageText: "Successfully subscribed!",
  //         type: SnackBarType.success));
  //   }, failure: (NetworkExceptions error) async {
  //     PageLoader.showTransparentLoader(context);
  //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
  //         context: context,
  //         messageText: NetworkExceptions.getErrorMessage(error),
  //         type: SnackBarType.error));
  //     await Future.delayed(const Duration(milliseconds: 2200), () {
  //       Navigator.pop(context);
  //     });
  //     _subscription();
  //   }, responseError: (ResponseError responseError) async {
  //     PageLoader.showTransparentLoader(context);
  //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
  //         context: context,
  //         messageText: responseError.error,
  //         type: SnackBarType.error));
  //     await Future.delayed(const Duration(milliseconds: 2200), () {
  //       Navigator.pop(context);
  //     });
  //     _subscription();
  //   });
  // }

  _getPlans() async {
    PageLoader.showLoader(context);
    await PurchasesService.login(userId: widget.userId);
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
      _showSheet(_packages);
    }
  }

  _showSheet(List<Package> _packages) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (context) => PaywalWidget(
              personId: widget.userId,
              packages: _packages,
              onClickedPackage: (package) async {
                PageLoader.showLoader(context);
                final res = await PurchasesService.purchasePackage(package);

                res.when(success: (PurchaserInfo info) async {
                  // await UserService.setAppUserId(
                  //     userId: widget.userId,
                  //     appUserId: info.originalAppUserId);
                  await SubscriptionService.addSubscription(
                      personId: widget.userId, isPremium: true);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context: context,
                      type: SnackBarType.success,
                      messageText: "Successfully subscribed"));
                }, failure: (NetworkExceptions err) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context: context,
                      type: SnackBarType.error,
                      messageText: NetworkExceptions.getErrorMessage(err)));
                }, responseError: (ResponseError responseError) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context: context,
                      type: SnackBarType.error,
                      messageText: responseError.error));
                });
              },
            ));
  }

  _letsGo() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    PageLoader.showLoader(context);
    final res = await UserService.signIn(widget.email, widget.password);
    res.when(success: (User user) async {
      await StoreUtils.saveUser(
          {"email": widget.email, "password": widget.password});
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      final res = await PurchasesService.login(userId: user.id);
      if (res) {
        Provider.of<RevenueCatProvider>(context, listen: false)
            .setSubscriptionStatus(SubscriptionStatus.premium);
      } else {
        Provider.of<RevenueCatProvider>(context, listen: false)
            .setSubscriptionStatus(SubscriptionStatus.free);
      }
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false);
    }, failure: (NetworkExceptions error) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthMainPage()),
          (route) => false);
    }, responseError: (ResponseError responseError) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthMainPage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 56.h,
                width: 428.w,
              ),
              const LogoImage(),
              const Spacer(),
              SvgPicture.asset("assets/icons/check-circle.svg",
                  height: 75.w, width: 75.w, color: Colors.white),
              SizedBox(
                height: 40.h,
              ),
              SizedBox(
                width: 310.w,
                child: Text(
                  "Welcome to the Wisconsin Rut Report!",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () => _letsGo(),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(5.w)),
                  child: SizedBox(
                    height: 25.h,
                    width: 110.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        "Let's go!",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
