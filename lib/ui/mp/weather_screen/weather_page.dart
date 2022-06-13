import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/weather_appbar.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/current_weather_details.dart';

class WeatherPage extends StatefulWidget {
  final County county;
  const WeatherPage({Key? key, required this.county}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    // county = weatherProvider.county;
    weatherProvider.getWeatherDetails();
  }

  @override
  void didUpdateWidget(WeatherPage oldWidget) {
    print('didUpdateWidget');
    if (oldWidget.county != widget.county) {
      setState(() {
        keepAlive = false;
      });
      updateKeepAlive();
    } else {
      setState(() {
        keepAlive = true;
      });
      updateKeepAlive();
    }

    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void didUpdateWidget(covariant WeatherPage oldWidget) {
  //   if (county != Provider.of<WeatherProvider>(context, listen: false).county) {
  //     print("calllllll");
  //   setState(() {
  //     keepAlive = false;
  //   });
  //   updateKeepAlive();
  // } else {
  //   setState(() {
  //     keepAlive = true;
  //   });
  //   updateKeepAlive();
  // }

  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  bool get wantKeepAlive => keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const WeatherAppBar(),
          bottom: const TabBar(tabs: [
            Tab(
              text: "Current",
            ),
            Tab(
              text: "Forecast",
            ),
            Tab(
              text: "History",
            ),
          ]),
        ),
        body: Consumer<WeatherProvider>(builder: (context, weatherProvider, _) {
          if (weatherProvider.apiStatus == ApiStatus.isBusy) {
            return _buildLoader();
          }
          if (weatherProvider.apiStatus == ApiStatus.isError) {
            _buildErrorWidget(weatherProvider.errorMessage);
          }
          return TabBarView(
            children: [
              CurrentWeatherDetails(
                  currentWeather: weatherProvider.currentWeather),
              const SizedBox(),
              const SizedBox()
              // WeatherDetails(),
              // WeatherDetails(),
            ],
          );
        }),
      ),
    );
  }

  Center _buildLoader() {
    return Center(
      child: SizedBox(
        height: 50.w,
        width: 50.w,
        child: const LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [AppColors.btnColor],
            strokeWidth: 2.0),
      ),
    );
  }

  _buildErrorWidget(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          errorMessage,
          style: TextStyle(
              fontSize: 25.sp,
              color: AppColors.btnColor,
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
                color: AppColors.btnColor,
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
}
