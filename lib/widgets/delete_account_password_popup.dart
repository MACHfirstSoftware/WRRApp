import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';

class DeleteConfirmationPopup extends StatefulWidget {
  // final String title;
  // // final String message;
  // final String leftBtnText;
  // final String rightBtnText;
  final ValueChanged<String> onTap;
  // final VoidCallback? onRightTap;
  const DeleteConfirmationPopup({
    Key? key,
    required this.onTap,
    // this.onRightTap,
    // required this.title,
    // // required this.message,
    // required this.leftBtnText,
    // required this.rightBtnText
  }) : super(key: key);

  @override
  State<DeleteConfirmationPopup> createState() =>
      _DeleteConfirmationPopupState();
}

class _DeleteConfirmationPopupState extends State<DeleteConfirmationPopup> {
  late TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 428.w,
            ),
            Container(
              width: 350.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              decoration: BoxDecoration(
                  color: AppColors.popBGColor,
                  borderRadius: BorderRadius.circular(15.w)),
              child: Column(
                children: [
                  Text(
                    "Confirm Deletion",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.btnColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text("Confirm that this is your Account",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: InputField(
                        hintText: "Enter Password",
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: _textEditingController,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: AppColors.btnColor.withOpacity(0.4),
                            customBorder: const StadiumBorder(),
                            onTap: () {
                              if (_textEditingController.text.isNotEmpty) {
                                Navigator.pop(context);
                                widget.onTap(_textEditingController.text);
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 27.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  color: Colors.redAccent[400],
                                ),
                                width: 110.w,
                                height: 45.h,
                                child: SizedBox(
                                  width: 90.w,
                                  height: 30.h,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: AppColors.btnColor.withOpacity(0.4),
                            customBorder: const StadiumBorder(),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: AppColors.btnColor,
                                        width: 1.5.w)),
                                width: 110.w,
                                height: 45.h,
                                child: SizedBox(
                                  width: 90.w,
                                  height: 30.h,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: AppColors.btnColor,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
