import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wisconsin_app/config.dart';

class CustomHttp {
  static final Dio _dio = Dio();

  static setInterceptor() {
    print("Intercept called...............");
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // if (subscriptionKey != null) {

        options.headers["Ocp-Apim-Subscription-Key"] = Constant.subscriptionKey;
        options.headers["Content-Type"] = "application/json";
        options.connectTimeout = 25000;
        options.receiveTimeout = 15000;
        options.sendTimeout = 20000;
        // } else {
        //   options.headers["Content-Type"] = "application/json";
        //   options.connectTimeout = 25000;
        //   options.receiveTimeout = 15000;
        //   options.sendTimeout = 20000;
        // }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        return handler.resolve(response);
      },
      onError: (error, handler) async {
        debugPrint('----------Error-----------');
        return handler.next(error);
      },
    ));
  }

  static Dio getDio() {
    return _dio;
  }
}
