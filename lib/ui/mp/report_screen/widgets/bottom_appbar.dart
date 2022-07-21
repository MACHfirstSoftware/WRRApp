import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/report_screen/create_update_report/create_report_post.dart';

class ReportBottomAppbar extends StatefulWidget {
  const ReportBottomAppbar({Key? key}) : super(key: key);

  @override
  State<ReportBottomAppbar> createState() => _ReportBottomAppbarState();
}

class _ReportBottomAppbarState extends State<ReportBottomAppbar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NewReportPost()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  width: 110.w,
                  // margin: EdgeInsets.symmetric(vertical: 10.w),
                  // padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(7.5.w)),
                  child: SizedBox(
                    height: 30.h,
                    width: 90.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        "New Report",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
