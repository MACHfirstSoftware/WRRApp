import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/services/verfication_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class ResetPassword extends StatefulWidget {
  final User user;
  const ResetPassword({Key? key, required this.user}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController _newPassController;
  late TextEditingController _conPassController;
  late TextEditingController _otpController;
  @override
  void initState() {
    _newPassController = TextEditingController();
    _conPassController = TextEditingController();
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newPassController.dispose();
    _conPassController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  _validate() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_newPassController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is empty",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,40}$")
        .hasMatch(_newPassController.text)) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is incorrect",
          type: SnackBarType.error));
      return false;
    }
    if (_newPassController.text != _conPassController.text) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Passwords does not match",
          type: SnackBarType.error));
      return false;
    }
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "OTP code required",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doReset() async {
    if (_validate()) {
      PageLoader.showLoader(context);
      final otpVerify = await VerficationService.verifyCode(
          widget.user.id, _otpController.text);

      if (otpVerify) {
      } else {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Something went wrong",
            type: SnackBarType.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: const DefaultAppbar(title: "Reset Password"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35.h,
              width: 428.w,
            ),
            const LogoImage(),
            SizedBox(
              height: 35.h,
            ),
            InputField(
                hintText: "New Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _newPassController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            SizedBox(
              height: 20.h,
            ),
            InputField(
                hintText: "Confirm Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _conPassController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            SizedBox(
              height: 20.h,
            ),
            InputField(
              hintText: "OTP Code",
              controller: _otpController,
              prefixIconPath: "assets/icons/pin-code.svg",
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: 55.h,
              width: 428.w,
            ),
            GestureDetector(
                onTap: () => _doReset(),
                child: Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(7.5.w)),
                  child: SizedBox(
                    height: 30.h,
                    width: 100.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        "Next",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 35.h,
            ),
          ],
        ),
      )),
    );
  }
}
