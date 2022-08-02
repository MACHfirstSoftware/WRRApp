import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class VerficationService {
  static Future<bool> sendCode(String id, String phoneNumber,
      {required bool isReset}) async {
    print(id);
    print(phoneNumber);
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/Send/$id?phoneNumber=$phoneNumber&reset=$isReset",
      );
      print(response);
      return true;
    } catch (e) {
      print(e);
      print(NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e)));
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
      print(e);
      print(NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e)));
      return false;
    }
  }

  static Future<bool> verifyCode(String id, String code) async {
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/VerifyCode/$id/$code",
      );
      if (response.data == "validation Successful") {
        return true;
      } else {
        return false;
      }
      // print(response);

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
