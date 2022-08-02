import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/providers/register_provider.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/terms_and_conditions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';

class CollectDetailsPage extends StatelessWidget {
  const CollectDetailsPage({
    Key? key,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    // required bool sendMeUpdates,
    // required VoidCallback onTap
  })  : _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        _emailController = emailController,
        _phoneController = phoneController,
        _passwordController = passwordController,
        _confirmPasswordController = confirmPasswordController,
        // _sendMeUpdates = sendMeUpdates,
        // _onTap = onTap,
        super(key: key);

  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;
  final TextEditingController _emailController;
  final TextEditingController _phoneController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;
  // final bool _sendMeUpdates;
  // final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child:
          Consumer<RegisterProvider>(builder: (context, registerProvider, _) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LogoImage(),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 35.h,
              ),
              InputField(
                hintText: "First Name",
                prefixIcon: Icons.person_outline_rounded,
                controller: _firstNameController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Last Name",
                prefixIcon: Icons.person_outline_rounded,
                controller: _lastNameController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Email",
                prefixIcon: Icons.mail_outline_rounded,
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Phone Number",
                prefixIcon: Icons.phone_outlined,
                controller: _phoneController,
                textInputType: TextInputType.number,
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
                height: 20.h,
              ),
              InputField(
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _confirmPasswordController,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 310.w,
                height: 30.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        registerProvider.sendMeUpdatesFunc();
                      },
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
                            child: registerProvider.sendMeUpdates
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Send me updates and alerts",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 310.w,
                height: 30.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        registerProvider.acceptTermsFunc();
                      },
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
                            child: registerProvider.acceptTermsCondition
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            text: "I accept the ",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                      context,
                                      HeroDialogRoute(
                                          builder: (_) =>
                                              const TermsAndConditions())),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    decoration: TextDecoration.underline,
                                    color: AppColors.btnColor,
                                    fontWeight: FontWeight.w400),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
