import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/landing/register_page/register_page.dart';
import 'package:wisconsin_app/ui/landing/sign_in_page/sign_in_page.dart';

class AuthMainPage extends StatefulWidget {
  const AuthMainPage({Key? key}) : super(key: key);

  @override
  State<AuthMainPage> createState() => _AuthMainPageState();
}

class _AuthMainPageState extends State<AuthMainPage> {
  late AssetImage logoImage;
  @override
  void initState() {
    logoImage = const AssetImage(
      "assets/images/app-logo.png",
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(logoImage, context);
    super.didChangeDependencies();
  }

  _goSignIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SignInPage()));
  }

  _goRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .8],
          colors: [AppColors.secondaryColor, AppColors.primaryColor],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: logoImage,
              // color: AppColors.btnColor,
              height: 200.h,
              width: 320.w,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 40.h,
              width: 428.w,
            ),
            _buildSubmitBtn(() => _goSignIn(), "Sign In"),
            SizedBox(
              height: 20.h,
              width: 428.w,
            ),
            _buildSubmitBtn(() => _goRegister(), "Register"),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildSubmitBtn(VoidCallback onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 60.h,
        width: 200.w,
        decoration: BoxDecoration(
            color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(10.w)),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
