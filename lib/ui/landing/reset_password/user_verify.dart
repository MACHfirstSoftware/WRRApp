import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/services/verfication_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/reset_password/reset_password.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class UserVerify extends StatefulWidget {
  const UserVerify({Key? key}) : super(key: key);

  @override
  State<UserVerify> createState() => _UserVerifyState();
}

class _UserVerifyState extends State<UserVerify> {
  late TextEditingController _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  _validate() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Email is empty",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Email is invalid",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doVerify() async {
    if (_validate()) {
      PageLoader.showLoader(context);
      final res = await UserService.verifyUser(_emailController.text.trim());
      res.when(success: (User user) async {
        final otpSend =
            await VerficationService.sendCode(user.id, user.phoneMobile);
        Navigator.pop(context);
        if (otpSend) {
          PageLoader.showTransparentLoader(context);
          ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
              context: context,
              messageText: "OTP has been send to your mobile",
              type: SnackBarType.success));
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => ResetPassword(user: user)));
        } else {
          ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
              context: context,
              messageText: "Couldn't send OTP",
              type: SnackBarType.error));
        }
      }, failure: (NetworkExceptions error) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: NetworkExceptions.getErrorMessage(error) ==
                    "Unauthorized request"
                ? "User not found"
                : NetworkExceptions.getErrorMessage(error),
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: responseError.error,
            type: SnackBarType.error));
      });
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
              hintText: "Email",
              prefixIconPath: "assets/icons/user.svg",
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 55.h,
              width: 428.w,
            ),
            GestureDetector(
                onTap: () {
                  _doVerify();
                },
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
