import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/dashboard_appbar.dart';

class DashBorad extends StatefulWidget {
  const DashBorad({Key? key}) : super(key: key);

  @override
  State<DashBorad> createState() => _DashBoradState();
}

class _DashBoradState extends State<DashBorad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const DashboardAppBar(),
        elevation: 0,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
