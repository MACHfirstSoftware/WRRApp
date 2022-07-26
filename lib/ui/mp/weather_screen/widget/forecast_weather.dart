import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/models/weather.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/forecast_body.dart';

class ForecastWeather extends StatefulWidget {
  final List<Forecastday> forecastDays;
  const ForecastWeather({Key? key, required this.forecastDays})
      : super(key: key);

  @override
  State<ForecastWeather> createState() => _ForecastWeatherState();
}

class _ForecastWeatherState extends State<ForecastWeather> {
  late PageController _pageController;
  int _index = 0;
  bool isShow = false;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _showButtons() {
    setState(() {
      isShow = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        isShow = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: widget.forecastDays.length,
        onPageChanged: (int index) {
          Provider.of<WeatherProvider>(context, listen: false)
              .onPagechange(index);
          _index = index;
        },
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: _showButtons,
            child: Stack(
              children: [
                ForecastBody(forecastDay: widget.forecastDays[index]),
                if (isShow && _index > 0)
                  Positioned(
                    left: 0,
                    top: 70.h,
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(_index - 1);
                      },
                      child: Container(
                        height: 50.h,
                        width: 50.w,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 30.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (isShow && _index < widget.forecastDays.length - 1)
                  Positioned(
                    right: 0,
                    top: 70.h,
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(_index + 1);
                      },
                      child: Container(
                        height: 50.h,
                        width: 50.w,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
