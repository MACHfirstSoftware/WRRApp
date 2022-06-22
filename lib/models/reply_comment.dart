class ReplyComment {
  ReplyComment({
    required this.id,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.postCommentId,
    required this.body,
    required this.createdOn,
  });

  int id;
  String personId;
  String firstName;
  String lastName;
  int postCommentId;
  String body;
  String createdOn;

  factory ReplyComment.fromJson(Map<String, dynamic> json) => ReplyComment(
        id: json["id"],
        personId: json["personId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        postCommentId: json["postCommentId"],
        body: json["body"],
        createdOn: json["createdOn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "firstName": firstName,
        "lastName": lastName,
        "postCommentId": postCommentId,
        "body": body,
        "createdOn": createdOn,
      };
}
