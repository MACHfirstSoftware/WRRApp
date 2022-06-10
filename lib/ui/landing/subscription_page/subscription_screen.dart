import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/subscription.dart';
import 'package:wisconsin_app/services/subscription_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 0;
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

  callbackFunction(int value, dynamic reason) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.w)),
        child: Container(
          width: 400.w,
          height: 600.h,
          padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 50.h),
          decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20.w)),
          child: isLoading
              ? _buildLoader()
              : showTryAgain
                  ? _buildErrorWidget()
                  : _buildView(),
        ),
      ),
    );
  }

  _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          errorMessage,
          style: TextStyle(
              fontSize: 25.sp,
              color: const Color(0xFFF23A02),
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15.h,
        ),
        GestureDetector(
          onTap: () {
            _init();
          },
          child: Container(
            alignment: Alignment.center,
            height: 60.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF23A02),
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "Try Again",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  _buildView() {
    return Column(
      children: [
        Text(
          "Choose your plan".toUpperCase(),
          style: TextStyle(
              fontSize: 25.sp,
              color: const Color(0xFFF23A02),
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        CarouselSlider(
            items: [
              for (int i = 0; i < subscriptions.length; i++)
                _buildPlan(
                    subscriptions[i].isPremium
                        ? "assets/icons/premium.svg"
                        : "assets/icons/free-label.svg",
                    subscriptions[i].displayName,
                    i)
            ],
            options: CarouselOptions(
              height: 300.h,
              aspectRatio: 16 / 9,
              viewportFraction: 0.75,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            )),
        const Spacer(),
        GestureDetector(
          onTap: () {
            print(subscriptions[_selectedIndex].isPremium);
            Navigator.pop(context, subscriptions[_selectedIndex].id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF23A02),
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "CONTINUE",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Center _buildLoader() {
    return Center(
      child: SizedBox(
        height: 50.w,
        width: 50.w,
        child: const LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [Color(0xFFF23A02)],
            strokeWidth: 2.0),
      ),
    );
  }

  _buildPlan(String iconPath, String planName, int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
              color: _selectedIndex == index
                  ? const Color(0xFFF23A02)
                  : Colors.grey[300]!,
              width: 5.w),
          borderRadius: BorderRadius.circular(20.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            // "assets/icons/free-label.svg",
            iconPath,
            color: _selectedIndex == index
                ? const Color(0xFFF23A02)
                : Colors.grey[300],
            width: 100.w,
            height: 100.w,
          ),
          Text(
            // "FREE",
            planName,
            style: TextStyle(
                fontSize: 30.sp,
                color: _selectedIndex == index
                    ? const Color(0xFFF23A02)
                    : Colors.grey[300],
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
