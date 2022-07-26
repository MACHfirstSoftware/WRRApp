import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/weather.dart';

class CurrentWeatherDetails extends StatefulWidget {
  final Current currentWeather;
  final Astro astro;
  const CurrentWeatherDetails({
    Key? key,
    required this.currentWeather,
    required this.astro,
  }) : super(key: key);

  @override
  State<CurrentWeatherDetails> createState() => _CurrentWeatherDetailsState();
}

class _CurrentWeatherDetailsState extends State<CurrentWeatherDetails> {
  List<Map<String, String>> moreDetails = [];
  @override
  Widget build(BuildContext context) {
    moreDetails = [
      {
        "key": "Wind",
        "value":
            "${widget.currentWeather.windDir} at ${widget.currentWeather.windMph} mph Gusting to ${widget.currentWeather.gustMph} mph"
      },
      {
        "key": "Precip",
        "value": widget.currentWeather.precipIn.toString() + " in."
      },
      {
        "key": "Humidy",
        "value": widget.currentWeather.humidity.toString() + "%"
      },
      {
        "key": "Pressure",
        "value": widget.currentWeather.pressureIn.toString() + " in."
      },
      {
        "key": "Cloud Cover",
        "value": widget.currentWeather.cloud.toString() + " %"
      },
      {
        "key": "Visability",
        "value": widget.currentWeather.visMiles.toString() + " miles"
      },
      {"key": "UV Index", "value": widget.currentWeather.uv.toString()},
    ];
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40.h,
              width: 428.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50.w,
                  width: 50.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                      color: AppColors.popBGColor,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Image.network(
                    "https:${widget.currentWeather.condition.icon}",
                    height: 45.w,
                    width: 45.w,
                    fit: BoxFit.fill,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  // "64° f",
                  "${widget.currentWeather.tempF.toString()}° f",
                  style: TextStyle(
                      fontSize: 40.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Feel like ${widget.currentWeather.feelslikeF}° f",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              // "Cloudy",
              widget.currentWeather.condition.text,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 15.h,
            ),
            _buildAstroRow("assets/icons/dayLight.svg", widget.astro.sunrise,
                widget.astro.sunset),
            SizedBox(
              height: 15.h,
            ),
            _buildAstroRow("assets/icons/moon.svg", widget.astro.moonrise,
                widget.astro.moonset),
            SizedBox(
              height: 15.h,
            ),
            Card(
              margin: EdgeInsets.all(10.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.w)),
              color: AppColors.popBGColor.withOpacity(.75),
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return _buildDataRow(moreDetails[index]["key"]!,
                            moreDetails[index]["value"]!);
                      },
                      separatorBuilder: (_, index) {
                        return Divider(
                          color: Colors.white10,
                          thickness: 1.25.h,
                        );
                      },
                      itemCount: moreDetails.length),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }

  Row _buildAstroRow(String iconPath, String rise, String set) {
    return Row(
      children: [
        // const Spacer(),
        Expanded(
          child: Center(
            child: Container(
              height: 40.w,
              width: 40.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  color: AppColors.popBGColor,
                  borderRadius: BorderRadius.circular(10.w)),
              child: SvgPicture.asset(
                iconPath,
                height: 15.w,
                width: 15.w,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // const Spacer(),
        Expanded(
          child: Text(
            rise,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        // const Spacer(),
        Expanded(
          child: Text(
            set,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        // const Spacer(),
      ],
    );
  }

  _buildDataRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 7.5.w),
      child: Row(
        children: [
          SizedBox(
            width: 135.w,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
