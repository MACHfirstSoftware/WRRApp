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
              fontSize: 25.sp,
              color: AppColors.btnColor,
              fontWeight: FontWeight.w700),
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
}
