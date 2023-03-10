// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wisconsin_app/models/weather.dart';
// import 'package:wisconsin_app/providers/weather_provider.dart';
// import 'package:wisconsin_app/ui/mp/weather_screen/widget/forecast_body.dart';

// class ForecastWeather extends StatefulWidget {
//   final List<Forecastday> forecastDays;
//   final int pageIndex;
//   const ForecastWeather(
//       {Key? key, required this.forecastDays, required this.pageIndex})
//       : super(key: key);

//   @override
//   State<ForecastWeather> createState() => _ForecastWeatherState();
// }

// class _ForecastWeatherState extends State<ForecastWeather> {
//   late PageController _pageController;
//   @override
//   void initState() {
//     _pageController = PageController(initialPage: widget.pageIndex);
//     // _pageController.jumpToPage(widget.pageIndex);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//         controller: _pageController,
//         itemCount: widget.forecastDays.length,
//         onPageChanged: (int index) {
//           Provider.of<WeatherProvider>(context, listen: false)
//               .onPagechange(index);
//         },
//         itemBuilder: (_, index) {
//           return ForecastBody(forecastDay: widget.forecastDays[index]);
//         });
//   }
// }
