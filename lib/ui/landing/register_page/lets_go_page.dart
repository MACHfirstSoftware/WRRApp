import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/ui/landing/subscription_page/subscription_screen.dart';
import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class LetsGoPage extends StatefulWidget {
  final String userId;
  final String email;
  final String password;
  const LetsGoPage(
      {Key? key,
      required this.userId,
      required this.email,
      required this.password})
      : super(key: key);

  @override
  State<LetsGoPage> createState() => _LetsGoPageState();
}

class _LetsGoPageState extends State<LetsGoPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _subscription();
    });

    super.initState();
  }

  _subscription() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    int sId = await Navigator.of(context).push(
      HeroDialogRoute(builder: (context) => const SubscriptionScreen()),
    );
    PageLoader.showLoader(context);
    final subscriptionResponse =
        await SubscriptionService.addSubscription(widget.userId, sId);
    Navigator.pop(context);
    subscriptionResponse.when(success: (bool success) async {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully subscribed!",
          type: SnackBarType.success));
    }, failure: (NetworkExceptions error) async {
      PageLoader.showTransparentLoader(context);
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: NetworkExceptions.getErrorMessage(error),
          type: SnackBarType.error));
      await Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      _subscription();
    }, responseError: (ResponseError responseError) async {
      PageLoader.showTransparentLoader(context);
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: responseError.error,
          type: SnackBarType.error));
      await Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      _subscription();
    });
  }

  _letsGo() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    PageLoader.showLoader(context);
    final res = await UserService.signIn(widget.email, widget.password);
    res.when(success: (User user) async {
      // final countyProvider =
      //     Provider.of<CountyProvider>(context, listen: false);
      // await countyProvider.getAllCounties();
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false);
    }, failure: (NetworkExceptions error) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthMainPage()),
          (route) => false);
    }, responseError: (ResponseError responseError) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthMainPage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 56.h,
                width: 428.w,
              ),
              const LogoImage(),
              const Spacer(),
              SvgPicture.asset("assets/icons/check-circle.svg",
                  height: 75.w, width: 75.w, color: Colors.white),
              SizedBox(
                height: 40.h,
              ),
              SizedBox(
                width: 310.w,
                child: Text(
                  "Welcome to the Wisconsin Rut Report!",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () => _letsGo(),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(5.w)),
                  child: SizedBox(
                    height: 30.h,
                    width: 110.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        "Let's go!",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
