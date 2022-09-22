import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/landing/register_page/register_page.dart';
import 'package:wisconsin_app/ui/landing/sign_in_page/sign_in_page.dart';
import 'package:wisconsin_app/widgets/video_test.dart';

class AuthMainPage extends StatefulWidget {
  const AuthMainPage({Key? key}) : super(key: key);

  @override
  State<AuthMainPage> createState() => _AuthMainPageState();
}

class _AuthMainPageState extends State<AuthMainPage> {
  late AssetImage logoImage;
  @override
  void initState() {
    logoImage = const AssetImage(
      "assets/images/app-logo.png",
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(logoImage, context);
    super.didChangeDependencies();
  }

  _goSignIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SignInPage()));
  }

  _goRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: logoImage,
            // color: AppColors.btnColor,
            height: 175.h,
            width: 320.w,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 40.h,
            width: 428.w,
          ),
          _buildSubmitBtn(() => _goSignIn(), "Sign In"),
          SizedBox(
            height: 20.h,
            width: 428.w,
          ),
          _buildSubmitBtn(() => _goRegister(), "Register"),
          SizedBox(
            height: 20.h,
            width: 428.w,
          ),
          _buildSubmitBtn(
              () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const VideoApp())),
              "Video"),

          // SizedBox(
          //   height: 20.h,
          //   width: 428.w,
          // ),
          // _buildSubmitBtn(() => PurchasesService.login(), "Login plans"),

          //$RCAnonymousID:a1776857aca6464c8b4fb10c9abd7ef6
        ],
      ),
    );
  }

  GestureDetector _buildSubmitBtn(VoidCallback onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 150.w,
        decoration: BoxDecoration(
            color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(10.w)),
        child: SizedBox(
          height: 25.h,
          width: 100.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // _getPlans() async {
  //   PageLoader.showLoader(context);
  //   final offerings = await PurchasesService.fetchOffers();
  //   Navigator.pop(context);

  //   if (offerings.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
  //         context: context,
  //         type: SnackBarType.error,
  //         messageText: "No Plans Found"));
  //   } else {
  //     final _packages = offerings
  //         .map((offer) => offer.availablePackages)
  //         .expand((pair) => pair)
  //         .toList();
  //     _showSheet(_packages);
  //   }
  // }

  // _showSheet(List<Package> _packages) {
  //   return showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       isDismissible: false,
  //       context: context,
  //       builder: (context) => PaywalWidget(
  //             packages: _packages,
  //             onClickedPackage: (package) async {
  //               PageLoader.showLoader(context);
  //               final res = await PurchasesService.purchasePackage(package);
  //               Navigator.pop(context);
  //               Navigator.pop(context);
  //               res.when(
  //                   success: (PurchaserInfo info) {

  //                   },
  //                   failure: (NetworkExceptions err) {},
  //                   responseError: (ResponseError responseError) {
  //                     ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
  //         context: context,
  //         type: SnackBarType.error,
  //         messageText: responseError.error));
  //                   });

  //             },
  //           ));
  // }
}
