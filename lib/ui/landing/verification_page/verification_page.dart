import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/services/verfication_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/background.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class VerificationPage extends StatefulWidget {
  final String userId;
  const VerificationPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late TextEditingController _codeController;
  late TextEditingController _phoneController;
  bool codeSendSuccess = false;

  @override
  void initState() {
    _codeController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  _reSend() async {
    PageLoader.showLoader(context);
    final res = await VerficationService.reSendCode(
        widget.userId, _phoneController.text);
    Navigator.pop(context);
    if (res) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Code resend successful!",
          type: SnackBarType.success));
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Something went wrong!",
          type: SnackBarType.error));
    }
  }

  _verifyCode() async {
    if (_validateCode()) {
      PageLoader.showLoader(context);
      final res = await VerficationService.verifyCode(
          widget.userId, _codeController.text);

      if (res) {
        await VerficationService.personPatch(widget.userId);
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Successfully verified!",
            type: SnackBarType.success));
        PageLoader.showTransparentLoader(context);
        await Future.delayed(const Duration(milliseconds: 2100), () {
          Navigator.pop(context);
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Something went wrong!",
            type: SnackBarType.error));
      }
    }
  }

  _sendCode() async {
    if (_validatePhoneNumber()) {
      PageLoader.showLoader(context);
      final res = await VerficationService.sendCode(
          widget.userId, _phoneController.text);
      Navigator.pop(context);
      if (res) {
        setState(() {
          codeSendSuccess = true;
        });
      } else {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Something went wrong!",
            type: SnackBarType.error));
      }
    }
  }

  _validateCode() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Code is empty",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _validatePhoneNumber() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Phone number is required",
          type: SnackBarType.error));
      return false;
    }
    if (_phoneController.text.trimRight().length != 10) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Phone number is invalid",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () => Future.value(false),
      child: Background(
          child: Column(children: [
        SizedBox(
          height: 56.h,
        ),
        const LogoImage(),
        SizedBox(
          height: 120.h,
        ),
        // Text(
        //   "VERIFY YOUR \nPHONE NUMBER",
        //   style: TextStyle(
        //       fontSize: 24.sp,
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold),
        //   textAlign: TextAlign.center,
        // ),
        // SizedBox(
        //   height: 45.h,
        // ),
        if (codeSendSuccess) _buildCodeUI(),
        if (!codeSendSuccess) _buildPhoneUI()
      ])),
    ));
  }

  _buildCodeUI() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "We have sent your phone a verification code, please enter it to complete your account.",
            style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 45.h,
        ),
        InputField(
          hintText: "Verification Code",
          controller: _codeController,
          prefixIconPath: "assets/icons/pin-code.svg",
          textInputType: TextInputType.number,
        ),
        SizedBox(
          height: 60.h,
        ),
        GestureDetector(
          onTap: () => _verifyCode(),
          child: Container(
            alignment: Alignment.center,
            height: 50.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF23A02),
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "SUBMIT",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        GestureDetector(
          onTap: () => _reSend(),
          child: Text(
            "Resend",
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _buildPhoneUI() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "Congratulations, you have joined the Wisconsin Rut Report. Please verify you phone number to continue your account setup.",
            style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 45.h,
        ),
        InputField(
          hintText: "Phone Number",
          controller: _phoneController,
          prefixIconPath: "assets/icons/phone.svg",
          textInputType: TextInputType.number,
        ),
        SizedBox(
          height: 60.h,
        ),
        GestureDetector(
          onTap: () => _sendCode(),
          child: Container(
            alignment: Alignment.center,
            height: 50.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF23A02),
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "CONTINUE",
              style: TextStyle(
                  fontSize: 24.sp,
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
