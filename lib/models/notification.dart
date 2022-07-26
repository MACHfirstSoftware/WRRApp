import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.viewed,
    required this.notificationPost,
    required this.postOwner,
    required this.shareBy,
  });

  int id;
  bool viewed;
  NotificationPost notificationPost;
  PostOwner postOwner;
  PostOwner shareBy;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        viewed: json["viewed"],
        notificationPost: NotificationPost.fromJson(json["post"]),
        postOwner: PostOwner.fromJson(json["postOwner"]),
        shareBy: PostOwner.fromJson(json["shareBy"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "viewed": viewed,
        "post": notificationPost.toJson(),
        "postOwner": postOwner.toJson(),
        "shareBy": shareBy.toJson(),
      };
}

class NotificationPost {
  NotificationPost({
    required this.id,
    required this.personId,
    required this.postTypeId,
    required this.regionId,
    required this.countyId,
    required this.title,
    required this.body,
    required this.isFlagged,
  });

  int id;
  String personId;
  int postTypeId;
  int regionId;
  int countyId;
  String title;
  String body;
  bool isFlagged;

  factory NotificationPost.fromJson(Map<String, dynamic> json) =>
      NotificationPost(
        id: json["id"],
        personId: json["personId"],
        postTypeId: json["postTypeId"],
        regionId: json["regionId"],
        countyId: json["countyId"],
        title: json["title"],
        body: json["body"],
        isFlagged: json["isFlagged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "postTypeId": postTypeId,
        "regionId": regionId,
        "countyId": countyId,
        "title": title,
        "body": body,
        "isFlagged": isFlagged,
      };
}

class PostOwner {
  PostOwner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.code,
    // required this.emailAddress,
    // required this.username,
    // required this.countyId,
    // required this.regionId,
    // required this.isFollowed,
    this.imageLocation,
  });

  String id;
  String firstName;
  String lastName;
  String code;
  // String emailAddress;
  // String username;
  // int countyId;
  // int regionId;
  // bool isFollowed;
  String? imageLocation;

  factory PostOwner.fromJson(Map<String, dynamic> json) => PostOwner(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        code: json["code"],
        // emailAddress: json["emailAddress"],
        // username: json["username"],
        // countyId: json["countyId"],
        // regionId: json["regionId"],
        // isFollowed: json["isFollowed"],
        imageLocation: json["imageLocation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "code": code,
        // "emailAddress": emailAddress,
        // "username": username,
        // "countyId": countyId,
        // "regionId": regionId,
        // "isFollowed": isFollowed,
        "imageLocation": imageLocation,
      };
}
