import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({Key? key}) : super(key: key);

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      body: SingleChildScrollView(
          child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
            width: 428.w,
          ),
          Row(
            children: [
              const Spacer(),
              Container(
                height: 50.w,
                width: 50.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: const Color(0xFFF23A02),
                    borderRadius: BorderRadius.circular(10.w)),
                child: SvgPicture.asset(
                  "assets/icons/cloud.svg",
                  height: 30.w,
                  width: 40.w,
                ),
              ),
              const Spacer(),
              Text(
                "82° f",
                style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                "Average high 69.4°",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 30.h,
            width: 428.w,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              horizontal: 100.w,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: const Color(0xFFF23A02)),
            child: Text(
              "Clear",
              style: TextStyle(
                  fontSize: 25.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30.h,
            width: 428.w,
          ),
          Row(
            children: [
              const Spacer(),
              Container(
                height: 40.w,
                width: 40.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.w)),
                child: SvgPicture.asset(
                  "assets/icons/dayLight.svg",
                  height: 15.w,
                  width: 15.w,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                "4:03 pm",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                "5:03 pm",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              const Spacer(),
              Container(
                height: 40.w,
                width: 40.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.w)),
                child: SvgPicture.asset(
                  "assets/icons/moon.svg",
                  height: 15.w,
                  width: 15.w,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                "10:03 pm",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                "6:03 pm",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            children: [
              const Spacer(),
              Container(
                height: 40.w,
                width: 40.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.w)),
                child: SvgPicture.asset(
                  "assets/icons/compass.svg",
                  height: 15.w,
                  width: 15.w,
                ),
              ),
              const Spacer(),
              Text(
                "32.56\"",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                "SSW 18",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                "22%  0.47",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
            ],
          ),
        ],
      )),
    );
  }
}
