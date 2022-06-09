import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wisconsin_app/config.dart';

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

  static Future<void> getCurrentWeather(String countyName) async {
    try {
      final response = await _dio.get(
          "http://api.weatherapi.com/v1/current.json?key=${Constant.weatherApiKey}&q=$countyName");
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

  static Future<void> getForecastWeather(String countyName) async {
    try {
      final response = await _dio.get(
          "http://api.weatherapi.com/v1/forecast.json?key=${Constant.weatherApiKey}&q=$countyName");
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

  static Future<void> getHistoricalWeather(String countyName) async {
    try {
      final response = await _dio.get(
          "http://api.weatherapi.com/v1/forecast.json?key=${Constant.weatherApiKey}&q=$countyName&dt=${DateTime.now().subtract(const Duration(days: 1))}");
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
