import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class ConfirmationPopup extends StatelessWidget {
  final String title;
  final String message;
  final String leftBtnText;
  final String rightBtnText;
  final VoidCallback onTap;
  const ConfirmationPopup(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.message,
      required this.leftBtnText,
      required this.rightBtnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 428.w,
            ),
            Container(
              width: 350.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15.w)),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.btnColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: AppColors.btnColor.withOpacity(0.4),
                            customBorder: const StadiumBorder(),
                            onTap: () {
                              Navigator.pop(context);
                              onTap();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 27.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color: AppColors.btnColor,
                                ),
                                width: 110.w,
                                height: 45.h,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    leftBtnText,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: AppColors.btnColor.withOpacity(0.4),
                            customBorder: const StadiumBorder(),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: AppColors.btnColor,
                                        width: 1.5.w)),
                                width: 110.w,
                                height: 45.h,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    rightBtnText,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.btnColor,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
