import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/sign_up_page/sign_up_page.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/dashboard.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late AssetImage bgImage;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _saveAccountInfo = false;
  @override
  void initState() {
    bgImage = const AssetImage(
      "assets/images/bg.png",
    );
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(bgImage, context);
    super.didChangeDependencies();
  }

  _saveAccountInfoFunc() {
    setState(() {
      _saveAccountInfo = !_saveAccountInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: 926.h,
          width: 428.w,
          decoration: BoxDecoration(
              image: DecorationImage(image: bgImage, fit: BoxFit.fill)),
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
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _passwordController,
              ),
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
                height: 145.h,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DashBorad())),
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
                                builder: (_) => const SignUpPage()))),
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFFF23A02),
                          fontWeight: FontWeight.w400),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
