import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/country.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/question.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/utils/custom_http.dart';

class QuestionnaireService {
  static Future<List<Question>?> getQuestionnarie() async {
    try {
      final response =
          await CustomHttp.getDio().get(Constant.baseUrl + "/QuestionAnswer");
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((d) => Question.fromJson(d as Map<String, dynamic>))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      // print(e);
      return null;
    }
  }

  static Future<List<Country>> getCountries() async {
    try {
      final response =
          await CustomHttp.getDio().get(Constant.baseUrl + "/Countries");
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((d) => Country.fromJson(d as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      // print(e);
      return [];
    }
  }

  static Future<List<Region>> getRegions(int territoryCode) async {
    try {
      final response = await CustomHttp.getDio()
          .get(Constant.baseUrl + "/Regions/$territoryCode");
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((d) => Region.fromJson(d as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      // print(e);
      return [];
    }
  }

  static Future<List<County>> getCounties(int regionId) async {
    try {
      final response =
          await CustomHttp.getDio().get(Constant.baseUrl + "/Counties/WI/-1");
      // print(response.statusCode);
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((d) => County.fromJson(d as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      // print(e);
      return [];
    }
  }

  static Future<void> saveQuestionnaire(List<Map<String, dynamic>> data) async {
    try {
      // final response =
      await CustomHttp.getDio().post(Constant.baseUrl + "/Profile", data: data);
      // if (response.statusCode == 200) {
      // } else {}
    } catch (e) {
      // print(e);
    }
  }
}
