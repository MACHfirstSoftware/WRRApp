import 'dart:convert';

import 'package:wisconsin_app/models/subscription.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User(
      {required this.id,
      required this.lastName,
      required this.firstName,
      required this.emailAddress,
      required this.username,
      required this.code,
      this.profileImageUrl,
      required this.country,
      required this.stateOrTerritory,
      required this.countyId,
      this.countyName,
      required this.regionId,
      this.regionName,
      required this.isOptIn,
      this.isFollowed = false,
      this.phoneMobile = "",
      this.subscriptionPerson,
      this.answerId});

  String id;
  String firstName;
  String lastName;
  String emailAddress;
  String username;
  String code;
  String? profileImageUrl;
  String country;
  String stateOrTerritory;
  int countyId;
  String? countyName;
  int regionId;
  String? regionName;
  bool isOptIn;
  bool isFollowed;
  String phoneMobile;
  List<SubscriptionPerson>? subscriptionPerson;
  int? answerId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        emailAddress: json["emailAddress"],
        username: json["username"],
        code: json["code"],
        profileImageUrl: json["imageLocation"],
        country: json["country"],
        stateOrTerritory: json["stateOrTerritory"],
        countyId: json["countyId"],
        regionId: json["regionId"],
        isOptIn: json["isOptIn"],
        isFollowed: json["isFollowed"] ?? false,
        phoneMobile: json["phoneMobile"] ?? "",
        subscriptionPerson: json["subscriptionPerson"] != null
            ? (json["subscriptionPerson"] as List<dynamic>)
                .map((e) =>
                    SubscriptionPerson.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        answerId: json["answer"] != null ? json["answer"]["id"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "emailAddress": emailAddress,
        "username": username,
        "code": code,
        "imageLocation": profileImageUrl,
        "country": country,
        "stateOrTerritory": stateOrTerritory,
        "countyId": countyId,
        "regionId": regionId,
        "isOptIn": isOptIn,
        "isFollowed": isFollowed,
        "phoneMobile": phoneMobile
      };
}
