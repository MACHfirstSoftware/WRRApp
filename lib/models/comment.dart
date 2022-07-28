import 'package:wisconsin_app/models/reply_comment.dart';
import 'dart:convert';

import 'package:wisconsin_app/utils/common.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    required this.id,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.code,
    required this.postId,
    required this.body,
    required this.timeAgo,
    required this.createdOn,
    this.modifiedOn,
    required this.replyComments,
  });

  int id;
  String personId;
  String firstName;
  String lastName;
  String code;
  int postId;
  String body;
  String timeAgo;
  DateTime createdOn;
  DateTime? modifiedOn;
  List<ReplyComment> replyComments;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        personId: json["personId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        code: json["code"],
        postId: json["postId"],
        body: json["body"],
        timeAgo: json["time"],
        createdOn: UtilCommon.getDatefromString(json["createdOn"]),
        modifiedOn: json["modifiedOn"] != null && json["modifiedOn"] != ""
            ? UtilCommon.getDatefromString(json["modifiedOn"])
            : null,
        replyComments: List<ReplyComment>.from(
            json["replyComments"].map((x) => ReplyComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "code": code,
        "postId": postId,
        "body": body,
        "time": timeAgo,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "replyComments":
            List<dynamic>.from(replyComments.map((x) => x.toJson())),
      };
}
