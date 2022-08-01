import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class SubscriptionService {
  // static Future<ApiResult<List<Subscription>>> getSubscriptions() async {
  //   try {
  //     final response =
  //         await CustomHttp.getDio().get(Constant.baseUrl + "/Subscriptions");
  //     if (response.statusCode == 200) {
  //       return ApiResult.success(
  //           data: (response.data as List<dynamic>)
  //               .map((d) => Subscription.fromJson(d as Map<String, dynamic>))
  //               .toList());
  //     } else {
  //       return ApiResult.responseError(
  //           responseError: ResponseError(
  //               error: "Something went wrong!",
  //               errorCode: response.statusCode ?? 0));
  //     }
  //   } catch (e) {
  //     print(e);
  //     return ApiResult.failure(error: NetworkExceptions.getDioException(e));
  //   }
  // }

  // static Future<ApiResult<Subscription>> getSubscriptionById(int id) async {
  //   try {
  //     final response = await CustomHttp.getDio()
  //         .get(Constant.baseUrl + "/Subscriptions/$id");
  //     if (response.statusCode == 200) {
  //       return ApiResult.success(
  //           data: Subscription.fromJson(response.data as Map<String, dynamic>));
  //     } else {
  //       return ApiResult.responseError(
  //           responseError: ResponseError(
  //               error: "Something went wrong!",
  //               errorCode: response.statusCode ?? 0));
  //     }
  //   } catch (e) {
  //     print(e);
  //     return ApiResult.failure(error: NetworkExceptions.getDioException(e));
  //   }
  // }

  static Future<ApiResult<bool>> addSubscription(
      {required String personId, required bool isPremium}) async {
    try {
      final response = await CustomHttp.getDio().post(Constant.baseUrl +
          "/Subscription?personId=$personId&isPremium=$isPremium");
      if (response.statusCode != 201) {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Unable to subscribed!",
                errorCode: response.statusCode ?? 0));
      } else {
        return const ApiResult.success(data: true);
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
