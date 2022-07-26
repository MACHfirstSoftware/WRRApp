import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/current_weather.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/weather.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

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

  static Future<ApiResult<CurrentWeather>> getCurrentWeather(
      String countyName) async {
    try {
      final response = await _dio.get(
          "http://api.weatherapi.com/v1/current.json?key=${Constant.weatherApiKey}&q=$countyName");
      if (response.statusCode == 200) {
        return ApiResult.success(data: CurrentWeather.fromJson(response.data));
        // final details = response.data;
        // log(details.toString());
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
        // print("ERROR");
        // print(response.statusCode);
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<Weather>> getForecastWeather(
      String countyName) async {
    try {
      final response = await _dio.get(
          "http://api.weatherapi.com/v1/forecast.json?key=${Constant.weatherApiKey}&q=$countyName&days=10");
      if (response.statusCode == 200) {
        // final details = response.data;
        // log(details.toString());
        return ApiResult.success(data: Weather.fromJson(response.data));
      } else {
        print("ERROR");
        print(response.statusCode);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
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

  static Future<ApiResult<Astro>> getAstroDetails(String countyName) async {
    try {
      final response = await _dio.get(
          "http://api.weatherapi.com/v1/astronomy.json?key=${Constant.weatherApiKey}&q=$countyName");
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: Astro.fromJson(response.data["astronomy"]["astro"]));
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
