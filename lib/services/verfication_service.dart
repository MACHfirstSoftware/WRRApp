import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/utils/custom_http.dart';

class VerficationService {
  static Future<bool> sendCodeMobile(String id, String phoneNumber,
      {required bool isReset}) async {
    try {
      await CustomHttp.getDio().post(
        Constant.baseUrl + "/Send/$id?phoneNumber=$phoneNumber&reset=$isReset",
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> sendCodeMail(String id) async {
    try {
      await CustomHttp.getDio().post(
        Constant.baseUrl + "/SendEmail/$id",
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> reSendCode(String id, String phoneNumber) async {
    try {
      // final response =
      await CustomHttp.getDio().post(
        Constant.baseUrl + "/ReSend/$id/$phoneNumber",
      );
      // print(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> verifyCode(String id, String code) async {
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/VerifyCode/$id/$code",
      );
      // print(response.statusCode);
      if (response.data == "validation Successful") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<bool> personPhonePatch(String userId, String phone) async {
    try {
      // final response =
      await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/Person/$userId", data: [
        {"path": "/PhoneMobile", "op": "Add", "value": phone},
        {"path": "/IsActive", "op": "Add", "value": true}
      ]);
      // print(response);
      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  // static Future<bool> personActivePatch(String userId) async {
  //   try {
  //     final response = await CustomHttp.getDio()
  //         .patch(Constant.baseUrl + "/Person/$userId", data: [
  //       {"path": "/IsActive", "op": "Add", "value": true}
  //     ]);
  //     print(response);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
