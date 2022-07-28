import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/change_password.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/edit_my_account.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/my_friends.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/privacy_policy.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/terms_and_conditions.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final picker = ImagePicker();
  XFile? _image;
  late User _user;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();
  }

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
        Navigator.push(
            context,
            HeroDialogRoute(
                builder: (_) => ConfirmationPopup(
                      title: "Update",
                      message: "Do you want to change profile image?",
                      leftBtnText: "Change",
                      rightBtnText: "Keep",
                      onTap: _updateProfileImage,
                      onRightTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                    )));
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

  _updateProfileImage() async {
    PageLoader.showLoader(context);
    final data = {
      "personId": _user.id,
      "image": ImageUtil.getBase64Image(_image!.path),
      "fileName": ImageUtil.getImageName(_image!.name),
      "type": ImageUtil.getImageExtension(_image!.name)
    };
    final res = await UserService.updateProfileImage(data);
    Navigator.pop(context);
    if (res != null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully updated",
          type: SnackBarType.success));
      Provider.of<UserProvider>(context, listen: false).setUserProfile(res);
    } else {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Something went wrong",
          type: SnackBarType.error));
      setState(() {
        _image = null;
      });
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<UserProvider>(builder: (_, userModel, __) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                color: Colors.transparent,
                width: 428.w,
                child: Stack(
                  children: [
                    if (!_user
                        .subscriptionPerson![0].subscriptionApiModel.isPremium)
                      Positioned(
                          top: 0.h,
                          right: 75.w,
                          child: SizedBox(
                              height: 30.h,
                              width: 30.h,
                              child: SvgPicture.asset(
                                "assets/icons/premium.svg",
                                color: AppColors.btnColor,
                              ))),
                    Center(
                      child: SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.h),
                              child: Container(
                                  color: Colors.white,
                                  height: 100.h,
                                  width: 100.h,
                                  child: _image != null
                                      ? Image.file(
                                          File(
                                            _image!.path,
                                          ),
                                          fit: BoxFit.fill,
                                        )
                                      : userModel.user.profileImageUrl != null
                                          ? CachedNetworkImage(
                                              imageUrl: userModel
                                                  .user.profileImageUrl!,
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Image(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                  alignment: Alignment.center,
                                                );
                                              },
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                child: SizedBox(
                                                  height: 20.h,
                                                  width: 20.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress.progress,
                                                    color: AppColors.btnColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      color: AppColors.btnColor,
                                                      size: 20.h),
                                            )
                                          : Image.asset(
                                              "assets/images/logo.png")),
                            ),
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
                                    if (kDebugMode) {
                                      print("Get image source failed");
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 30.h,
                                  width: 30.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.h),
                                  ),
                                  child: SizedBox(
                                    height: 17.5.h,
                                    width: 17.5.h,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppColors.btnColor,
                                        size: 15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                userModel.user.firstName + " " + userModel.user.lastName,
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                userModel.user.emailAddress,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              // Stack(
              //   children: [
              //     Container(
              //       height: 332.5.h,
              //       width: 428.w,
              //       decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.only(
              //             bottomLeft: Radius.circular(25.w),
              //             bottomRight: Radius.circular(25.w),
              //           )),
              //     ),
              //     Container(
              //       height: 325.h,
              //       width: 428.w,
              //       decoration: BoxDecoration(
              //           color: AppColors.btnColor,
              //           borderRadius: BorderRadius.only(
              //             bottomLeft: Radius.circular(25.w),
              //             bottomRight: Radius.circular(25.w),
              //           )),
              //       child: SafeArea(
              //           child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           SizedBox(
              //             height: 15.h,
              //           ),
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               SizedBox(
              //                 width: 50.w,
              //               ),
              //               SizedBox(
              //                 height: 120.h,
              //                 width: 120.h,
              //                 child: Stack(
              //                   children: [
              //                     ClipRRect(
              //                       borderRadius: BorderRadius.circular(60.h),
              //                       child: Container(
              //                           color: Colors.white,
              //                           height: 120.h,
              //                           width: 120.h,
              //                           child: _image != null
              //                               ? Image.file(
              //                                   File(
              //                                     _image!.path,
              //                                   ),
              //                                   fit: BoxFit.fill,
              //                                 )
              //                               : userModel.user.profileImageUrl !=
              //                                       null
              //                                   ? CachedNetworkImage(
              //                                       imageUrl: userModel
              //                                           .user.profileImageUrl!,
              //                                       imageBuilder:
              //                                           (context, imageProvider) {
              //                                         return Image(
              //                                           image: imageProvider,
              //                                           fit: BoxFit.fill,
              //                                           alignment:
              //                                               Alignment.center,
              //                                         );
              //                                       },
              //                                       progressIndicatorBuilder:
              //                                           (context, url,
              //                                                   progress) =>
              //                                               Center(
              //                                         child: SizedBox(
              //                                           height: 20.h,
              //                                           width: 20.h,
              //                                           child:
              //                                               CircularProgressIndicator(
              //                                             value:
              //                                                 progress.progress,
              //                                             color:
              //                                                 AppColors.btnColor,
              //                                           ),
              //                                         ),
              //                                       ),
              //                                       errorWidget: (context, url,
              //                                               error) =>
              //                                           Icon(
              //                                               Icons
              //                                                   .broken_image_outlined,
              //                                               color: AppColors
              //                                                   .btnColor,
              //                                               size: 20.h),
              //                                     )
              //                                   : Image.asset(
              //                                       "assets/images/logo.png")),
              //                     ),
              //                     Positioned(
              //                       bottom: 0.h,
              //                       right: 0.h,
              //                       child: GestureDetector(
              //                         onTap: () async {
              //                           ImageSource? source =
              //                               await showImageSource(context);
              //                           if (source != null) {
              //                             getImage(source);
              //                           } else {
              //                             if (kDebugMode) {
              //                               print("Get image source failed");
              //                             }
              //                           }
              //                         },
              //                         child: Container(
              //                           alignment: Alignment.center,
              //                           height: 40.h,
              //                           width: 40.h,
              //                           decoration: BoxDecoration(
              //                             color: Colors.white,
              //                             borderRadius:
              //                                 BorderRadius.circular(20.h),
              //                           ),
              //                           child: Icon(
              //                             Icons.camera_alt_outlined,
              //                             color: AppColors.btnColor,
              //                             size: 25.h,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               const Spacer(),
              //               Container(
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(10.w),
              //                 ),
              //                 height: 50.h,
              //                 width: 150.w,
              //                 child: Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceEvenly,
              //                     children: [
              //                       Icon(Icons.arrow_circle_up_rounded,
              //                           color: AppColors.btnColor, size: 30.h),
              //                       Text(
              //                         "UPGRADE",
              //                         style: TextStyle(
              //                             fontSize: 16.sp,
              //                             color: AppColors.btnColor,
              //                             fontWeight: FontWeight.w500),
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     ]),
              //               ),
              //               SizedBox(
              //                 width: 40.w,
              //               ),
              //             ],
              //           ),
              //           Expanded(
              //               child: Row(
              //             // mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               SizedBox(
              //                 width: 50.w,
              //               ),
              //               Expanded(
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.h,
              //                     ),
              //                     Text(
              //                       userModel.user.firstName +
              //                           " " +
              //                           userModel.user.lastName,
              //                       style: TextStyle(
              //                           fontSize: 20.sp,
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.bold),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                     Text(
              //                       userModel.user.emailAddress,
              //                       style: TextStyle(
              //                           fontSize: 14.sp,
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w500),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               IconButton(
              //                   onPressed: () {},
              //                   icon: Icon(
              //                     Icons.notifications_outlined,
              //                     color: Colors.white,
              //                     size: 40.h,
              //                   )),
              //               SizedBox(
              //                 width: 30.w,
              //               ),
              //             ],
              //           ))
              //         ],
              //       )),
              //     ),
              //   ],
              // ),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
                children: [
                  _buildTile("My Friends", Icons.account_circle_outlined,
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyFriends())))),
                  _buildTile("Edit My Account", Icons.edit_note_rounded,
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditMyAccount())))),
                  _buildTile("Change Password", Icons.lock_outline_rounded,
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePassword())))),
                  _buildTile("Subscription", Icons.price_check_rounded),
                  // _buildTile("Notification Setting", Icons.notifications_none),
                  _buildTile("Privacy Policy", Icons.verified_user_outlined,
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PrivacyPolicy())))),
                  _buildTile("Terms & Conditions", Icons.list_alt_rounded,
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TermsAndConditions())))),
                  _buildLogoutBtn()
                ],
              )),
            ],
          ),
        );
      }),
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
          border: Border.all(color: AppColors.popBGColor, width: 1.5.w),
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

  _buildTile(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 75.h,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.popBGColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(7.5.w),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          horizontalTitleGap: 10.w,
          leading: Icon(icon, color: Colors.white, size: 30.h),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.popBGColor, size: 35.h),
        ),
      ),
    );
  }

  _logOutModal(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => SafeArea(
              child: Padding(
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
                      child: SizedBox(
                        height: 25.h,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "Are you sure you want to log out?",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(color: Colors.grey[200], height: .5.h),
                    GestureDetector(
                      onTap: () => _doLogout(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.h),
                              bottomRight: Radius.circular(20.h),
                            )),
                        child: SizedBox(
                            height: 30.h,
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20.h),
                        ),
                        child: SizedBox(
                            height: 30.h,
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.btnColor,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ));
  }
}
