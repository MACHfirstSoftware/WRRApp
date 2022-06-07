import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/Question.dart';
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
      print(e);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   backgroundColor: Colors.white,
      //   behavior: SnackBarBehavior.floating,
      //   duration: const Duration(seconds: 10),
      //   content: Text(
      //     e.toString(),
      //     style: const TextStyle(color: Colors.black),
      //   ),
      // ));
      return null;
    }
  }
}
