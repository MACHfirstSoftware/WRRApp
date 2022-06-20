import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/models/county.dart';

class RegisterProvider with ChangeNotifier {
  County? selectedCounty;
  List<Map<String, dynamic>> selectedAnswers = [];
  bool sendMeUpdates = false;

  void sendMeUpdatesFunc() {
    sendMeUpdates = !sendMeUpdates;
    notifyListeners();
  }

  void changeCounty(County county) {
    selectedCounty = county;
    notifyListeners();
  }

  void addAnswer(Map<String, dynamic> selectedtAnswer) {
    if (selectedAnswers.isEmpty) {
      selectedAnswers.add(selectedtAnswer);
    } else {
      for (final answerData in selectedAnswers) {
        if (answerData["questionId"] == selectedtAnswer["questionId"]) {
          selectedAnswers.remove(answerData);
          selectedAnswers.add(selectedtAnswer);
          break;
        }
      }
    }
    notifyListeners();
  }

  void updateAnswers(String userId) {
    for (int i = 0; i < selectedAnswers.length; i++) {
      selectedAnswers[i] = {
        "personId": userId,
        "questionId": selectedAnswers[i]["questionId"],
        "answerId": selectedAnswers[i]["answerId"],
        "answerComment": ""
      };
    }
  }

  void clearData() {
    selectedCounty = null;
    selectedAnswers = [];
    sendMeUpdates = false;
  }
}
