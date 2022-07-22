import 'dart:convert';

import 'package:wisconsin_app/utils/common.dart';

ReplyComment replyCommentFromJson(String str) =>
    ReplyComment.fromJson(json.decode(str));

String replyCommentToJson(ReplyComment data) => json.encode(data.toJson());

class ReplyComment {
  ReplyComment({
    required this.id,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.code,
    required this.postCommentId,
    required this.body,
    required this.createdOn,
  });

  int id;
  String personId;
  String firstName;
  String lastName;
  String code;
  int postCommentId;
  String body;
  DateTime createdOn;

  factory ReplyComment.fromJson(Map<String, dynamic> json) => ReplyComment(
        id: json["id"],
        personId: json["personId"],
        firstName: json["firstName"],
        code: json["code"],
        lastName: json["lastName"],
        postCommentId: json["postCommentId"],
        body: json["body"],
        createdOn: UtilCommon.getDatefromString(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "code": code,
        "postCommentId": postCommentId,
        "body": body,
        "createdOn": createdOn,
      };
}
