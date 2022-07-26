import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class PageStepper extends StatelessWidget {
  final int length;
  final int currentStep;
  const PageStepper({Key? key, required this.length, required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, bottom: 30.h),
      child: SizedBox(
        height: 4.h,
        width: 410.w,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: length,
            itemBuilder: (_, index) {
              return Container(
                height: 1.h,
                width: (410.w - (length * 10.w)) / length,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                    color: index == currentStep
                        ? AppColors.btnColor
                        : Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(2.w)),
              );
            }),
      ),
    );
  }
}
