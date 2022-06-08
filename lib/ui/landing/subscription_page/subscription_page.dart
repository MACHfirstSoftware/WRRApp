import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/background.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  List<String> freePlanFeatures = [
    "Contains adds",
    "No access to store",
    "No discounted codes"
  ];
  List<String> premiumPlanFeatures = [
    "No adds",
    "Ultimate access to store",
    "Discounted codes"
  ];

  int planType = 0;

  callbackFunction(int plan, dynamic reason) {
    planType = plan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Background(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
              items: [
                _buildCard("FREE", 0.00, freePlanFeatures),
                _buildCard("PREMIUM", 49.99, premiumPlanFeatures),
              ],
              options: CarouselOptions(
                height: 400.h,
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
          SizedBox(
            height: 30.h,
          ),
          GestureDetector(
            onTap: () => _continue(),
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
      )),
    );
  }

  _buildCard(String planType, double perMonth, List<String> features) {
    return Container(
      height: 300.h,
      width: 300.w,
      padding: EdgeInsets.all(5.h),
      decoration: BoxDecoration(
          color: const Color(0xFFF23A02).withOpacity(.6),
          borderRadius: BorderRadius.circular(25.w)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
            decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(20.w)),
            child: Text(
              planType,
              style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [...features.map((feature) => _buildRowFeature(feature))],
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Divider(
              color: Colors.white,
              thickness: 2.h,
            ),
          ),
          SizedBox(
            height: 60.h,
            child: Center(
              child: Text(
                "\$$perMonth per month",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildRowFeature(String feature) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
          child: Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.w)),
          ),
        ),
        Expanded(
          child: Text(
            feature,
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  _continue() {}
}
