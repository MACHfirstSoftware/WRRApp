import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/report_screen/create_update_report/create_report_post.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/report_content_page.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/report_page_appbar.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const ReportPageAppBar(),
        elevation: 0,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
      ),
      body: const ReportContents(),
      floatingActionButton: FloatingActionButton(
          heroTag: "2",
          backgroundColor: AppColors.btnColor,
          child: Icon(
            Icons.add,
            size: 30.h,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewReportPost()),
            );
          }),
    );
  }
}
