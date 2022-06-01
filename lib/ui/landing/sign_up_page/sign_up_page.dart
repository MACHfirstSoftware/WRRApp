import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/dashboard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late AssetImage bgImage;
  int _currentStep = 0;
  late PageController _pageController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    bgImage = const AssetImage(
      "assets/images/bg.png",
    );
    _pageController = PageController(initialPage: 0);
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(bgImage, context);
    super.didChangeDependencies();
  }

  _onPageChange() {
    _pageController.jumpToPage(_currentStep);
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
                width: 300.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 20.w,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF23A02),
                          borderRadius: BorderRadius.circular(10.w)),
                    ),
                    Container(
                      color: const Color(0xFFF23A02),
                      height: 2.h,
                      width: 75.w,
                    ),
                    Container(
                      height: 20.w,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: _currentStep == 0
                              ? Colors.white
                              : const Color(0xFFF23A02),
                          borderRadius: BorderRadius.circular(10.w)),
                    ),
                    Container(
                      color: _currentStep == 2
                          ? const Color(0xFFF23A02)
                          : Colors.white,
                      height: 2.h,
                      width: 75.w,
                    ),
                    Container(
                      height: 20.w,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: _currentStep == 2
                              ? const Color(0xFFF23A02)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10.w)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 375.h,
                width: 310.w,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        Text(
                          "SIGN UP",
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
                          hintText: "First Name",
                          prefixIconPath: "assets/icons/user.svg",
                          controller: _firstNameController,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        InputField(
                          hintText: "Last Name",
                          prefixIconPath: "assets/icons/user.svg",
                          controller: _lastNameController,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        InputField(
                          hintText: "Email",
                          prefixIconPath: "assets/icons/mail.svg",
                          controller: _emailController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "SIGN UP",
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
                          hintText: "Password",
                          prefixIconPath: "assets/icons/lock.svg",
                          controller: _passwordController,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        InputField(
                          hintText: "Confrim Password",
                          prefixIconPath: "assets/icons/lock.svg",
                          controller: _confirmPasswordController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset("assets/icons/check-circle.svg",
                            height: 75.w, width: 75.w, color: Colors.white),
                        SizedBox(
                          height: 40.h,
                        ),
                        Text(
                          "Welcome \nto \nWisconsin Rut report",
                          style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const DashBorad())),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.h,
                            width: 190.w,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF23A02),
                                borderRadius: BorderRadius.circular(5.w)),
                            child: Text(
                              "Go to Dashboard",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_currentStep != 2)
                SizedBox(
                  width: 310.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_currentStep > 0) {
                            setState(() {
                              _currentStep--;
                              _onPageChange();
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 2.5.w,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5.w)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Backward",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_currentStep < 2) {
                            setState(() {
                              _currentStep++;
                              _onPageChange();
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF23A02),
                              borderRadius: BorderRadius.circular(5.w)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentStep == 1 ? "Submit" : "Forward",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Icon(
                                _currentStep == 1
                                    ? Icons.check
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 24.w,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
