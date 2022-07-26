import 'dart:developer';

import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/notification.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class NotificationService {
  static Future<ApiResult<List<NotificationModel>>> getNotifications(
      String userId) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/PersonPostShare?personId=$userId");
      // log(response.data.toString());
      // inspect(response.data);
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) =>
                    NotificationModel.fromJson(d as Map<String, dynamic>))
                .toList());
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

  static Future<bool> notificationClick(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/ClickPostShare?id=$id");
      log(response.data.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}