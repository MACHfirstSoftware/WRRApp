import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/post_screen/create_update_post/create_post.dart';
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
        child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NewReportPost()),
              );
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.btnColor,
              size: 30.h,
            )),
      ),
    );
  }
}
