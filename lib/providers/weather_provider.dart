import 'package:flutter/material.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/astro.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/current_weather.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/weather.dart';
import 'package:wisconsin_app/services/weather_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class WeatherProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  County? _county;
  Weather? _weather;
  // CurrentWeather? _currentWeather;
  // Astros? _astro;
  int pageNum = -1;
  String errorMessage = '';

  ApiStatus get apiStatus => _apiStatus;
  County get county => _county!;
  // CurrentWeather get currentWeather => _currentWeather!;
  // Astros get astro => _astro!;
  Weather get weather => _weather!;

  void onPagechange(int index) {
    pageNum = index;
    notifyListeners();
  }

  void changeCounty(County _countyValue) {
    _county = _countyValue;
    getWeatherDetails();
  }

  void setCounty(County _countyValue) {
    _county = _countyValue;
  }

  void setBusy() {
    _apiStatus = ApiStatus.isBusy;
    notifyListeners();
  }

  void setError() {
    _apiStatus = ApiStatus.isError;
    notifyListeners();
  }

  void setIdle() {
    _apiStatus = ApiStatus.isIdle;
    notifyListeners();
  }

  void setInitial() {
    _apiStatus = ApiStatus.isInitial;
    _county = null;
    // _currentWeather = null;
    _weather = null;
    errorMessage = '';
    notifyListeners();
  }

  // Future<void> getWeatherDetails({bool isInit = false}) async {
  //   isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
  //   final current = await WeatherService.getCurrentWeather(_county!.name);
  //   current.when(success: (CurrentWeather currentWeather) async {
  //     _currentWeather = currentWeather;
  //     final astro = await WeatherService.getAstroDetails(_county!.name);
  //     astro.when(success: (Astros astro) {
  //       _astro = astro;
  //       errorMessage = '';
  //       setIdle();
  //     }, failure: (NetworkExceptions error) {
  //       errorMessage = NetworkExceptions.getErrorMessage(error);
  //       setError();
  //     }, responseError: (ResponseError responseError) {
  //       errorMessage = responseError.error;
  //       setError();
  //     });
  //   }, failure: (NetworkExceptions error) {
  //     errorMessage = NetworkExceptions.getErrorMessage(error);
  //     setError();
  //   }, responseError: (ResponseError responseError) {
  //     errorMessage = responseError.error;
  //     setError();
  //   });
  // }

  Future<void> getWeatherDetails({bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final current = await WeatherService.getForecastWeather(_county!.name);
    current.when(success: (Weather weather) async {
      _weather = weather;
      setIdle();
    }, failure: (NetworkExceptions error) {
      errorMessage = NetworkExceptions.getErrorMessage(error);
      setError();
    }, responseError: (ResponseError responseError) {
      errorMessage = responseError.error;
      setError();
    });
  }
}
