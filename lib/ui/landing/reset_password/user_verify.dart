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
        // final otpSend = await VerficationService.sendCode(
        //     user.id, user.phoneMobile,
        //     isReset: true);
        // Navigator.pop(context);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (_) => ResetPassword(user: user)));
        // if (otpSend) {
        //   PageLoader.showTransparentLoader(context);
        //   ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
        //       context: context,
        //       messageText: "OTP has been send to your mobile",
        //       type: SnackBarType.success));
        //   await Future.delayed(const Duration(seconds: 2));
        //   Navigator.pop(context);
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(builder: (_) => ResetPassword(user: user)));
        // } else {
        //   ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
        //       context: context,
        //       messageText: "Couldn't send OTP",
        //       type: SnackBarType.error));
        // }
        final options = await UserService.getVerificationOptions(user.id);
        Navigator.pop(context);
        if (options.length == 1 && options.first == "Email") {
          _sendCode(user, options.first);
        } else {
          showSheet(options, user);
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                height: 50.h,
                width: 428.w,
              ),
              const LogoImage(),
              SizedBox(
                height: 75.h,
              ),
              InputField(
                hintText: "Email",
                prefixIcon: Icons.person_outline_rounded,
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 35.h,
                width: 428.w,
              ),
              GestureDetector(
                  onTap: () {
                    _doVerify();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: AppColors.btnColor,
                        borderRadius: BorderRadius.circular(7.5.w)),
                    child: SizedBox(
                      height: 25.h,
                      width: 100.w,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
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
      ),
    );
  }

  Future showSheet(List<String> _options, User user) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        context: context,
        builder: (context) => Container(
              constraints: BoxConstraints(maxHeight: 700.h),
              decoration: BoxDecoration(
                  color: AppColors.popBGColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  )),
              child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35.h,
                        width: 300.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "Choose Verification Option",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                        width: 428.w,
                      ),
                      ..._options.map(
                        (e) => Card(
                          color: Colors.white10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w)),
                          child: Theme(
                            data: ThemeData.light(),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 0),
                              title: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _sendCode(user, e);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      )
                    ],
                  )),
            ));
  }

  _sendCode(User user, String option) async {
    if (option == "Email") {
      PageLoader.showLoader(context);
      final res = await VerficationService.sendCodeMail(user.id);
      Navigator.pop(context);
      if (res) {
        PageLoader.showTransparentLoader(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Verification code has been send to your email",
            type: SnackBarType.success));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => ResetPassword(user: user)));
      } else {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Couldn't send verification code",
            type: SnackBarType.error));
      }
    }
    if (option == "Phone") {
      PageLoader.showLoader(context);
      final res = await VerficationService.sendCodeMobile(
          user.id, user.phoneMobile,
          isReset: true);
      Navigator.pop(context);
      if (res) {
        PageLoader.showTransparentLoader(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Verification code has been send to your phone",
            type: SnackBarType.success));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => ResetPassword(user: user)));
      } else {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Couldn't send verification code",
            type: SnackBarType.error));
      }
    }
  }
}
