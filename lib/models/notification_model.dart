import 'dart:convert';

import 'package:wisconsin_app/models/post.dart';

NotificationModelNew notificationModelFromJson(String str) =>
    NotificationModelNew.fromJson(json.decode(str));

String notificationModelToJson(NotificationModelNew data) =>
    json.encode(data.toJson());

class NotificationModelNew {
  NotificationModelNew(
      {required this.id,
      required this.totalCount,
      required this.type,
      required this.notification,
      required this.createdOn,
      this.post,
      required this.viewed});

  int totalCount;
  int id;
  String type;
  String notification;
  String createdOn;
  Post? post;
  bool viewed;

  factory NotificationModelNew.fromJson(Map<String, dynamic> json) =>
      NotificationModelNew(
          id: json["id"],
          totalCount: json["totalCount"],
          type: json["type"],
          notification: json["notification"],
          createdOn: json["createdOn"],
          post: json["post"] != null ? Post.fromJson(json["post"]) : null,
          viewed: false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalCount": totalCount,
        "type": type,
        "notification": notification,
        "createdOn": createdOn,
        "post": post,
      };
}
