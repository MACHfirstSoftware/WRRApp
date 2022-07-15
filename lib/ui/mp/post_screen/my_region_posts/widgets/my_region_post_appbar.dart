import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class MyRegionPostAppBar extends StatefulWidget {
  const MyRegionPostAppBar({Key? key}) : super(key: key);

  @override
  State<MyRegionPostAppBar> createState() => _MyRegionPostAppBarState();
}

class _MyRegionPostAppBarState extends State<MyRegionPostAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.btnColor,
              size: 30.h,
            )),
      ),
    );
  }
}
