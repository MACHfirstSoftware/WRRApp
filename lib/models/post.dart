import 'package:wisconsin_app/models/comment.dart';
import 'package:wisconsin_app/models/contest.dart';
import 'package:wisconsin_app/models/county.dart';
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
      required this.personCode,
      required this.title,
      required this.body,
      required this.postPersonCounty,
      required this.postType,
      required this.createdOn,
      this.modifiedOn,
      required this.isShare,
      this.sharePersonId,
      this.sharePersonFirstName = "",
      this.sharePersonLastName = "",
      required this.likes,
      required this.comments,
      required this.media,
      this.report,
      this.contest,
      required this.county});

  int id;
  String personId;
  String firstName;
  String lastName;
  String personCode;
  String title;
  String body;
  String postPersonCounty;
  String postType;
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
  Contest? contest;
  County county;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      id: json["id"],
      personId: json["personId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      personCode: json["personCode"],
      title: json["title"],
      body: json["body"],
      postPersonCounty: json["postPersonCounty"],
      postType: json["postType"],
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
      report: json["report"] != null ? Report.fromJson(json["report"]) : null,
      contest:
          json["contest"] != null ? Contest.fromJson(json["contest"]) : null,
      county: County(
          id: json["county"]["id"],
          name: json["county"]["name"],
          regionId: json["county"]["regionId"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "personCode": personCode,
        "title": title,
        "body": body,
        "postPersonCounty": postPersonCounty,
        "postType": postType,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "isShare": isShare,
        "sharePersonId": sharePersonId,
        "sharePersonFirstName": sharePersonFirstName,
        "sharePersonLastName": sharePersonLastName,
        "likes": List<dynamic>.from(likes.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "report": report,
        "contest": contest
      };
}
