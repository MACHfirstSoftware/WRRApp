import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final String prefixIconPath;
  final TextEditingController controller;
  const InputField({
    Key? key,
    required this.hintText,
    required this.prefixIconPath,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 310.w,
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(prefixIconPath, color: Colors.white),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          fillColor: Colors.transparent,
          filled: false,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
        ),
      ),
    );
  }
}
