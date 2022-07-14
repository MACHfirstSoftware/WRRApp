import 'dart:convert';

import 'package:wisconsin_app/utils/common.dart';

Like likeFromJson(String str) => Like.fromJson(json.decode(str));

String likeToJson(Like data) => json.encode(data.toJson());

class Like {
  Like({
    required this.id,
    required this.postId,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.createdOn,
  });

  int id;
  int postId;
  String personId;
  String firstName;
  String lastName;
  DateTime createdOn;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        postId: json["postId"],
        personId: json["personId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        createdOn: UtilCommon.getDatefromString(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "createdOn": createdOn,
      };
}
