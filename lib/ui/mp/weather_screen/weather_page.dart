import 'package:flutter/material.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/dashboard.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/weather_details.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF262626),
          title: const TabBar(tabs: [
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
        body: const TabBarView(
          children: [
            WeatherDetails(),
            WeatherDetails(),
            WeatherDetails(),
          ],
        ),
      ),
    );
  }
}
