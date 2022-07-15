// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:wisconsin_app/config.dart';
// import 'package:wisconsin_app/models/county.dart';
// import 'package:wisconsin_app/models/question.dart';
// import 'package:wisconsin_app/models/response_error.dart';
// import 'package:wisconsin_app/models/user.dart';
// import 'package:wisconsin_app/providers/county_provider.dart';
// import 'package:wisconsin_app/providers/user_provider.dart';
// import 'package:wisconsin_app/services/questionnaire_service.dart';
// import 'package:wisconsin_app/services/subscription_service.dart';
// import 'package:wisconsin_app/services/user_service.dart';
// import 'package:wisconsin_app/services/verfication_service.dart';
// import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
// import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
// import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
// import 'package:wisconsin_app/ui/landing/register_page/widgets/page_stepper.dart';
// import 'package:wisconsin_app/ui/landing/subscription_page/subscription_screen.dart';
// import 'package:wisconsin_app/ui/landing/verification_page/verification_page.dart';
// import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
// import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
// import 'package:wisconsin_app/utils/hero_dialog_route.dart';
// import 'package:wisconsin_app/widgets/page_loader.dart';
// import 'package:wisconsin_app/widgets/snackbar.dart';

// class SignUpPage extends StatefulWidget {
//   final County county;
//   final List<Answer> selectedAnswers;
//   final List<Question> questions;
//   const SignUpPage(
//       {Key? key,
//       required this.county,
//       required this.selectedAnswers,
//       required this.questions})
//       : super(key: key);

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   int _currentStep = 0;
//   bool _sendMeUpdates = false;
//   late String _userId;
//   late PageController _pageController;
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   late TextEditingController _passwordController;
//   late TextEditingController _confirmPasswordController;

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: 0);
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _emailController = TextEditingController();
//     _phoneController = TextEditingController();
//     _passwordController = TextEditingController();
//     _confirmPasswordController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//   }

//   _onPageChange() {
//     _pageController.jumpToPage(_currentStep);
//   }

//   _sendMeUpdatesFunc() {
//     setState(() {
//       _sendMeUpdates = !_sendMeUpdates;
//     });
//   }

//   // _validateStepOne() {
//   //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
//   //   if (_firstNameController.text.isEmpty) {
//   //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//   //         context: context,
//   //         messageText: "First name is required",
//   //         type: SnackBarType.error));
//   //     return false;
//   //   }
//   //   if (_lastNameController.text.isEmpty) {
//   //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//   //         context: context,
//   //         messageText: "Last name is required",
//   //         type: SnackBarType.error));
//   //     return false;
//   //   }
//   //   if (_emailController.text.isEmpty) {
//   //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//   //         context: context,
//   //         messageText: "Email is required",
//   //         type: SnackBarType.error));
//   //     return false;
//   //   }
//   //   if (!RegExp(
//   //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//   //       .hasMatch(_emailController.text)) {
//   //     ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//   //         context: context,
//   //         messageText: "Email is invalid",
//   //         type: SnackBarType.error));
//   //     return false;
//   //   }
//   //   return true;
//   // }

//   _validateRegister() {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     if (_firstNameController.text.trim().isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "First name is required",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (_lastNameController.text.trim().isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Last name is required",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (_emailController.text.trim().isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Email is required",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (!RegExp(
//             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//         .hasMatch(_emailController.text.trim())) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Email is invalid",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (_phoneController.text.trim().isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Phone number is required",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (!RegExp(r"^[0-9]{3}-[0-9]{3}-[0-9]{4}$")
//         .hasMatch(_phoneController.text.trim())) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Phone number is invalid",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (_passwordController.text.isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Password is required",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,40}$")
//         .hasMatch(_passwordController.text)) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Password is incorrect",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (_confirmPasswordController.text.isEmpty) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Confirm Password is required",
//           type: SnackBarType.error));
//       return false;
//     }
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Password don't match",
//           type: SnackBarType.error));
//       return false;
//     }
//     return true;
//   }

//   _createQuestionnaireDataList(String userId) {
//     List<Map<String, dynamic>> _questionnaireData = [];
//     for (int i = 0; i < widget.questions.length; i++) {
//       _questionnaireData.add({
//         "personId": userId,
//         "questionId": widget.questions[i].id,
//         "answerId": widget.selectedAnswers[i].id,
//         "answerComment": ""
//       });
//     }
//     return _questionnaireData;
//   }

//   _doSignUp() async {
//     if (_validateRegister()) {
//       PageLoader.showLoader(context);
//       Map<String, dynamic> person = {
//         "firstName": _firstNameController.text.trim(),
//         "lastName": _lastNameController.text.trim(),
//         "emailAddress": _emailController.text.trim(),
//         "username": _emailController.text.trim(),
//         "password": _passwordController.text,
//         "country": "US",
//         "countyId": widget.county.id,
//         "regionId": widget.county.regionId,
//         "isOptIn": _sendMeUpdates
//       };
//       final res = await UserService.signUp(person);

//       res.when(success: (String userId) async {
//         await QuestionnaireService.saveQuestionnaire(
//             _createQuestionnaireDataList(userId));
//         _userId = userId;
//         await VerficationService.sendCode(userId, _phoneController.text.trim());
//         Navigator.pop(context);
//         await Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => VerificationPage(
//                       userId: userId,
//                       phoneNumber: _phoneController.text,
//                       email: "",
//                       password: "",
//                     )));
//         setState(() {
//           _currentStep++;
//         });
//         _onPageChange();
//         _subscription();
//       }, failure: (NetworkExceptions error) {
//         ScaffoldMessenger.of(context).removeCurrentSnackBar();
//         Navigator.pop(context);
//         ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//             context: context,
//             messageText: NetworkExceptions.getErrorMessage(error),
//             type: SnackBarType.error));
//       }, responseError: (ResponseError responseError) {
//         ScaffoldMessenger.of(context).removeCurrentSnackBar();
//         Navigator.pop(context);
//         ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//             context: context,
//             messageText: responseError.error,
//             type: SnackBarType.error));
//       });
//     }
//   }

//   _subscription() async {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     int sId = await Navigator.of(context).push(
//       HeroDialogRoute(builder: (context) => const SubscriptionScreen()),
//     );
//     PageLoader.showLoader(context);
//     final subscriptionResponse =
//         await SubscriptionService.addSubscription(_userId, sId);
//     Navigator.pop(context);
//     subscriptionResponse.when(success: (bool success) async {
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: "Successfully subscribed!",
//           type: SnackBarType.success));
//     }, failure: (NetworkExceptions error) async {
//       PageLoader.showTransparentLoader(context);
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: NetworkExceptions.getErrorMessage(error),
//           type: SnackBarType.error));
//       await Future.delayed(const Duration(milliseconds: 2200), () {
//         Navigator.pop(context);
//       });
//       _subscription();
//     }, responseError: (ResponseError responseError) async {
//       PageLoader.showTransparentLoader(context);
//       ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
//           context: context,
//           messageText: responseError.error,
//           type: SnackBarType.error));
//       await Future.delayed(const Duration(milliseconds: 2200), () {
//         Navigator.pop(context);
//       });
//       _subscription();
//     });
//   }

//   _letsGo() async {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     PageLoader.showLoader(context);
//     final res = await UserService.signIn(
//         _emailController.text, _passwordController.text);
//     res.when(success: (User user) async {
//       // final countyProvider =
//       //     Provider.of<CountyProvider>(context, listen: false);
//       // await countyProvider.getAllCounties();
//       Provider.of<UserProvider>(context, listen: false).setUser(user);
//       Navigator.pop(context);
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const BottomNavBar()),
//           (route) => false);
//     }, failure: (NetworkExceptions error) {
//       Navigator.pop(context);
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const AuthMainPage()),
//           (route) => false);
//     }, responseError: (ResponseError responseError) {
//       Navigator.pop(context);
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const AuthMainPage()),
//           (route) => false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           stops: [0, .8],
//           colors: [AppColors.secondaryColor, AppColors.primaryColor],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: 428.w,
//             ),
//             PageStepper(
//                 length: widget.selectedAnswers.length + 2,
//                 currentStep: widget.selectedAnswers.length + 1),
//             Expanded(
//                 child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const LogoImage(),
//                   SizedBox(
//                     height: _currentStep == 0 ? 40.h : 150.h,
//                   ),
//                   SizedBox(
//                     // color: Colors.red,
//                     height: 600.h,
//                     width: 310.w,
//                     child: PageView(
//                       controller: _pageController,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         StepTwo(
//                             firstNameController: _firstNameController,
//                             lastNameController: _lastNameController,
//                             emailController: _emailController,
//                             phoneController: _phoneController,
//                             sendMeUpdates: _sendMeUpdates,
//                             onTap: _sendMeUpdatesFunc,
//                             passwordController: _passwordController,
//                             confirmPasswordController:
//                                 _confirmPasswordController),
//                         _buildStepThree(),
//                       ],
//                     ),
//                   ),
//                   if (_currentStep == 0)
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 9.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _buildBackwardButton(),
//                           _buildForwardButton(() {
//                             _doSignUp();
//                           }),
//                         ],
//                       ),
//                     ),
//                   SizedBox(
//                     height: 36.h,
//                   )
//                 ],
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   GestureDetector _buildBackwardButton() {
//     return GestureDetector(
//       onTap: () {
//         if (_currentStep > 0) {
//           setState(() {
//             _currentStep--;
//             _onPageChange();
//           });
//         } else {
//           Navigator.pop(context);
//         }
//       },
//       child: Container(
//         alignment: Alignment.center,
//         height: 50.h,
//         width: 130.w,
//         decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.white,
//               style: BorderStyle.solid,
//               width: 2.5.w,
//             ),
//             color: Colors.transparent,
//             borderRadius: BorderRadius.circular(5.w)),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.arrow_back_rounded,
//               color: Colors.white,
//               size: 24.w,
//             ),
//             SizedBox(
//               width: 10.w,
//             ),
//             Text(
//               "Back",
//               style: TextStyle(
//                   fontSize: 16.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   GestureDetector _buildForwardButton(VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         height: 50.h,
//         width: 130.w,
//         decoration: BoxDecoration(
//             color: AppColors.btnColor,
//             borderRadius: BorderRadius.circular(5.w)),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Next",
//               // _currentStep == 1 ? "Submit" : "Forward",
//               style: TextStyle(
//                   fontSize: 16.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               width: 10.w,
//             ),
//             Icon(
//               // _currentStep == 1 ? Icons.check :
//               Icons.arrow_forward_rounded,
//               color: Colors.white,
//               size: 24.w,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   _buildStepThree() {
//     return Column(
//       children: [
//         SvgPicture.asset("assets/icons/check-circle.svg",
//             height: 75.w, width: 75.w, color: Colors.white),
//         SizedBox(
//           height: 40.h,
//         ),
//         SizedBox(
//           width: 310.w,
//           child: Text(
//             "Welcome to the Wisconsin Rut Report!",
//             style: TextStyle(
//                 fontSize: 24.sp,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 height: 1.5),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         SizedBox(
//           height: 50.h,
//         ),
//         GestureDetector(
//           onTap: () => _letsGo(),
//           child: Container(
//             alignment: Alignment.center,
//             height: 50.h,
//             width: 190.w,
//             decoration: BoxDecoration(
//                 color: AppColors.btnColor,
//                 borderRadius: BorderRadius.circular(5.w)),
//             child: Text(
//               "Let's go!",
//               style: TextStyle(
//                   fontSize: 18.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // class CustomStepper extends StatelessWidget {
// //   const CustomStepper({
// //     Key? key,
// //     required int currentStep,
// //   })  : _currentStep = currentStep,
// //         super(key: key);

// //   final int _currentStep;

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: 145.h,
// //       width: 300.w,
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Container(
// //             height: 20.w,
// //             width: 20.w,
// //             decoration: BoxDecoration(
// //                 color: AppColors.btnColor,
// //                 borderRadius: BorderRadius.circular(10.w)),
// //           ),
// //           Container(
// //             color: AppColors.btnColor,
// //             height: 2.h,
// //             width: 75.w,
// //           ),
// //           Container(
// //             height: 20.w,
// //             width: 20.w,
// //             decoration: BoxDecoration(
// //                 color: _currentStep == 0 ? Colors.white : AppColors.btnColor,
// //                 borderRadius: BorderRadius.circular(10.w)),
// //           ),
// //           Container(
// //             color: _currentStep == 2 ? AppColors.btnColor : Colors.white,
// //             height: 2.h,
// //             width: 75.w,
// //           ),
// //           Container(
// //             height: 20.w,
// //             width: 20.w,
// //             decoration: BoxDecoration(
// //                 color: _currentStep == 2 ? AppColors.btnColor : Colors.white,
// //                 borderRadius: BorderRadius.circular(10.w)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// class StepTwo extends StatefulWidget {
//   const StepTwo(
//       {Key? key,
//       required TextEditingController firstNameController,
//       required TextEditingController lastNameController,
//       required TextEditingController emailController,
//       required TextEditingController phoneController,
//       required TextEditingController passwordController,
//       required TextEditingController confirmPasswordController,
//       required bool sendMeUpdates,
//       required VoidCallback onTap})
//       : _firstNameController = firstNameController,
//         _lastNameController = lastNameController,
//         _emailController = emailController,
//         _phoneController = phoneController,
//         _passwordController = passwordController,
//         _confirmPasswordController = confirmPasswordController,
//         _sendMeUpdates = sendMeUpdates,
//         _onTap = onTap,
//         super(key: key);

//   final TextEditingController _firstNameController;
//   final TextEditingController _lastNameController;
//   final TextEditingController _emailController;
//   final TextEditingController _phoneController;
//   final TextEditingController _passwordController;
//   final TextEditingController _confirmPasswordController;
//   final bool _sendMeUpdates;
//   final VoidCallback _onTap;

//   @override
//   State<StepTwo> createState() => _StepTwoState();
// }

// class _StepTwoState extends State<StepTwo> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           "Create Account",
//           style: TextStyle(
//               fontSize: 24.sp,
//               color: Colors.white,
//               fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(
//           height: 25.h,
//         ),
//         InputField(
//           hintText: "First Name",
//           prefixIconPath: "assets/icons/user.svg",
//           controller: widget._firstNameController,
//           textInputType: TextInputType.text,
//         ),
//         SizedBox(
//           height: 20.h,
//         ),
//         InputField(
//           hintText: "Last Name",
//           prefixIconPath: "assets/icons/user.svg",
//           controller: widget._lastNameController,
//           textInputType: TextInputType.text,
//         ),
//         SizedBox(
//           height: 20.h,
//         ),
//         InputField(
//           hintText: "Email",
//           prefixIconPath: "assets/icons/mail.svg",
//           controller: widget._emailController,
//           textInputType: TextInputType.emailAddress,
//         ),
//         SizedBox(
//           height: 20.h,
//         ),
//         InputField(
//           hintText: "Phone Number",
//           prefixIconPath: "assets/icons/phone.svg",
//           controller: widget._phoneController,
//           textInputType: TextInputType.number,
//         ),
//         SizedBox(
//           height: 20.h,
//         ),
//         InputField(
//             hintText: "Password",
//             prefixIconPath: "assets/icons/lock.svg",
//             controller: widget._passwordController,
//             textInputType: TextInputType.visiblePassword,
//             obscureText: true),
//         SizedBox(
//           height: 20.h,
//         ),
//         InputField(
//             hintText: "Confirm Password",
//             prefixIconPath: "assets/icons/lock.svg",
//             controller: widget._confirmPasswordController,
//             textInputType: TextInputType.visiblePassword,
//             obscureText: true),
//         SizedBox(
//           height: 20.h,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: widget._onTap,
//               child: SizedBox(
//                   height: 25.w,
//                   width: 25.w,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppColors.btnColor,
//                           style: BorderStyle.solid,
//                           width: 2.5.w,
//                         ),
//                         color: Colors.transparent,
//                         borderRadius: BorderRadius.circular(5.w)),
//                     child: widget._sendMeUpdates
//                         ? Icon(
//                             Icons.check,
//                             color: AppColors.btnColor,
//                             size: 20.w,
//                           )
//                         : null,
//                   )),
//             ),
//             SizedBox(
//               width: 15.w,
//             ),
//             Text(
//               "Send me updates and alerts",
//               style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w400),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // class StepOne extends StatelessWidget {
// //   const StepOne({
// //     Key? key,
// //     required TextEditingController firstNameController,
// //     required TextEditingController lastNameController,
// //     required TextEditingController emailController,
// //   })  : _firstNameController = firstNameController,
// //         _lastNameController = lastNameController,
// //         _emailController = emailController,
// //         super(key: key);

// //   final TextEditingController _firstNameController;
// //   final TextEditingController _lastNameController;
// //   final TextEditingController _emailController;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Text(
// //           "Create Account",
// //           style: TextStyle(
// //               fontSize: 24.sp,
// //               color: Colors.white,
// //               fontWeight: FontWeight.bold),
// //           textAlign: TextAlign.center,
// //         ),
// //         SizedBox(
// //           height: 45.h,
// //         ),
// //         InputField(
// //           hintText: "First Name",
// //           prefixIconPath: "assets/icons/user.svg",
// //           controller: _firstNameController,
// //           textInputType: TextInputType.text,
// //         ),
// //         SizedBox(
// //           height: 20.h,
// //         ),
// //         InputField(
// //           hintText: "Last Name",
// //           prefixIconPath: "assets/icons/user.svg",
// //           controller: _lastNameController,
// //           textInputType: TextInputType.text,
// //         ),
// //         SizedBox(
// //           height: 20.h,
// //         ),
// //         InputField(
// //           hintText: "Email",
// //           prefixIconPath: "assets/icons/mail.svg",
// //           controller: _emailController,
// //           textInputType: TextInputType.emailAddress,
// //         ),
// //       ],
// //     );
// //   }
// // }
