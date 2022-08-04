// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wisconsin_app/config.dart';
// import 'package:wisconsin_app/services/verfication_service.dart';
// import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
// import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
// import 'package:wisconsin_app/ui/landing/register_page/lets_go_page.dart';
// import 'package:wisconsin_app/widgets/page_loader.dart';
// import 'package:wisconsin_app/widgets/snackbar.dart';

// class VerificationPage extends StatefulWidget {
//   final String userId;
//   final String phoneNumber;
//   final String email;
//   final String password;
//   const VerificationPage({
//     Key? key,
//     required this.userId,
//     required this.phoneNumber,
//     required this.email,
//     required this.password,
//   }) : super(key: key);

//   @override
//   State<VerificationPage> createState() => _VerificationPageState();
// }

// class _VerificationPageState extends State<VerificationPage> {
//   late TextEditingController _codeController;

//   @override
//   void initState() {
//     _codeController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _codeController.dispose();
//     super.dispose();
//   }

//   _reSend() async {
//     PageLoader.showLoader(context);
//     final res =
//         await VerficationService.reSendCode(widget.userId, widget.phoneNumber);
//     Navigator.pop(context);
//     if (res) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Code resend successful!",
//           type: SnackBarType.success));
//     } else {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Something went wrong!",
//           type: SnackBarType.error));
//     }
//   }

//   _verifyCode() async {
//     if (_validateCode()) {
//       PageLoader.showLoader(context);
//       final res = await VerficationService.verifyCode(
//           widget.userId, _codeController.text.trim());

//       if (res) {
//         await VerficationService.personPhonePatch(
//             widget.userId, widget.phoneNumber);
//         // await VerficationService.personActivePatch(widget.userId);
//         Navigator.pop(context);
//         ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//             context: context,
//             messageText: "Successfully verified!",
//             type: SnackBarType.success));
//         PageLoader.showTransparentLoader(context);
//         await Future.delayed(const Duration(milliseconds: 2100), () {
//           Navigator.pop(context);
//         });
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => LetsGoPage(
//                       userId: widget.userId,
//                       email: widget.email,
//                       password: widget.password,
//                     )),
//             (route) => false);
//       } else {
//         Navigator.pop(context);
//         ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//             context: context,
//             messageText: "Something went wrong!",
//             type: SnackBarType.error));
//       }
//     }
//   }

//   _validateCode() {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     if (_codeController.text.isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Code is empty",
//           type: SnackBarType.error));
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => Future.value(false),
//       child: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Scaffold(
//             backgroundColor: AppColors.backgroundColor,
//             resizeToAvoidBottomInset: false,
//             body: SafeArea(
//               child: Column(children: [
//                 SizedBox(
//                   height: 56.h,
//                 ),
//                 const LogoImage(),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Text(
//                     "We have sent your phone a verification code, please enter it to complete your account.",
//                     style: TextStyle(
//                         fontSize: 16.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 35.h,
//                 ),
//                 InputField(
//                   hintText: "WRR Verification Code",
//                   controller: _codeController,
//                   prefixIcon: Icons.pin_outlined,
//                   textInputType: TextInputType.number,
//                 ),
//                 SizedBox(
//                   height: 40.h,
//                 ),
//                 GestureDetector(
//                   onTap: () => _verifyCode(),
//                   child: Container(
//                     alignment: Alignment.center,
//                     height: 40.h,
//                     width: 130.w,
//                     decoration: BoxDecoration(
//                         color: AppColors.btnColor,
//                         borderRadius: BorderRadius.circular(5.w)),
//                     child: SizedBox(
//                         height: 25.h,
//                         width: 100.w,
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           alignment: Alignment.center,
//                           child: Text(
//                             "Next",
//                             style: TextStyle(
//                                 fontSize: 20.sp,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600),
//                             textAlign: TextAlign.center,
//                           ),
//                         )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 GestureDetector(
//                   onTap: () => _reSend(),
//                   child: Text(
//                     "Resend",
//                     style: TextStyle(
//                       decoration: TextDecoration.underline,
//                       fontSize: 14.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ]),
//             )),
//       ),
//     );
//   }

//   // _buildCodeUI() {
//   //   return Column(
//   //     children: [
//   //       Padding(
//   //         padding: EdgeInsets.symmetric(horizontal: 20.w),
//   //         child: Text(
//   //           "We have sent your phone a verification code, please enter it to complete your account.",
//   //           style: TextStyle(
//   //               fontSize: 22.sp,
//   //               color: Colors.white,
//   //               fontWeight: FontWeight.bold),
//   //           textAlign: TextAlign.center,
//   //         ),
//   //       ),
//   //       SizedBox(
//   //         height: 45.h,
//   //       ),
//   //       InputField(
//   //         hintText: "Verification Code",
//   //         controller: _codeController,
//   //         prefixIconPath: "assets/icons/pin-code.svg",
//   //         textInputType: TextInputType.number,
//   //       ),
//   //       SizedBox(
//   //         height: 60.h,
//   //       ),
//   //       GestureDetector(
//   //         onTap: () => _verifyCode(),
//   //         child: Container(
//   //           alignment: Alignment.center,
//   //           height: 50.h,
//   //           width: 190.w,
//   //           decoration: BoxDecoration(
//   //               color: AppColors.btnColor,
//   //               borderRadius: BorderRadius.circular(5.w)),
//   //           child: Text(
//   //             "Next",
//   //             style: TextStyle(
//   //                 fontSize: 24.sp,
//   //                 color: Colors.white,
//   //                 fontWeight: FontWeight.bold),
//   //             textAlign: TextAlign.center,
//   //           ),
//   //         ),
//   //       ),
//   //       SizedBox(
//   //         height: 20.h,
//   //       ),
//   //       GestureDetector(
//   //         onTap: () => _reSend(),
//   //         child: Text(
//   //           "Resend",
//   //           style: TextStyle(
//   //               fontSize: 20.sp,
//   //               color: Colors.white,
//   //               fontWeight: FontWeight.w400),
//   //           textAlign: TextAlign.center,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // _buildPhoneUI() {
//   //   return Column(
//   //     children: [
//   //       Padding(
//   //         padding: EdgeInsets.symmetric(horizontal: 20.w),
//   //         child: Text(
//   //           "Congratulations, you have joined the Wisconsin Rut Report. Please verify you phone number to continue your account setup.",
//   //           style: TextStyle(
//   //               fontSize: 22.sp,
//   //               color: Colors.white,
//   //               fontWeight: FontWeight.bold),
//   //           textAlign: TextAlign.center,
//   //         ),
//   //       ),
//   //       SizedBox(
//   //         height: 45.h,
//   //       ),
//   //       InputField(
//   //         hintText: "Phone Number",
//   //         controller: _phoneController,
//   //         prefixIconPath: "assets/icons/phone.svg",
//   //         textInputType: TextInputType.number,
//   //       ),
//   //       SizedBox(
//   //         height: 60.h,
//   //       ),
//   //       GestureDetector(
//   //         onTap: () => _sendCode(),
//   //         child: Container(
//   //           alignment: Alignment.center,
//   //           height: 50.h,
//   //           width: 190.w,
//   //           decoration: BoxDecoration(
//   //               color: AppColors.btnColor,
//   //               borderRadius: BorderRadius.circular(5.w)),
//   //           child: Text(
//   //             "CONTINUE",
//   //             style: TextStyle(
//   //                 fontSize: 24.sp,
//   //                 color: Colors.white,
//   //                 fontWeight: FontWeight.bold),
//   //             textAlign: TextAlign.center,
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
// }
