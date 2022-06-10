import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/background.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/questionnaire_page/questionnaire_page.dart';
import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _saveAccountInfo = false;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _saveAccountInfoFunc() {
    setState(() {
      _saveAccountInfo = !_saveAccountInfo;
    });
  }

  _validateSigning() {
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
        .hasMatch(_emailController.text)) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Email is invalid",
          type: SnackBarType.error));
      return false;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is empty",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,40}$")
        .hasMatch(_passwordController.text)) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is incorrect",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doSignIn() async {
    if (_validateSigning()) {
      PageLoader.showLoader(context);
      final res = await UserService.signIn(
          _emailController.text, _passwordController.text);
      Navigator.pop(context);

      res.when(success: (User user) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar(user: user)),
            (route) => false);
      }, failure: (NetworkExceptions error) {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: NetworkExceptions.getErrorMessage(error),
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
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
      backgroundColor: Colors.white,
      body: Background(
        child: Column(
          children: [
            SizedBox(
              height: 56.h,
            ),
            const LogoImage(),
            SizedBox(
              height: 145.h,
            ),
            Text(
              "SIGN IN",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 45.h,
            ),
            InputField(
              hintText: "Email",
              prefixIconPath: "assets/icons/user.svg",
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 20.h,
            ),
            InputField(
                hintText: "Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _passwordController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _saveAccountInfoFunc(),
                  child: SizedBox(
                      height: 25.w,
                      width: 25.w,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFF23A02),
                              style: BorderStyle.solid,
                              width: 2.5.w,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5.w)),
                        child: _saveAccountInfo
                            ? Icon(
                                Icons.check,
                                color: const Color(0xFFF23A02),
                                size: 20.w,
                              )
                            : null,
                      )),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  "Save Account Info ?",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              // height: 60.h,
              height: 145.h,
            ),
            GestureDetector(
              onTap: () => _doSignIn(),
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                width: 190.w,
                decoration: BoxDecoration(
                    color: const Color(0xFFF23A02),
                    borderRadius: BorderRadius.circular(5.w)),
                child: Text(
                  "SIGN IN",
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 45.h,
            ),
            Text(
              "Forgot your password?",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            RichText(
                text: TextSpan(
                    text: "Don't Have an Account?",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    children: <TextSpan>[
                  TextSpan(
                    text: "  SIGN UP",
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QuestionnairePage()))),
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFFF23A02),
                        fontWeight: FontWeight.w400),
                  )
                ]))
          ],
        ),
      ),
    );
  }
}
