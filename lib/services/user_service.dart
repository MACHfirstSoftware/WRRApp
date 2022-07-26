import 'dart:developer';

import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class UserService {
  static Future<ApiResult<User>> signIn(String email, String password) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/Login/$email/$password");
      if (response.statusCode == 200) {
        return ApiResult.success(data: User.fromJson(response.data));
      }
      if (response.statusCode == 401) {
        return ApiResult.responseError(
            responseError:
                ResponseError(error: response.data as String, errorCode: 401));
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

  static Future<ApiResult<String>> signUp(Map<String, dynamic> person) async {
    log(person.toString());
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/Person",
        data: person,
      );
      if (response.statusCode == 201) {
        print(response);
        return ApiResult.success(
            data: response.data.toString().replaceAll("Id :", ""));
      }
      if (response.statusCode == 409) {
        print(response);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: response.data, errorCode: response.statusCode ?? 0));
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

  static Future<ApiResult<List<User>>> getFollowedList(String personId) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/FollowedList?id=$personId");
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => User.fromJson(d as Map<String, dynamic>))
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

  static Future<String?> updateProfileImage(Map<String, dynamic> data) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/ProfileImage", data: data);
      print(response.statusCode);
      log(response.data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ApiResult<List<User>>> getFollowing(String personId) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/Following?id=$personId");
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => User.fromJson(d as Map<String, dynamic>))
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

  static Future<ApiResult<List<User>>> getFollowers(String personId) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/Followers?id=$personId");
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => User.fromJson(d as Map<String, dynamic>))
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

  static Future<bool> updateUser(
      String userId,
      String firstName,
      String lastName,
      String code,
      String phone,
      int countyId,
      int regionId) async {
    print("update call");
    try {
      final response = await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/Person/$userId", data: [
        {"path": "/firstName", "op": "Add", "value": firstName},
        {"path": "/lastName", "op": "Add", "value": lastName},
        {"path": "/code", "op": "Add", "value": code},
        {"path": "/phoneMobile", "op": "Add", "value": phone},
        {"path": "/countyId", "op": "Add", "value": countyId},
        {"path": "/regionId", "op": "Add", "value": regionId},
      ]);
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

  static Future<bool> updateWeapon(String userId, int answerId) async {
    print("update call");
    try {
      final response = await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/Profile?personId=$userId", data: [
        {"path": "/answerId", "op": "Add", "value": answerId},
      ]);
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

  static Future<Map<String, dynamic>> changePassword(
      String userName, String currentPassword, String newPassword) async {
    print("change call");
    try {
      final response = await CustomHttp.getDio().post(Constant.baseUrl +
          "/ChangePassword?userName=$userName&password=$currentPassword&newPassword=$newPassword");
      print(response.statusCode);
      if (response.statusCode == 204) {
        return {"success": true, "message": "Successfully changed"};
      } else {
        return {"success": false, "message": "Something went wrong"};
      }
    } catch (e) {
      print(e);
      final err = NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e));
      return {
        "success": false,
        "message":
            err == "Unauthorized request" ? "Incorrect current password" : err
      };
    }
  }

  static Future<ApiResult<User>> verifyUser(String userName) async {
    print("verify call");
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/ValidateUserName?userName=$userName");
      print(response.statusCode);
      if (response.statusCode == 200) {
        return ApiResult.success(data: User.fromJson(response.data));
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
