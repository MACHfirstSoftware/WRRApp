import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class PostAbuse extends StatelessWidget {
  final String personId;
  final int postId;
  const PostAbuse({Key? key, required this.personId, required this.postId})
      : super(key: key);

  _reportAbuse(BuildContext context) async {
    PageLoader.showLoader(context);
    final res = await PostService.postAbuse(personId, postId);
    Navigator.pop(context);
    if (res) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully reported",
          type: SnackBarType.success));
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Report unsuccessful",
          type: SnackBarType.error));
    }
    Navigator.pop(context);
  }

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
                    "Report",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.btnColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("Do you want to report post?",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left),
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
                              _reportAbuse(context);
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
                                    "Report",
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
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 25.w, vertical: 7.5.h),
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
                                    "Cancel",
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
