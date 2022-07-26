import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/question.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/register_provider.dart';
import 'package:wisconsin_app/services/questionnaire_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/services/verfication_service.dart';
import 'package:wisconsin_app/ui/landing/register_page/widgets/collect_details_page.dart';
import 'package:wisconsin_app/ui/landing/register_page/widgets/county_select_page.dart';
import 'package:wisconsin_app/ui/landing/register_page/widgets/page_stepper.dart';
import 'package:wisconsin_app/ui/landing/register_page/widgets/question_page.dart';
import 'package:wisconsin_app/ui/landing/verification_page/verification_page.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = true;
  int _currentStep = 0;
  List<Question>? _questions;
  late PageController _pageController;
  List<Widget> items = [];

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  // bool _sendMeUpdates = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _init();
    super.initState();
  }

  _init() async {
    Provider.of<RegisterProvider>(context, listen: false).clearData();
    final countyProvider = Provider.of<CountyProvider>(context, listen: false);
    // await countyProvider.getAllCounties();
    if (countyProvider.counties.isNotEmpty) {
      _questions = await QuestionnaireService.getQuestionnarie();
      if (_questions?.isNotEmpty ?? false) {
        items = [const CountySelectPage()];
        for (Question question in _questions!) {
          items.add(QuestionPage(question: question));
        }
        items.add(CollectDetailsPage(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          // sendMeUpdates: _sendMeUpdates,
          // onTap: _sendMeUpdatesFunc,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  // _sendMeUpdatesFunc() {
  //   setState(() {
  //     _sendMeUpdates = !_sendMeUpdates;
  //   });
  // }

  _onPageChange() {
    _pageController.jumpToPage(_currentStep);
  }

  _goBack() {
    Provider.of<RegisterProvider>(context, listen: false).clearData();
    Navigator.pop(context);
  }

  _validateCountyPage() {
    if (Provider.of<RegisterProvider>(context, listen: false).selectedCounty ==
        null) {
      return false;
    }
    return true;
  }

  _validateQuestionPage() {
    return Provider.of<RegisterProvider>(context, listen: false)
        .selectedAnswers
        .asMap()
        .containsKey(_currentStep - 1);
  }

  _validateRegister() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "First name is required",
          type: SnackBarType.error));
      return false;
    }
    if (_lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Last name is required",
          type: SnackBarType.error));
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Email is required",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Email is invalid",
          type: SnackBarType.error));
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Phone number is required",
          type: SnackBarType.error));
      return false;
    }
    // if (!RegExp(r"^[0-9]{3}-[0-9]{3}-[0-9]{4}$")
    //     .hasMatch(_phoneController.text.trim())) {
    if (_phoneController.text.trim().length != 12) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Phone number is invalid",
          type: SnackBarType.error));
      return false;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is required",
          type: SnackBarType.error));
      return false;
    }
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,40}$")
        .hasMatch(_passwordController.text)) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password is incorrect",
          type: SnackBarType.error));
      return false;
    }
    if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Confirm Password is required",
          type: SnackBarType.error));
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Password don't match",
          type: SnackBarType.error));
      return false;
    }
    if (!Provider.of<RegisterProvider>(context, listen: false)
        .acceptTermsCondition) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Accept terms and conditions",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doSignUp() async {
    if (_validateRegister()) {
      PageLoader.showLoader(context);
      Map<String, dynamic> person = {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "emailAddress": _emailController.text.trim(),
        "username": _emailController.text.trim(),
        "password": _passwordController.text,
        "country": "US",
        "countyId": Provider.of<RegisterProvider>(context, listen: false)
            .selectedCounty!
            .id,
        "regionId": Provider.of<RegisterProvider>(context, listen: false)
            .selectedCounty!
            .regionId,
        "isOptIn":
            Provider.of<RegisterProvider>(context, listen: false).sendMeUpdates
      };
      final res = await UserService.signUp(person);

      res.when(success: (String userId) async {
        Provider.of<RegisterProvider>(context, listen: false)
            .updateAnswers(userId);
        await QuestionnaireService.saveQuestionnaire(
            Provider.of<RegisterProvider>(context, listen: false)
                .selectedAnswers);

        // _userId = userId;
        await VerficationService.sendCode(userId, _phoneController.text.trim());
        Provider.of<RegisterProvider>(context, listen: false).clearData();
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => VerificationPage(
                      userId: userId,
                      phoneNumber: _phoneController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    )),
            (route) => false);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => VerificationPage(
        //               userId: userId,
        //               phoneNumber: _phoneController.text,
        //             )));
      }, failure: (NetworkExceptions error) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: NetworkExceptions.getErrorMessage(error),
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: responseError.error,
            type: SnackBarType.error));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        // resizeToAvoidBottomInset: false,
        body: _isLoading
            ? Center(
                child: SizedBox(
                  height: 50.w,
                  width: 50.w,
                  child: const LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [AppColors.btnColor],
                      strokeWidth: 2.0),
                ),
              )
            : SafeArea(
                child: Consumer<RegisterProvider>(builder: (context, pro, _) {
                  return Column(
                    children: [
                      PageStepper(
                          length: items.length, currentStep: _currentStep),
                      Expanded(
                        child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            itemCount: items.length,
                            itemBuilder: (_, index) {
                              return items[index];
                            }),
                      ),
                      _buildBtnRow()
                    ],
                  );
                }),
              ));
  }

  _buildBtnRow() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBackButton(() {
            if (_currentStep == 0) {
              _goBack();
            } else {
              setState(() {
                _currentStep -= 1;
                _onPageChange();
              });
            }
          }),
          _buildNextButton(() {
            if (_currentStep == items.length - 1) {
              _doSignUp();
            } else {
              setState(() {
                _currentStep += 1;
                _onPageChange();
              });
            }
          },
              (_currentStep == 0
                  ? _validateCountyPage()
                  : _currentStep == items.length - 1
                      ? true
                      : _validateQuestionPage()))
        ],
      ),
    );
  }

  _buildNextButton(VoidCallback onTap, bool isValid) {
    return GestureDetector(
      onTap: isValid ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
            color: isValid ? AppColors.btnColor : Colors.grey[600],
            borderRadius: BorderRadius.circular(5.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                "Next",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24.w,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBackButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 2.5.w,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                "Back",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
