import 'package:wisconsin_app/models/comment.dart';
import 'dart:convert';

import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/report.dart';
import 'package:wisconsin_app/utils/common.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post(
      {required this.id,
      required this.personId,
      required this.firstName,
      required this.lastName,
      required this.title,
      required this.body,
      required this.createdOn,
      this.modifiedOn,
      required this.isShare,
      this.sharePersonId,
      this.sharePersonFirstName = "",
      this.sharePersonLastName = "",
      required this.likes,
      required this.comments,
      required this.media,
      this.report});

  int id;
  String personId;
  String firstName;
  String lastName;
  String title;
  String body;
  DateTime createdOn;
  DateTime? modifiedOn;
  bool isShare;
  String? sharePersonId;
  String sharePersonFirstName;
  String sharePersonLastName;
  List<Like> likes;
  List<Comment> comments;
  List<Media> media;
  Report? report;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      id: json["id"],
      personId: json["personId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      title: json["title"],
      body: json["body"],
      createdOn: UtilCommon.getDatefromString(json["createdOn"]),
      modifiedOn: json["modifiedOn"] != null && json["modifiedOn"] != ""
          ? UtilCommon.getDatefromString(json["modifiedOn"])
          : null,
      isShare: json["isShare"],
      sharePersonId: json["sharePersonId"],
      sharePersonFirstName: json["sharePersonFirstName"],
      sharePersonLastName: json["sharePersonLastName"],
      likes: List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
      comments:
          List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
      media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      report: json["report"] != null ? Report.fromJson(json["report"]) : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "title": title,
        "body": body,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "isShare": isShare,
        "sharePersonId": sharePersonId,
        "sharePersonFirstName": sharePersonFirstName,
        "sharePersonLastName": sharePersonLastName,
        "likes": List<dynamic>.from(likes.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "report": report
      };
}
