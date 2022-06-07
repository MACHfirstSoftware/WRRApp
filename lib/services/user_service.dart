import 'package:dio/dio.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_object.dart';
import 'package:wisconsin_app/utils/custom_http.dart';

class UserService {
  static Future<ResponseObject> signIn(String email, String password) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/Login/$email/$password");
      if (response.statusCode == 200) {
        ResponseObject res = ResponseObject(
            success: true, data: response.data, message: "Success");
        return res;
      } else {
        ResponseObject res = ResponseObject(
            success: false, data: null, message: "Something went wrong!");
        return res;
      }
    } catch (e) {
      print(e);
      ResponseObject res = ResponseObject(
          success: false, data: null, message: "Something went wrong!");
      return res;
    }
  }

  static Future<String?> signUp(Map<String, dynamic> person) async {
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/Person",
          data: person,
          options: Options(contentType: "application/json"));
      print(response);
      return response.data.toString().replaceAll("Id :", "");
    } catch (e) {
      print(e);
      return null;
    }
  }
}
