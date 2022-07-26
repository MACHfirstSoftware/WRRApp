import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wisconsin_app/config.dart';

class ViewModels {
  static buildLoader() {
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

  static postLoader() {
    return Center(
      child: SizedBox(
        height: 30.w,
        width: 30.w,
        child: const LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [AppColors.btnColor],
            strokeWidth: 1.0),
      ),
    );
  }

  static buildErrorWidget(String errorMessage, VoidCallback onTap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          errorMessage,
          style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.btnColor,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15.h,
          width: 428.w,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            height: 40.h,
            width: 150.w,
            decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w)),
            child: SizedBox(
              height: 30.h,
              width: 130.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "Try Again",
                  style: TextStyle(
                      fontSize: 16.sp,
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

  static postEmply() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
          width: 200.w,
          child: Image.asset("assets/images/WRR.png"),
        ),
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          height: 20.h,
          width: 400.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              "Sorry, no content to show",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  static freeSubscription({bool isShopPage = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
          width: 200.w,
          child: Image.asset("assets/images/WRR.png"),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 20.h,
          width: 400.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              "This ${isShopPage ? "area" : "content"} is for premium members only",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
          width: 428.w,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            height: 40.h,
            width: 150.w,
            decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w)),
            child: SizedBox(
              height: 30.h,
              width: 130.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "Upgrade",
                  style: TextStyle(
                      fontSize: 16.sp,
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
