import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.w,
      width: 150.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(75.w),
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
