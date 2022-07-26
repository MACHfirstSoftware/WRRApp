import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _oldPassController;
  late TextEditingController _newPassController;
  late TextEditingController _conPassController;
  late User _user;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _oldPassController = TextEditingController();
    _newPassController = TextEditingController();
    _conPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _conPassController.dispose();
    super.dispose();
  }

  _validate() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_oldPassController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Current password required",
          type: SnackBarType.error));
      return false;
    }
    if (_newPassController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "New password required",
          type: SnackBarType.error));
      return false;
    }
    if (_newPassController.text.trim() != _conPassController.text.trim()) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password does not match",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doUpdate() async {
    if (_validate()) {
      PageLoader.showLoader(context);
      final res = await UserService.changePassword(_user.username,
          _oldPassController.text.trim(), _newPassController.text.trim());
      Navigator.pop(context);
      if (res["success"]) {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: res["message"],
            type: SnackBarType.success));
        await StoreUtils.saveUser({
          "email": _user.emailAddress,
          "password": _newPassController.text.trim()
        });
      } else {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: res["message"],
            type: SnackBarType.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: const DefaultAppbar(title: "Change Password"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35.h,
              width: 428.w,
            ),
            const LogoImage(),
            SizedBox(
              height: 35.h,
            ),
            InputField(
                hintText: "Current Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _oldPassController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            SizedBox(
              height: 20.h,
            ),
            InputField(
                hintText: "New Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _newPassController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            SizedBox(
              height: 20.h,
            ),
            InputField(
                hintText: "Confirm Password",
                prefixIconPath: "assets/icons/lock.svg",
                controller: _conPassController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            SizedBox(
              height: 55.h,
              width: 428.w,
            ),
            GestureDetector(
                onTap: _doUpdate,
                child: Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(7.5.w)),
                  child: SizedBox(
                    height: 30.h,
                    width: 100.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        "Update",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
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
    );
  }
}