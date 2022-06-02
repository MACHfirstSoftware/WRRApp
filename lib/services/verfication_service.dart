import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/utils/custom_http.dart';

class VerficationService {
  static Future<bool> sendCode(String id, String phoneNumber) async {
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/Send/$id/$phoneNumber",
      );
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> reSendCode(String id, String phoneNumber) async {
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/ReSend/$id/$phoneNumber",
      );
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> verifyCode(String id, String code) async {
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/VerifyCode/$id/$code",
      );
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
