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
  final String phoneNumber;
  const VerificationPage(
      {Key? key, required this.userId, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late TextEditingController _codeController;

  @override
  void initState() {
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  _reSend() async {
    PageLoader.showLoader(context);
    final res =
        await VerficationService.reSendCode(widget.userId, widget.phoneNumber);
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
      Navigator.pop(context);
      if (res) {
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
          height: 200.h,
        ),
        InputField(
          hintText: "Code",
          controller: _codeController,
          prefixIconPath: "assets/icons/lock.svg",
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
      ])),
    ));
  }
}
