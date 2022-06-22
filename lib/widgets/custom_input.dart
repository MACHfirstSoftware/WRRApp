import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final int? maxLines;
  final TextEditingController controller;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.maxLines,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: TextField(
        controller: controller,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            decoration: TextDecoration.none),
        textAlignVertical: TextAlignVertical.top,
        // textAlign: TextAlign.end,
        cursorColor: AppColors.btnColor,
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(
                color: AppColors.btnColor,
                fontSize: 16.sp,
                decoration: TextDecoration.none),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            decoration: TextDecoration.none,
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.btnColor),
              borderRadius: BorderRadius.circular(5.w)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
        ),
      ),
    );
  }
}
