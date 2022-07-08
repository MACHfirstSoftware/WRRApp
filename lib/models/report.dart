import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  Report({
    required this.id,
    required this.postId,
    required this.numDeer,
    required this.numBucks,
    required this.numHours,
    required this.weaponUsed,
    required this.weatherRating,
    required this.weatherReportId,
    required this.startDateTime,
    required this.endDateTime,
    required this.successTime,
    required this.isSuccess,
  });

  int id;
  int postId;
  int numDeer;
  int numBucks;
  int numHours;
  String weaponUsed;
  int weatherRating;
  int weatherReportId;
  String startDateTime;
  String endDateTime;
  String successTime;
  bool isSuccess;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["id"],
        postId: json["postId"],
        numDeer: json["numDeer"],
        numBucks: json["numBucks"],
        numHours: json["numHours"],
        weaponUsed: json["weaponUsed"],
        weatherRating: json["weatherRating"],
        weatherReportId: json["weatherReportId"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
        successTime: json["successTime"],
        isSuccess: json["isSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "numDeer": numDeer,
        "numBucks": numBucks,
        "numHours": numHours,
        "weaponUsed": weaponUsed,
        "weatherRating": weatherRating,
        "weatherReportId": weatherReportId,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "successTime": successTime,
        "isSuccess": isSuccess,
      };
}
