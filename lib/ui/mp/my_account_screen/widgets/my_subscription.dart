import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/subscription_model_sheet.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class MySubscription extends StatefulWidget {
  const MySubscription({Key? key}) : super(key: key);

  @override
  State<MySubscription> createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {
  late PurchaserInfo purchaserInfo;
  late ApiStatus _apiStatus;
  String errorMessage = '';
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    setState(() {
      _apiStatus = ApiStatus.isBusy;
    });
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      _apiStatus = ApiStatus.isIdle;
    } on PlatformException catch (e) {
      _apiStatus = ApiStatus.isError;
      errorMessage = e.message ?? "Somthing went wrong";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _subscriptionStatus =
        Provider.of<RevenueCatProvider>(context).subscriptionStatus;
    if (_apiStatus == ApiStatus.isBusy) {
      return ViewModels.buildLoader();
    }
    if (_apiStatus == ApiStatus.isError) {
      return ViewModels.buildErrorWidget(errorMessage, () => _init);
    }
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: 70.h,
          title: const DefaultAppbar(title: "My Subscription"),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
            child: _subscriptionStatus == SubscriptionStatus.premium
                ? _buildPremium()
                : _buildFree(context)));
  }

  _buildPremium() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 75.h,
        ),
        SizedBox(
          height: 80.h,
          width: 200.w,
          child: Image.asset("assets/images/WRR.png"),
        ),
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          // height: 20.h,
          width: 400.w,
          child: Text(
            "You subscribed premium membership. Enjoy all the benefits of the WRR",
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 25.h,
          width: 428.w,
        ),
        SizedBox(
          height: 20.h,
          width: 350.w,
          child: Text(
            "Renewable date",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: SizedBox(
            height: 20.h,
            width: 350.w,
            child: Text(
              purchaserInfo.entitlements.all["premium"]?.expirationDate != null
                  ? DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.parse(
                      purchaserInfo
                          .entitlements.all["premium"]!.expirationDate!))
                  : "Undefined",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  // DateFormat('yyyy-MM-dd HH:mm')
  //                     .parse(purchaserInfo
  //                             .entitlements.all["premium"]!.expirationDate!
  //                             .split("T")[0] +
  //                         " " +
  //                         purchaserInfo
  //                             .entitlements.all["premium"]!.expirationDate!
  //                             .split("T")[1]
  //                             .substring(0, 5))
  //                     .toString()

  _buildFree(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 75.h,
        ),
        SizedBox(
          height: 80.h,
          width: 200.w,
          child: Image.asset("assets/images/WRR.png"),
        ),
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          // height: 20.h,
          width: 400.w,
          child: Text(
            "You subscribed free membership. Get more benefits upgrade your membership",
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 25.h,
          width: 428.w,
        ),
        GestureDetector(
          onTap: () async {
            SubscriptionUtil.getPlans(
                context: context,
                userId:
                    Provider.of<UserProvider>(context, listen: false).user.id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50.h,
            width: 150.w,
            decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w)),
            child: SizedBox(
              height: 25.h,
              width: 130.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "Upgrade",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
