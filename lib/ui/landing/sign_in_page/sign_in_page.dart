import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/purchases_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/register_page/register_page.dart';
import 'package:wisconsin_app/ui/landing/reset_password/user_verify.dart';
import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late FirebaseMessaging _firebaseMessaging;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _saveAccountInfo = true;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firebaseMessaging = FirebaseMessaging.instance;
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

      res.when(success: (User user) async {
        // final countyProvider =
        //     Provider.of<CountyProvider>(context, listen: false);
        // await countyProvider.getAllCounties();
        if (_saveAccountInfo) {
          await StoreUtils.saveUser({
            "email": _emailController.text,
            "password": _passwordController.text
          });
        }
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        final res = await PurchasesService.login(userId: user.id);
        if (res) {
          Provider.of<RevenueCatProvider>(context, listen: false)
              .setSubscriptionStatus(SubscriptionStatus.premium);
        } else {
          Provider.of<RevenueCatProvider>(context, listen: false)
              .setSubscriptionStatus(SubscriptionStatus.free);
        }
        _firebaseMessaging.getToken().then((value) {
          print("--------------- FCM TOKEN --------------");
          print(value);
          print("----------------------------------------");
        });
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false);
      }, failure: (NetworkExceptions error) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            // messageText: NetworkExceptions.getErrorMessage(error),
            messageText: "Sorry, login unsuccessful",
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            // messageText: responseError.error,
            messageText: "Sorry, login unsuccessful",
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  const LogoImage(),
                  const Spacer(),
                  Text(
                    "SIGN IN",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  InputField(
                    hintText: "Email",
                    prefixIcon: Icons.person_outline_rounded,
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InputField(
                      hintText: "Password",
                      prefixIcon: Icons.lock_outline_rounded,
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
                            height: 25.h,
                            width: 25.h,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.btnColor,
                                    style: BorderStyle.solid,
                                    width: 2.h,
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.h)),
                              child: _saveAccountInfo
                                  ? Icon(
                                      Icons.check,
                                      color: AppColors.btnColor,
                                      size: 20.h,
                                    )
                                  : null,
                            )),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  GestureDetector(
                    onTap: () => _doSignIn(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                          color: AppColors.btnColor,
                          borderRadius: BorderRadius.circular(10.w)),
                      child: SizedBox(
                        height: 25.h,
                        width: 100.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const UserVerify())),
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: Text(
                      "Register a New Account",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  // RichText(
                  //     text: TextSpan(
                  //         text: "Don't Have an Account?",
                  //         style: TextStyle(
                  //             fontSize: 16.sp,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w400),
                  //         children: <TextSpan>[
                  //       TextSpan(
                  //         text: "  SIGN UP",
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = (() => Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (_) => const QuestionnairePage()))),
                  //         style: TextStyle(
                  //             fontSize: 16.sp,
                  //             color: AppColors.btnColor,
                  //             fontWeight: FontWeight.w400),
                  //       )
                  //     ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
