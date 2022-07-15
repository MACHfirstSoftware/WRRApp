import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
import 'package:wisconsin_app/utils/common.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final picker = ImagePicker();
  XFile? _image;

  _doLogout() async {
    await StoreUtils.removeUser();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthMainPage()),
        (route) => false);
  }

  Future getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) {
        return;
      } else {
        setState(() {
          _image = pickedFile;
        });
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
    }
  }

  Future<ImageSource?> showImageSource(BuildContext context) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) => CupertinoActionSheet(actions: [
                CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.camera),
                    child: const Text("Camera")),
                CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.gallery),
                    child: const Text("Gallery")),
              ]));
    } else {
      return showModalBottomSheet<ImageSource>(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      leading: const Icon(Icons.camera_alt_outlined),
                      title: const Text("Camera"),
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.camera)),
                  ListTile(
                      leading: const Icon(Icons.image_outlined),
                      title: const Text("Gallery"),
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.gallery))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 332.5.h,
                width: 428.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.w),
                      bottomRight: Radius.circular(25.w),
                    )),
              ),
              Container(
                height: 325.h,
                width: 428.w,
                decoration: BoxDecoration(
                    color: AppColors.btnColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.w),
                      bottomRight: Radius.circular(25.w),
                    )),
                child: SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50.w,
                        ),
                        SizedBox(
                          height: 120.h,
                          width: 120.h,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(60.h),
                                  child: Container(
                                    color: Colors.white,
                                    child:
                                        Image.asset("assets/images/logo.png"),
                                  )),
                              Positioned(
                                bottom: 0.h,
                                right: 0.h,
                                child: GestureDetector(
                                  onTap: () async {
                                    ImageSource? source =
                                        await showImageSource(context);
                                    if (source != null) {
                                      getImage(source);
                                    } else {
                                      print("Get image source failed");
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.h),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.btnColor,
                                      size: 25.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          height: 50.h,
                          width: 150.w,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_circle_up_rounded,
                                    color: AppColors.btnColor, size: 30.h),
                                Text(
                                  "UPGRADE",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.btnColor,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: 40.w,
                        ),
                      ],
                    ),
                    Expanded(
                        child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                user.firstName + " " + user.lastName,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                user.emailAddress,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 40.h,
                            )),
                        SizedBox(
                          width: 30.w,
                        ),
                      ],
                    ))
                  ],
                )),
              ),
            ],
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 30.w),
            children: [
              _buildTile("My Posts & Reports", Icons.edit_note_rounded),
              _buildTile("Edit My Account", Icons.account_circle_outlined),
              _buildTile("Subscription", Icons.price_check_rounded),
              _buildTile("Notification Setting", Icons.notifications_none),
              _buildTile("Privacy Policy", Icons.lock_outline_rounded),
              _buildTile("Terms of Use", Icons.share_outlined),
              _buildLogoutBtn()
            ],
          )),
        ],
      ),
    );
  }

  _buildLogoutBtn() {
    return GestureDetector(
      onTap: () {
        _logOutModal(context);
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        margin: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.secondaryColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(7.5.w),
        ),
        child: Text(
          "Log out",
          style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.btnColor,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _buildTile(String title, IconData icon) {
    return Container(
      alignment: Alignment.center,
      height: 75.h,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.secondaryColor, width: 1.5.w),
        borderRadius: BorderRadius.circular(7.5.w),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 35.h),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        trailing: Icon(Icons.keyboard_arrow_down_rounded,
            color: AppColors.secondaryColor, size: 40.h),
      ),
    );
  }

  _logOutModal(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.h),
                        topRight: Radius.circular(20.h),
                      ),
                    ),
                    child: Text(
                      "Are you sure you want to log out?",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(color: AppColors.secondaryColor, height: 2.h),
                  GestureDetector(
                    onTap: () => _doLogout(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 60.h,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.h),
                            bottomRight: Radius.circular(20.h),
                          )),
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20.h),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.btnColor,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ));
  }
}
