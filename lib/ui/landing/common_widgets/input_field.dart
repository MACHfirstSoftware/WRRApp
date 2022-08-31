import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;
  const InputField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.textInputType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isHide = true;
  String separator = "-";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 320.w,
      child: TextField(
        controller: widget.controller,
        inputFormatters: widget.hintText == "Phone Number (Optional)"
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9$separator]")),
                MaskedTextInputFormatter(
                  mask: "###-###-####",
                  separator: separator,
                )
              ]
            : null,
        toolbarOptions: widget.hintText == "Phone Number"
            ? const ToolbarOptions(
                copy: true,
                cut: true,
                paste: false,
                selectAll: false,
              )
            : null,
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
            padding: EdgeInsets.all(10.h),
            // child: SvgPicture.asset(
            //   widget.prefixIconPath,
            //   color: Colors.white,
            //   width: 20.w,
            //   height: 20.w,
            // ),
            child: Icon(
              widget.prefixIcon,
              color: Colors.white,
              size: 25.h,
            ),
          ),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: (() => setState(() {
                        isHide = !isHide;
                      })),
                  child: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Icon(
                      isHide
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white,
                      size: 25.h,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(10.h),
                  child: Icon(
                    Icons.backspace_outlined,
                    color: AppColors.backgroundColor,
                    size: 20.h,
                  ),
                ),
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

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;
  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
