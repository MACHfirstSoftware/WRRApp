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
    if (_oldPassController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Current password required",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,40}$")
        .hasMatch(_oldPassController.text)) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Current password is incorrect",
          type: SnackBarType.error));
      return false;
    }
    if (_newPassController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "New password required",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,40}$")
        .hasMatch(_newPassController.text)) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Incorrect format of new password",
          type: SnackBarType.error));
      return false;
    }
    if (_newPassController.text != _conPassController.text) {
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
      final res = await UserService.changePassword(
          _user.username, _oldPassController.text, _newPassController.text);
      Navigator.pop(context);
      if (res["success"]) {
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: res["message"],
            type: SnackBarType.success));
        await StoreUtils.saveUser(
            {"email": _user.emailAddress, "password": _newPassController.text});
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _oldPassController,
                  textInputType: TextInputType.text,
                  obscureText: true),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                  hintText: "New Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _newPassController,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock_outline_rounded,
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
                    height: 50.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: AppColors.btnColor,
                        borderRadius: BorderRadius.circular(7.5.w)),
                    child: SizedBox(
                      height: 25.h,
                      width: 100.w,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
