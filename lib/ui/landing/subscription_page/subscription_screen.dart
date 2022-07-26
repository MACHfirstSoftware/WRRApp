import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/subscription.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // int _selectedIndex = 0;
  int radioValue = 2;
  late bool isLoading;
  late bool showTryAgain;
  late String errorMessage;
  List<Subscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    setState(() {
      isLoading = true;
      showTryAgain = false;
      errorMessage = '';
    });
    final res = await SubscriptionService.getSubscriptions();
    res.when(success: (List<Subscription> data) {
      subscriptions = data;
      setState(() {
        isLoading = false;
        showTryAgain = false;
        errorMessage = '';
      });
    }, failure: (NetworkExceptions error) {
      setState(() {
        isLoading = false;
        showTryAgain = true;
        errorMessage = NetworkExceptions.getErrorMessage(error);
      });
    }, responseError: (ResponseError responseError) {
      setState(() {
        isLoading = false;
        showTryAgain = true;
        errorMessage = responseError.error;
      });
    });
  }

  // callbackFunction(int value, dynamic reason) {
  //   setState(() {
  //     _selectedIndex = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.w)),
        child: Container(
          width: 400.w,
          height: 450.h,
          padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 50.h),
          decoration: BoxDecoration(
              color: AppColors.popBGColor,
              borderRadius: BorderRadius.circular(20.w)),
          child: isLoading
              ? ViewModels.buildLoader()
              : showTryAgain
                  ? ViewModels.buildErrorWidget(errorMessage, _init)
                  : _buildView(),
        ),
      ),
    );
  }

  _buildView() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 360.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              "Choose your plan".toUpperCase(),
              style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.btnColor,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 200.w,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey[300],
            ),
            child: RadioListTile(
              value: 2,
              groupValue: radioValue,
              onChanged: (int? ind) => setState(() {
                radioValue = ind!;
              }),
              title: Text(
                "Premium",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                "\$29.99",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              activeColor: AppColors.btnColor,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
          width: 330.w,
        ),
        SizedBox(
          width: 200.w,
          child: Theme(
            data: ThemeData(
              //here change to your color
              unselectedWidgetColor: Colors.grey[300],
            ),
            child: RadioListTile(
              value: 0,
              groupValue: radioValue,
              onChanged: (int? ind) => setState(() {
                radioValue = ind!;
              }),
              title: Text(
                "Free",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                "\$00.00",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              activeColor: AppColors.btnColor,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // print(subscriptions[_selectedIndex].isPremium);
            Navigator.pop(context, subscriptions[radioValue].id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 40.h,
            width: 130.w,
            decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w)),
            child: SizedBox(
              height: 25.h,
              width: 100.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
