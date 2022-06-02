import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PageLoader {
  static showLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.2),
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
              ),
              height: 50.w,
              width: 50.w,
              child: const LoadingIndicator(
                  indicatorType: Indicator.lineSpinFadeLoader,
                  colors: [Colors.white],
                  strokeWidth: 2.0),
            ),
          ],
        );
      },
    );
  }

  static showTransparentLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          height: 926.h,
          width: 428.w,
        );
      },
    );
  }
}
