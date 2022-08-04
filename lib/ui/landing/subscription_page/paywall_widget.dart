import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';

class PaywalWidget extends StatefulWidget {
  final String personId;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;
  const PaywalWidget(
      {Key? key,
      required this.packages,
      required this.onClickedPackage,
      required this.personId})
      : super(key: key);

  @override
  State<PaywalWidget> createState() => _PaywalWidgetState();
}

class _PaywalWidgetState extends State<PaywalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 700.h),
      decoration: BoxDecoration(
          color: AppColors.popBGColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.w),
            topRight: Radius.circular(30.w),
          )),
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            children: [
              SizedBox(
                height: 35.h,
                width: 300.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    "Choose a plan",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.btnColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
                width: 428.w,
              ),
              _buildPackages()
            ],
          )),
    );
  }

  _buildPackages() => ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          ...widget.packages.map((package) => _buildPackage(context, package)),
          SizedBox(
            height: 10.h,
          ),
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.w)),
            child: Theme(
              data: ThemeData.light(),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.w),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // product.title,
                    "Free Membership",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.btnColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Limited: Forum Access Only.",
                        // "Unlimited Access. Enjoy all the benefits of the WRR including entry into the Big Buck contest, access to exclusive sponsor discounts, real time weather, and up to date county by county reports from fellow hunters.",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                            text: "Terms of Service ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => UtilCommon.launchAnUrl(
                                  "https://www.iubenda.com/terms-and-conditions/31336910"),
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: " and ",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: " Privacy Policy",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => UtilCommon.launchAnUrl(
                                      "https://wisconsinrutreport.com/privacy-policy/"),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.btnColor,
                                    fontWeight: FontWeight.w400),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
                // subtitle: FittedBox(
                //   fit: BoxFit.scaleDown,
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     // product.description,
                //     "Limited: Forum Access Only.",
                //     style: TextStyle(
                //         fontSize: 14.sp,
                //         color: Colors.white,
                //         fontWeight: FontWeight.w400),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                trailing: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\$00.00 / Lifetime",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.right,
                  ),
                ),
                onTap: () async {
                  PageLoader.showLoader(context);
                  await SubscriptionService.addSubscription(
                      personId: widget.personId, isPremium: false);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      );

  // ListView.builder(
  //     shrinkWrap: true,
  //     primary: false,
  //     itemCount: widget.packages.length,
  //     itemBuilder: (context, index) {
  //       final package = widget.packages[index];
  //       return _buildPackage(context, package);
  //     });

  _buildPackage(BuildContext context, Package package) {
    final product = package.product;
    // print("TITLE : ${product.title}");
    // print("DESCRIPTION : ${product.description}");
    // print("PRICE : ${product.priceString}");

    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
      child: Theme(
        data: ThemeData.light(),
        child: ListTile(
          contentPadding: EdgeInsets.all(10.w),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              product.title,
              // "Premium Membership",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.btnColor,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  product.description,
                  // "Unlimited Access. Enjoy all the benefits of the WRR including entry into the Big Buck contest, access to exclusive sponsor discounts, real time weather, and up to date county by county reports from fellow hunters.",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      text: "Terms of Service ",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => UtilCommon.launchAnUrl(
                            "https://www.iubenda.com/terms-and-conditions/31336910"),
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(
                          text: " and ",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: " Privacy Policy",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => UtilCommon.launchAnUrl(
                                "https://wisconsinrutreport.com/privacy-policy/"),
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.btnColor,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                ),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              product.priceString + " / Year",
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.right,
            ),
          ),
          onTap: () => widget.onClickedPackage(package),
        ),
      ),
    );
  }
}
