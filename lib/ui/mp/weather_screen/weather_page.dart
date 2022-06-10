import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/weather_details.dart';

class WeatherPage extends StatefulWidget {
  final User user;
  const WeatherPage({Key? key, required this.user}) : super(key: key);

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
          centerTitle: true,
          title: Text(
            widget.user.country ?? "",
            style: TextStyle(
                fontSize: 25.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
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
