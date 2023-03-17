import 'package:flutter/material.dart';

class WeatherColorTheme {
  static Color bgColor = Colors.black;
  static Color ftColor = Colors.white;

  static setWeatherTheme(String condition) {
    ftColor = Colors.white;
    bgColor = Colors.black;
    if (condition.contains("sunny") || condition.contains("partly cloudy")) {
      ftColor = Colors.white;
      bgColor = Colors.lightBlue;
    }
    if (condition.contains("snow") || condition.contains("blizzard")) {
      ftColor = Colors.black;
      bgColor = Colors.white;
    }
    if (condition.contains("overcast")) {
      ftColor = Colors.white;
      bgColor = Colors.grey;
    }
    if (condition.contains("mist") || condition.contains("fog")) {
      ftColor = Colors.black;
      bgColor = Colors.grey[200]!;
    }
    if (condition.contains("rain") ||
        condition.contains("cloudy") ||
        condition.contains("drizzle")) {
      ftColor = Colors.white;
      bgColor = Colors.deepPurpleAccent;
    }
  }
}
