import 'package:wisconsin_app/models/reply_comment.dart';

class Comment {
  Comment({
    required this.id,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.postId,
    required this.body,
    required this.createdOn,
    required this.modifiedOn,
    required this.replyComments,
  });

  int id;
  String personId;
  String firstName;
  String lastName;
  int postId;
  String body;
  String createdOn;
  String modifiedOn;
  List<ReplyComment> replyComments;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        personId: json["personId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        postId: json["postId"],
        body: json["body"],
        createdOn: json["createdOn"],
        modifiedOn: json["modifiedOn"],
        replyComments: List<ReplyComment>.from(
            json["replyComments"].map((x) => ReplyComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "postId": postId,
        "body": body,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "replyComments":
            List<dynamic>.from(replyComments.map((x) => x.toJson())),
      };
}
