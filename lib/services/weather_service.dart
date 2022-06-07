import 'dart:developer';

import 'package:dio/dio.dart';

class WeatherService {
  static final Dio _dio = Dio();
  static Future<void> getWeatherDetails() async {
    try {
      final response = await _dio.get(
          "https://api.weatherapi.com/v1/forecast.json?key=120918090dd44ac4a72204959220106&q=London&days=2&aqi=no&alerts=no");
      if (response.statusCode == 200) {
        final details = response.data;
        log(details.toString());
      } else {
        print("ERROR");
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
