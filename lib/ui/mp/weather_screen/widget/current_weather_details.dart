import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/astro.dart';
import 'package:wisconsin_app/models/current_weather.dart';

class CurrentWeatherDetails extends StatefulWidget {
  final CurrentWeather currentWeather;
  final Astro astro;
  const CurrentWeatherDetails(
      {Key? key, required this.currentWeather, required this.astro})
      : super(key: key);

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
            "${widget.currentWeather.current.windDir} at ${widget.currentWeather.current.windMph} mph Gusting to ${widget.currentWeather.current.gustMph} mph"
      },
      {
        "key": "Precipitation",
        "value": widget.currentWeather.current.precipIn.toString() + " in."
      },
      {
        "key": "Humidy",
        "value": widget.currentWeather.current.humidity.toString() + "%"
      },
      {
        "key": "Cloud Cover",
        "value": widget.currentWeather.current.cloud.toString() + " %"
      },
      {
        "key": "Visability",
        "value": widget.currentWeather.current.visMiles.toString() + " miles"
      },
      {"key": "UV Index", "value": widget.currentWeather.current.uv.toString()},
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
                child: Image.network(
                  "https:${widget.currentWeather.current.condition.icon}",
                  height: 40.w,
                  width: 40.w,
                  fit: BoxFit.fill,
                  color: Colors.white,
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
          ),
          Text(
            // "Cloudy",
            widget.currentWeather.current.condition.text,
            style: TextStyle(
                fontSize: 22.sp,
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
          // SizedBox(
          //   height: 30.h,
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
          //         "assets/icons/compass.svg",
          //         height: 15.w,
          //         width: 15.w,
          //       ),
          //     ),
          //     const Spacer(),
          //     Text(
          //       // "12.50 mph",
          //       widget.currentWeather.current.windMph.toString(),
          //       style: TextStyle(
          //           fontSize: 14.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //     Text(
          //       // "SSW",
          //       widget.currentWeather.current.windDir,
          //       style: TextStyle(
          //           fontSize: 14.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //     Text(
          //       // "210°",
          //       widget.currentWeather.current.windDegree.toString(),
          //       style: TextStyle(
          //           fontSize: 14.sp,
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.left,
          //     ),
          //     const Spacer(),
          //   ],
          // ),
          SizedBox(
            height: 15.h,
          ),

          Flexible(
            child: Card(
              margin: EdgeInsets.all(10.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.w)),
              color: AppColors.secondaryColor.withOpacity(.5),
              child: Center(
                // child: GridView.builder(
                //     shrinkWrap: true,
                //     physics: const BouncingScrollPhysics(),
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         mainAxisExtent: 80.h,
                //         crossAxisSpacing: 0.w,
                //         mainAxisSpacing: 5.h),
                //     itemCount: moreDetails.length,
                //     itemBuilder: (_, index) {
                //       return Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             moreDetails[index]["value"].toString(),
                //             style: TextStyle(
                //                 fontSize: 14.sp,
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w600),
                //             textAlign: TextAlign.left,
                //           ),
                //           Text(
                //             moreDetails[index]["key"],
                //             style: TextStyle(
                //                 fontSize: 14.sp,
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w600),
                //             textAlign: TextAlign.left,
                //           ),
                //         ],
                //       );
                //     }),
                // child: Column(
                //   children: [
                //     ...moreDetails
                //         .map((e) => _buildDataRow(e["key"]!, e["value"]!))
                //   ],
                // ),

                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return _buildDataRow(moreDetails[index]["key"]!,
                            moreDetails[index]["value"]!);
                      },
                      separatorBuilder: (_, index) {
                        return Divider(
                          color: Colors.blueGrey,
                          thickness: 1.25.h,
                        );
                      },
                      itemCount: moreDetails.length),
                ),
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
                  color: Colors.blueGrey,
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