import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/subscription.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // int _selectedIndex = 0;
  int radioValue = 2;
  late bool isLoading;
  late bool showTryAgain;
  late String errorMessage;
  List<Subscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    setState(() {
      isLoading = true;
      showTryAgain = false;
      errorMessage = '';
    });
    final res = await SubscriptionService.getSubscriptions();
    res.when(success: (List<Subscription> data) {
      subscriptions = data;
      setState(() {
        isLoading = false;
        showTryAgain = false;
        errorMessage = '';
      });
    }, failure: (NetworkExceptions error) {
      setState(() {
        isLoading = false;
        showTryAgain = true;
        errorMessage = NetworkExceptions.getErrorMessage(error);
      });
    }, responseError: (ResponseError responseError) {
      setState(() {
        isLoading = false;
        showTryAgain = true;
        errorMessage = responseError.error;
      });
    });
  }

  // callbackFunction(int value, dynamic reason) {
  //   setState(() {
  //     _selectedIndex = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.w)),
        child: Container(
          width: 400.w,
          height: 550.h,
          padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 50.h),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .8],
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
              ),
              borderRadius: BorderRadius.circular(20.w)),
          child: isLoading
              ? _buildLoader()
              : showTryAgain
                  ? _buildErrorWidget()
                  : _buildView(),
        ),
      ),
    );
  }

  _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          errorMessage,
          style: TextStyle(
              fontSize: 25.sp,
              color: AppColors.btnColor,
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15.h,
        ),
        GestureDetector(
          onTap: () {
            _init();
          },
          child: Container(
            alignment: Alignment.center,
            height: 60.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "Try Again",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  _buildView() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Choose your plan".toUpperCase(),
          style: TextStyle(
              fontSize: 25.sp,
              color: AppColors.btnColor,
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: 200.w,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey[300],
            ),
            child: RadioListTile(
              value: 2,
              groupValue: radioValue,
              onChanged: (int? ind) => setState(() {
                radioValue = ind!;
              }),
              title: Text(
                "Premium",
                style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                "\$29.99",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              activeColor: AppColors.btnColor,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
          width: 330.w,
        ),
        SizedBox(
          width: 200.w,
          child: Theme(
            data: ThemeData(
              //here change to your color
              unselectedWidgetColor: Colors.grey[300],
            ),
            child: RadioListTile(
              value: 0,
              groupValue: radioValue,
              onChanged: (int? ind) => setState(() {
                radioValue = ind!;
              }),
              title: Text(
                "Free",
                style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                "\$00.00",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              activeColor: AppColors.btnColor,
            ),
          ),
        ),
        // CarouselSlider(
        //     items: [
        //       for (int i = 0; i < subscriptions.length; i++)
        //         _buildPlan(
        //             subscriptions[i].isPremium
        //                 ? "assets/icons/premium.svg"
        //                 : "assets/icons/free-label.svg",
        //             subscriptions[i].displayName,
        //             i)
        //     ],
        //     options: CarouselOptions(
        //       height: 300.h,
        //       aspectRatio: 16 / 9,
        //       viewportFraction: 0.75,
        //       initialPage: 0,
        //       enableInfiniteScroll: true,
        //       reverse: false,
        //       autoPlay: false,
        //       autoPlayInterval: const Duration(seconds: 3),
        //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
        //       autoPlayCurve: Curves.fastOutSlowIn,
        //       enlargeCenterPage: true,
        //       onPageChanged: callbackFunction,
        //       scrollDirection: Axis.horizontal,
        //     )),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // print(subscriptions[_selectedIndex].isPremium);
            Navigator.pop(context, subscriptions[radioValue].id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "Next",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Center _buildLoader() {
    return Center(
      child: SizedBox(
        height: 50.w,
        width: 50.w,
        child: const LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [AppColors.btnColor],
            strokeWidth: 2.0),
      ),
    );
  }

  // _buildPlan(String iconPath, String planName, int index) {
  //   return Container(
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //         border: Border.all(
  //             color: _selectedIndex == index
  //                 ? AppColors.btnColor
  //                 : Colors.grey[300]!,
  //             width: 5.w),
  //         borderRadius: BorderRadius.circular(20.w)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         SvgPicture.asset(
  //           // "assets/icons/free-label.svg",
  //           iconPath,
  //           color:
  //               _selectedIndex == index ? AppColors.btnColor : Colors.grey[300],
  //           width: 100.w,
  //           height: 100.w,
  //         ),
  //         Text(
  //           // "FREE",
  //           planName,
  //           style: TextStyle(
  //               fontSize: 30.sp,
  //               color: _selectedIndex == index
  //                   ? AppColors.btnColor
  //                   : Colors.grey[300],
  //               fontWeight: FontWeight.w700),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
