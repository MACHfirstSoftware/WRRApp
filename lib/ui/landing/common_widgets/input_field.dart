import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/config.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final String prefixIconPath;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;
  const InputField({
    Key? key,
    required this.hintText,
    required this.prefixIconPath,
    required this.controller,
    required this.textInputType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 310.w,
      child: TextField(
        controller: widget.controller,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            decoration: TextDecoration.none),
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppColors.btnColor,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText ? isHide : widget.obscureText,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.5.h),
            child: SvgPicture.asset(
              widget.prefixIconPath,
              color: Colors.white,
              width: 10.h,
              height: 10.h,
            ),
          ),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: (() => setState(() {
                        isHide = !isHide;
                      })),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Icon(
                      isHide
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          fillColor: Colors.transparent,
          filled: false,
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              decoration: TextDecoration.none),
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
