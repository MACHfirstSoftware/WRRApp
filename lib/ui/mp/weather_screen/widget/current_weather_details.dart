import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/current_weather.dart';

class CurrentWeatherDetails extends StatefulWidget {
  final CurrentWeather currentWeather;
  const CurrentWeatherDetails({Key? key, required this.currentWeather})
      : super(key: key);

  @override
  State<CurrentWeatherDetails> createState() => _CurrentWeatherDetailsState();
}

class _CurrentWeatherDetailsState extends State<CurrentWeatherDetails> {
  List<Map<String, dynamic>> moreDetails = [];
  @override
  Widget build(BuildContext context) {
    moreDetails = [
      // {"key": "wind_mph", "value": 12.5},
      {"key": "Wind (kph)", "value": widget.currentWeather.current.windKph},
      // {"key": "wind_degree", "value": 210},
      // {"key": "wind_dir", "value": "SSW"},
      {
        "key": "Pressure (mb)",
        "value": widget.currentWeather.current.pressureMb
      },
      {
        "key": "Pressure (in)",
        "value": widget.currentWeather.current.pressureIn
      },
      {"key": "Precip (mm)", "value": widget.currentWeather.current.precipMm},
      {"key": "Precip (in)", "value": widget.currentWeather.current.precipIn},
      {"key": "Humidity", "value": widget.currentWeather.current.humidity},
      {"key": "Cloud", "value": widget.currentWeather.current.cloud},
      // {"key": "feelslike_c", "value": 22.9},
      {"key": "Vis (km)", "value": widget.currentWeather.current.visKm},
      {"key": "Vis (miles)", "value": widget.currentWeather.current.visMiles},
      {"key": "UV", "value": widget.currentWeather.current.uv},
      {"key": "Gust (mph)", "value": widget.currentWeather.current.gustMph},
      {"key": "Gust (kph)", "value": widget.currentWeather.current.gustKph},
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40.h,
            width: 428.w,
          ),
          // RichText(
          //     text: TextSpan(
          //         text: "64° f",
          //         style: TextStyle(
          //             fontSize: 35.sp,
          //             color: Colors.white,
          //             fontWeight: FontWeight.w700),
          //         children: <TextSpan>[
          //       TextSpan(
          //         text: "  |  ",
          //         style: TextStyle(
          //             fontSize: 35.sp,
          //             color: AppColors.btnColor,
          //             fontWeight: FontWeight.w700),
          //       ),
          //       TextSpan(
          //         text: "82° f",
          //         style: TextStyle(
          //             fontSize: 35.sp,
          //             color: Colors.white,
          //             fontWeight: FontWeight.w700),
          //       )
          //     ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.w,
                width: 50.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.w)),
                child: SvgPicture.asset(
                  "assets/icons/cloud.svg",
                  height: 30.w,
                  width: 40.w,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                // "64° f",
                widget.currentWeather.current.tempF.toString(),
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
            width: 428.w,
          ),
          Text(
            "Feel like ${widget.currentWeather.current.feelslikeF}° f",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 15.h,
            width: 428.w,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     // const Spacer(),
          //     Container(
          //       height: 50.w,
          //       width: 50.w,
          //       padding: EdgeInsets.all(10.w),
          //       decoration: BoxDecoration(
          //           color: Colors.blueGrey,
          //           borderRadius: BorderRadius.circular(10.w)),
          //       child: SvgPicture.asset(
          //         "assets/icons/cloud.svg",
          //         height: 30.w,
          //         width: 40.w,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 30.w,
          //     ),
          Text(
            // "Cloudy",
            widget.currentWeather.current.condition.text,
            style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          // const Spacer(),
          // Text(
          //   "Average high 69.4°",
          //   style: TextStyle(
          //       fontSize: 16.sp,
          //       color: Colors.white,
          //       fontWeight: FontWeight.w600),
          //   textAlign: TextAlign.left,
          // ),
          // const Spacer(),
          //   ],
          // ),
          SizedBox(
            height: 30.h,
            width: 428.w,
          ),
          // Container(
          //   alignment: Alignment.center,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 100.w,
          //   ),
          //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20.w),
          //       color: AppColors.btnColor),
          //   child: Text(
          //     "Clear",
          //     style: TextStyle(
          //         fontSize: 25.sp,
          //         color: Colors.white,
          //         fontWeight: FontWeight.w600),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // Row(
          //   children: [
          //     const Spacer(),
          //     Container(
          //       height: 40.w,
          //       width: 40.w,
          //       padding: EdgeInsets.all(10.w),
          //       decoration: BoxDecoration(
          //           color: Colors.blueGrey,
          //           borderRadius: BorderRadius.circular(10.w)),
          //       child: SvgPicture.asset(
          //         "assets/icons/dayLight.svg",
          //         height: 15.w,
          //         width: 15.w,
          //         color: Colors.white,
          //       ),
          //     ),
          //     const Spacer(),
          //     Text(
          //       "4:03 pm",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //     Text(
          //       "5:03 pm",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //   ],
          // ),
          // SizedBox(
          //   height: 15.h,
          // ),
          // Row(
          //   children: [
          //     const Spacer(),
          //     Container(
          //       height: 40.w,
          //       width: 40.w,
          //       padding: EdgeInsets.all(10.w),
          //       decoration: BoxDecoration(
          //           color: Colors.blueGrey,
          //           borderRadius: BorderRadius.circular(10.w)),
          //       child: SvgPicture.asset(
          //         "assets/icons/moon.svg",
          //         height: 15.w,
          //         width: 15.w,
          //         color: Colors.white,
          //       ),
          //     ),
          //     const Spacer(),
          //     Text(
          //       "10:03 pm",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //     Text(
          //       "6:03 pm",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //   ],
          // ),
          // SizedBox(
          //   height: 30.h,
          // ),
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
                // "12.50 mph",
                widget.currentWeather.current.windMph.toString(),
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                // "SSW",
                widget.currentWeather.current.windDir,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              Text(
                // "210°",
                widget.currentWeather.current.windDegree.toString(),
                style: TextStyle(
                    fontSize: 14.sp,
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
          // const Spacer(),
          Expanded(
            child: Card(
              margin: EdgeInsets.all(10.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.w)),
              color: AppColors.secondaryColor.withOpacity(.5),
              child: Center(
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 80.h,
                        crossAxisSpacing: 0.w,
                        mainAxisSpacing: 5.h),
                    itemCount: moreDetails.length,
                    itemBuilder: (_, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            moreDetails[index]["value"].toString(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            moreDetails[index]["key"],
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}
