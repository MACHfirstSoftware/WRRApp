import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/services/weather_service.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/widgets/dashboard_appbar.dart';

class DashBorad extends StatefulWidget {
  const DashBorad({Key? key}) : super(key: key);

  @override
  State<DashBorad> createState() => _DashBoradState();
}

class _DashBoradState extends State<DashBorad> {
  @override
  void initState() {
    // _getWeatherDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const DashboardAppBar(),
        elevation: 0,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 220.h,
            width: 428.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.fitWidth)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    WRRProgress(
                      title: "Daily WRR",
                      precentage: .15,
                    ),
                    WRRProgress(
                      title: "Hourly WRR",
                      precentage: .15,
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    WRRReport(),
                    WRRReport(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getWeatherDetails() async {
    await WeatherService.getWeatherDetails();
  }
}

class WRRReport extends StatelessWidget {
  const WRRReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 145.h,
      width: 180.w,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.5.h),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.25.w),
          borderRadius: BorderRadius.circular(10.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tommorow (May 20)",
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/cloud.svg",
                height: 13.h,
                width: 20.w,
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                "66°  |  82°",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Average high 69.4°",
            style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 5.w,
              ),
              SvgPicture.asset(
                "assets/icons/dayLight.svg",
                height: 11.h,
                width: 11.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Text(
                  "4:03 pm",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
              Text(
                "5:03 pm",
                style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 5.w,
              ),
              SvgPicture.asset(
                "assets/icons/moon.svg",
                height: 11.h,
                width: 11.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Text(
                  "10:03 pm",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
              Text(
                "6:03 pm",
                style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(
                //   width: 3.w,
                // ),
                SvgPicture.asset(
                  "assets/icons/compass.svg",
                  height: 11.h,
                  width: 11.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "32.56\"",
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "SSW 18",
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "22%  0.47",
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            children: [
              Text(
                "AM:",
                style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                alignment: Alignment.center,
                height: 10.h,
                width: 20.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5.w),
                    color: const Color(0xFFF23A02)),
                child: Text(
                  "Bad",
                  style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Text(
                "PM:",
                style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                alignment: Alignment.center,
                height: 10.h,
                width: 20.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5.w),
                    color: const Color(0xFFF23A02)),
                child: Text(
                  "Bad",
                  style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WRRProgress extends StatelessWidget {
  final String title;
  final double precentage;
  const WRRProgress({
    Key? key,
    required this.title,
    required this.precentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 32.h,
          width: 180.w,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.25.w),
              borderRadius: BorderRadius.circular(7.5.w)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.5.w),
            child: LinearProgressIndicator(
              value: precentage,
              backgroundColor: Colors.transparent,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFF23A02)),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
