import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const ReportPageAppBar(),
        elevation: 0,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
      ),
      body: const ReportContents(),
    );
  }
}
