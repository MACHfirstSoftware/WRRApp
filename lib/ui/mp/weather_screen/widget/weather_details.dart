import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({Key? key}) : super(key: key);

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: SingleChildScrollView(
      //     child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     SizedBox(
      //       height: 20.h,
      //       width: 428.w,
      //     ),
      //     Text(
      //       "County",
      //       style: TextStyle(
      //           fontSize: 30.sp,
      //           color: Colors.black,
      //           fontWeight: FontWeight.w700),
      //       textAlign: TextAlign.center,
      //     ),
      //     SizedBox(
      //       height: 20.h,
      //     ),
      //     Text(
      //       "30° f",
      //       style: TextStyle(
      //           fontSize: 40.sp,
      //           color: Colors.black,
      //           fontWeight: FontWeight.w700),
      //       textAlign: TextAlign.center,
      //     ),
      //     SizedBox(
      //       height: 20.h,
      //     ),
      //     Container(
      //       padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      //       decoration: BoxDecoration(
      //           color: Colors.blueAccent,
      //           borderRadius: BorderRadius.circular(15.h)),
      //       child: Text(
      //         "Cloudy",
      //         style: TextStyle(
      //             fontSize: 20.sp,
      //             color: Colors.white,
      //             fontWeight: FontWeight.w500),
      //         textAlign: TextAlign.center,
      //       ),
      //     ),
      //   ],
      // )),
    );
  }
}
