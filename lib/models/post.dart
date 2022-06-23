import 'package:wisconsin_app/models/comment.dart';
import 'dart:convert';

import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/media.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    required this.id,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.body,
    required this.createdOn,
    required this.modifiedOn,
    required this.isShare,
    required this.sharePersonId,
    required this.shareFirstName,
    required this.shareLastName,
    required this.likes,
    required this.comments,
    required this.media,
  });

  int id;
  String personId;
  String firstName;
  String lastName;
  String title;
  String body;
  String createdOn;
  String modifiedOn;
  bool isShare;
  String? sharePersonId;
  String shareFirstName;
  String shareLastName;
  List<Like> likes;
  List<Comment> comments;
  List<Media> media;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        personId: json["personId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        title: json["title"],
        body: json["body"],
        createdOn: json["createdOn"],
        modifiedOn: json["modifiedOn"],
        isShare: json["isShare"],
        sharePersonId: json["sharePersonId"],
        shareFirstName: json["shareFirstName"],
        shareLastName: json["shareLastName"],
        likes: List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      );

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
        "shareFirstName": shareFirstName,
        "shareLastName": shareLastName,
        "likes": List<dynamic>.from(likes.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
      };
}
