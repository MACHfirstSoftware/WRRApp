import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/bottom_appbar.dart';

class ReportContents extends StatefulWidget {
  const ReportContents({Key? key}) : super(key: key);

  @override
  State<ReportContents> createState() => _ReportContentsState();
}

class _ReportContentsState extends State<ReportContents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const ReportBottomAppbar(),
        elevation: 0,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
