import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Stack(
        children: [
          Positioned(
            bottom: 10.h,
            left: 0.w,
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 30.h,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                "WRR",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            right: 40.w,
            child: Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 30.h,
            ),
          ),
          Positioned(
            bottom: 10.h,
            right: 0.w,
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.h,
            ),
          ),
        ],
      ),
    );
  }
}
