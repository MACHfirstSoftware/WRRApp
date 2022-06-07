import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/background.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/verification_page/verification_page.dart';
import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _currentStep = 0;
  late PageController _pageController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  // late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    // _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    // _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  _onPageChange() {
    _pageController.jumpToPage(_currentStep);
  }

  _validateStepOne() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "First name is required",
          type: SnackBarType.error));
      return false;
    }
    if (_lastNameController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Last name is required",
          type: SnackBarType.error));
      return false;
    }
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Email is required",
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
    return true;
  }

  _validateStepTwo() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is required",
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
    if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Confirm Password is required",
          type: SnackBarType.error));
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password don't match",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doSignUp() async {
    if (_validateStepTwo()) {
      PageLoader.showLoader(context);
      Map<String, dynamic> person = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "emailAddress": _emailController.text,
        "username": _emailController.text,
        "password": _passwordController.text
      };
      final res = await UserService.signUp(person);
      Navigator.pop(context);
      if (res != null) {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Successfully registered!",
            type: SnackBarType.success));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VerificationPage(
                      userId: res,
                    )));
        setState(() {
          _currentStep++;
        });
        _onPageChange();
      } else {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Something went wrong!",
            type: SnackBarType.error));
      }
    }
  }

  _goDashborad() async {
    PageLoader.showLoader(context);
    final res = await UserService.signIn(
        _emailController.text, _passwordController.text);
    Map<String, dynamic> userData = res.data as Map<String, dynamic>;
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BottomNavBar(userName: userData["firstName"])),
        (route) => false);
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
            CustomStepper(currentStep: _currentStep),
            SizedBox(
              height: 375.h,
              width: 310.w,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StepOne(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      emailController: _emailController),
                  StepTwo(
                      // phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController),
                  _buildStepThree(),
                ],
              ),
            ),
            if (_currentStep != 2)
              SizedBox(
                width: 310.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBackwardButton(),
                    if (_currentStep == 0)
                      _buildForwardButton(() {
                        if (_validateStepOne()) {
                          setState(() {
                            _currentStep++;
                            _onPageChange();
                          });
                        }
                      }),
                    if (_currentStep == 1)
                      _buildForwardButton(() {
                        _doSignUp();
                      }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBackwardButton() {
    return GestureDetector(
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
    );
  }

  GestureDetector _buildForwardButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
              _currentStep == 1 ? Icons.check : Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24.w,
            )
          ],
        ),
      ),
    );
  }

  Column _buildStepThree() {
    return Column(
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
          onTap: () => _goDashborad(),
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
    );
  }
}

class CustomStepper extends StatelessWidget {
  const CustomStepper({
    Key? key,
    required int currentStep,
  })  : _currentStep = currentStep,
        super(key: key);

  final int _currentStep;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                color:
                    _currentStep == 0 ? Colors.white : const Color(0xFFF23A02),
                borderRadius: BorderRadius.circular(10.w)),
          ),
          Container(
            color: _currentStep == 2 ? const Color(0xFFF23A02) : Colors.white,
            height: 2.h,
            width: 75.w,
          ),
          Container(
            height: 20.w,
            width: 20.w,
            decoration: BoxDecoration(
                color:
                    _currentStep == 2 ? const Color(0xFFF23A02) : Colors.white,
                borderRadius: BorderRadius.circular(10.w)),
          ),
        ],
      ),
    );
  }
}

class StepTwo extends StatelessWidget {
  const StepTwo({
    Key? key,
    // required TextEditingController phoneController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  })  :
        // _phoneController = phoneController,
        _passwordController = passwordController,
        _confirmPasswordController = confirmPasswordController,
        super(key: key);

  // final TextEditingController _phoneController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        // InputField(
        //   hintText: "Phone Number",
        //   prefixIconPath: "assets/icons/lock.svg",
        //   controller: _phoneController,
        //   textInputType: TextInputType.number,
        // ),
        // SizedBox(
        //   height: 20.h,
        // ),
        InputField(
            hintText: "Password",
            prefixIconPath: "assets/icons/lock.svg",
            controller: _passwordController,
            textInputType: TextInputType.visiblePassword,
            obscureText: true),
        SizedBox(
          height: 20.h,
        ),
        InputField(
            hintText: "Confrim Password",
            prefixIconPath: "assets/icons/lock.svg",
            controller: _confirmPasswordController,
            textInputType: TextInputType.visiblePassword,
            obscureText: true),
      ],
    );
  }
}

class StepOne extends StatelessWidget {
  const StepOne({
    Key? key,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
  })  : _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        _emailController = emailController,
        super(key: key);

  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          textInputType: TextInputType.text,
        ),
        SizedBox(
          height: 20.h,
        ),
        InputField(
          hintText: "Last Name",
          prefixIconPath: "assets/icons/user.svg",
          controller: _lastNameController,
          textInputType: TextInputType.text,
        ),
        SizedBox(
          height: 20.h,
        ),
        InputField(
          hintText: "Email",
          prefixIconPath: "assets/icons/mail.svg",
          controller: _emailController,
          textInputType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
