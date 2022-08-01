import 'dart:developer';

import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/utils/custom_http.dart';

class SearchService {
  static Future<List<User>> searchPerson(
      String personId, String searchText, bool viewAll,
      {int? skipCount}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Search?loggedPersonId=$personId&searchText=$searchText&viewAll=$viewAll" +
          (skipCount != null ? "&skipCount=$skipCount" : ""));
      if (response.statusCode == 200) {
        inspect(response.data);
        // final list = response.data as List<dynamic>;
        // print(list.length);
        return (response.data as List<dynamic>)
            .map((d) => User.fromJson(d as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      // print(e);
      return [];
    }
  }

  static Future<bool> personFollow(String personId, String followerId) async {
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/PersonFollow",
          data: {"personId": personId, "followPersonId": followerId});
      if (response.statusCode == 201) {
        // print(response.data);
        return true;
      } else {
        // print(response.data);
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<bool> personUnfollow(
      String personId, String unFollowerId) async {
    try {
      final response = await CustomHttp.getDio().delete(Constant.baseUrl +
          "/PersonUnFollow?personId=$personId&unFollowPersonId=$unFollowerId");

      if (response.statusCode == 201) {
        // print(response.data);
        return true;
      } else {
        // print(response.data);
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
