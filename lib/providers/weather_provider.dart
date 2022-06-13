import 'package:flutter/material.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/current_weather.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/weather_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class WeatherProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  County? _county;
  CurrentWeather? _currentWeather;
  String errorMessage = '';

  ApiStatus get apiStatus => _apiStatus;
  County get county => _county!;
  CurrentWeather get currentWeather => _currentWeather!;

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
    _currentWeather = null;
    errorMessage = '';
    notifyListeners();
  }

  Future<void> getWeatherDetails() async {
    _apiStatus = ApiStatus.isBusy;
    final current = await WeatherService.getCurrentWeather(_county!.name);
    current.when(success: (CurrentWeather currentWeather) {
      _currentWeather = currentWeather;
      errorMessage = '';
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
