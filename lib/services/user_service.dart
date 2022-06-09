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
}
