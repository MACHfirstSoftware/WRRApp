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
    required this.code,
    required this.countyName,
    required this.isFollower,
    this.imageLocation,
    this.countyId,
    required this.createdOn,
  });

  int id;
  int postId;
  String personId;
  String firstName;
  String lastName;
  String code;
  String countyName;
  int? countyId;
  String? imageLocation;
  bool isFollower;
  DateTime createdOn;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        postId: json["postId"],
        personId: json["personId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        code: json["code"],
        imageLocation: json["imageLocation"],
        countyName: json["countyName"] ?? "",
        countyId: json["countyId"],
        isFollower: json["isfollower"] ?? false,
        createdOn: UtilCommon.getDatefromString(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "code": code,
        "imageLocation": imageLocation,
        "countyName": countyName,
        "countyId": countyId,
        "isFollower": isFollower,
        "createdOn": createdOn,
      };
}
