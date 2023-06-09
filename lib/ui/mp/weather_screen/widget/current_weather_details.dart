import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/weather.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/weather_color_theme.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/houry_card.dart';

class CurrentWeatherDetails extends StatefulWidget {
  final Current currentWeather;
  final Forecastday forecastDay;
  final Astro astro;
  const CurrentWeatherDetails({
    Key? key,
    required this.currentWeather,
    required this.astro,
    required this.forecastDay,
  }) : super(key: key);

  @override
  State<CurrentWeatherDetails> createState() => _CurrentWeatherDetailsState();
}

class _CurrentWeatherDetailsState extends State<CurrentWeatherDetails> {
  int currentHour = 0;
  int low = 0;
  int high = 0;
  List<Hour> forcastDayHours = [];
  bool isExpanded = true;

  @override
  void initState() {
    currentHour = int.parse(DateFormat.H().format(DateTime.now()));
    List<double> tempF = [];
    for (final data in widget.forecastDay.hour) {
      tempF.add(data.tempF);
      if (DateFormat("yyyy-MM-dd HH:mm")
          .parse(data.time)
          .isAfter(DateTime.now())) {
        forcastDayHours.add(data);
      }
    }
    high = tempF.indexOf(tempF.reduce(max));
    low = tempF.indexOf(tempF.reduce(min));
    super.initState();
  }

  List<Map<String, String>> moreDetails = [];
  @override
  Widget build(BuildContext context) {
    // moreDetails = [
    //   // {
    //   //   "key": "Current Conditions",
    //   //   "value": widget.forecastDay.hour[currentHour].condition.text
    //   // },
    //   {
    //     "key": "Wind",
    //     "value":
    //         "${widget.currentWeather.windDir} at ${widget.currentWeather.windMph} mph Gusting to ${widget.currentWeather.gustMph} mph"
    //   },
    //   {
    //     "key": "Precip",
    //     "value": widget.currentWeather.precipIn.toString() + " in."
    //   },
    //   {
    //     "key": "Humidy",
    //     "value": widget.currentWeather.humidity.toString() + "%"
    //   },
    //   {
    //     "key": "Pressure",
    //     "value": widget.currentWeather.pressureIn.toString() + " in."
    //   },
    //   // {
    //   //   "key": "Moon Phase",
    //   //   "value": widget.astro.moonPhase + " (${widget.astro.moonIllumination})"
    //   // },
    //   {
    //     "key": "Cloud Cover",
    //     "value": widget.currentWeather.cloud.toString() + " %"
    //   },
    //   {
    //     "key": "Visability",
    //     "value": widget.currentWeather.visMiles.toString() + " miles"
    //   },
    //   {"key": "UV Index", "value": widget.currentWeather.uv.toString()},
    // ];
    WeatherColorTheme.setWeatherTheme(
        widget.currentWeather.condition.text.toLowerCase());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10.h,
              width: 428.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  color: WeatherColorTheme.bgColor,
                  borderRadius: BorderRadius.circular(10.h)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.forecastDay.hour[currentHour].tempF.toString()}° f",
                      style: TextStyle(
                          fontSize: 40.sp,
                          color: WeatherColorTheme.ftColor,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.forecastDay.hour[high].tempF.toString()}° f",
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  color: WeatherColorTheme.ftColor,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "High",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: WeatherColorTheme.ftColor,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.forecastDay.hour[low].tempF.toString()}° f",
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  color: WeatherColorTheme.ftColor,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Low",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: WeatherColorTheme.ftColor,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "Feels like ${widget.forecastDay.hour[currentHour].feelslikeF}° f",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: WeatherColorTheme.ftColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                        width: 408.w,
                        height: 40.h,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 40.h,
                                width: 40.h,
                                padding: EdgeInsets.all(5.h),
                                decoration: BoxDecoration(
                                    color: AppColors.popBGColor,
                                    borderRadius: BorderRadius.circular(10.h)),
                                child: Image.network(
                                  "https:${widget.currentWeather.condition.icon}",
                                  height: 37.5.h,
                                  width: 37.5.h,
                                  fit: BoxFit.fill,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                // "Cloudy",
                                widget.currentWeather.condition.text,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: WeatherColorTheme.ftColor,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ))
                  ]),
            ),
            SizedBox(
              height: 20.h,
            ),
            _buildAstroRow("assets/icons/dayLight.svg", widget.astro.sunrise,
                widget.astro.sunset),
            SizedBox(
              height: 15.h,
            ),
            _buildAstroRow("assets/icons/moon.svg", widget.astro.moonrise,
                widget.astro.moonset),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(right: 25.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.astro.moonPhase +
                      " (${widget.astro.moonIllumination})",
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            // Container(
            //   height: 40.h,
            //   decoration: BoxDecoration(
            //       color: AppColors.btnColor,
            //       borderRadius: BorderRadius.circular(5.h)),
            //   padding: EdgeInsets.symmetric(horizontal: 10.w),
            //   margin: EdgeInsets.symmetric(horizontal: 10.w),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Current Conditions",
            //         style: TextStyle(
            //             fontSize: 16.sp,
            //             color: Colors.white,
            //             fontWeight: FontWeight.w600),
            //         textAlign: TextAlign.left,
            //       ),
            //       SizedBox(
            //         width: 10.w,
            //       ),
            //       Expanded(
            //         child: FittedBox(
            //           fit: BoxFit.scaleDown,
            //           alignment: Alignment.centerRight,
            //           child: Text(
            //             widget.forecastDay.hour[currentHour].condition.text,
            //             style: TextStyle(
            //                 fontSize: 16.sp,
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.w600),
            //             textAlign: TextAlign.left,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 10.h,
            // ),
            Theme(
                data: ThemeData(
                    unselectedWidgetColor: Colors.white,
                    indicatorColor: Colors.white),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                      // color: AppColors.btnColor,
                      color: const Color(0xFF36454F),
                      borderRadius: BorderRadius.circular(5.h)),
                  child: ExpansionTile(
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                      trailing: Icon(
                        isExpanded
                            ? Icons.arrow_circle_up_rounded
                            : Icons.arrow_circle_down_rounded,
                        size: 25.h,
                        color: Colors.white,
                      ),
                      initiallyExpanded: true,
                      onExpansionChanged: (value) {
                        setState(() {
                          isExpanded = value;
                        });
                      },
                      title: Text(
                        "Hourly Forecast",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      children: [
                        ...forcastDayHours
                            .map((data) => HourlyCard(hour: data)),
                        SizedBox(height: 2.5.h)
                      ]),
                )),
            // Card(
            //   margin: EdgeInsets.all(10.w),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15.w)),
            //   color: AppColors.popBGColor.withOpacity(.75),
            //   child: Center(
            //     child: Padding(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            //       child: ListView.separated(
            //           padding: EdgeInsets.zero,
            //           shrinkWrap: true,
            //           physics: const BouncingScrollPhysics(),
            //           itemBuilder: (_, index) {
            //             return _buildDataRow(moreDetails[index]["key"]!,
            //                 moreDetails[index]["value"]!);
            //           },
            //           separatorBuilder: (_, index) {
            //             return Divider(
            //               color: Colors.white10,
            //               thickness: 1.25.h,
            //             );
            //           },
            //           itemCount: moreDetails.length),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }

  _buildAstroRow(String iconPath, String rise, String set) {
    return Padding(
      padding: EdgeInsets.only(right: 25.w, left: 0.w),
      child: Row(
        children: [
          // const Spacer(),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 40.h,
                width: 40.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                    color: AppColors.popBGColor,
                    borderRadius: BorderRadius.circular(10.h)),
                child: SvgPicture.asset(
                  iconPath,
                  height: 15.h,
                  width: 15.h,
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
              textAlign: TextAlign.right,
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }

  // _buildDataRow(String title, String value) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 7.5.w),
  //     child: Row(
  //       children: [
  //         SizedBox(
  //           width: 135.w,
  //           child: Text(
  //             title,
  //             style: TextStyle(
  //                 fontSize: 15.sp,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w700),
  //             textAlign: TextAlign.left,
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: TextStyle(
  //                 fontSize: 14.sp,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600),
  //             textAlign: TextAlign.left,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
