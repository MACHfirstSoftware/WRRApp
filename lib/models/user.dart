import 'dart:convert';

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
      required this.country,
      required this.stateOrTerritory,
      required this.countyId,
      this.countyName,
      required this.regionId,
      required this.isOptIn,
      this.isFallowed = false});

  String id;
  String firstName;
  String lastName;
  String emailAddress;
  String username;
  String code;
  String country;
  String stateOrTerritory;
  int countyId;
  String? countyName;
  int regionId;
  bool isOptIn;
  bool isFallowed;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        emailAddress: json["emailAddress"],
        username: json["username"],
        code: json["code"],
        country: json["country"],
        stateOrTerritory: json["stateOrTerritory"],
        countyId: json["countyId"],
        regionId: json["regionId"],
        isOptIn: json["isOptIn"],
        isFallowed: json["isFallowed"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "emailAddress": emailAddress,
        "username": username,
        "code": code,
        "country": country,
        "stateOrTerritory": stateOrTerritory,
        "countyId": countyId,
        "regionId": regionId,
        "isOptIn": isOptIn,
        "isFallowed": isFallowed
      };
}
