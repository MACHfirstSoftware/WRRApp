import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.emailAddress,
    required this.username,
    this.country,
    this.stateOrTerritory,
    this.countyId,
    this.regionId,
    this.isOptIn,
  });

  String id;
  String firstName;
  String lastName;
  String emailAddress;
  String username;
  String? country;
  String? stateOrTerritory;
  int? countyId;
  int? regionId;
  bool? isOptIn;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        emailAddress: json["emailAddress"],
        username: json["username"],
        country: json["country"],
        stateOrTerritory: json["stateOrTerritory"],
        countyId: json["countyId"],
        regionId: json["regionId"],
        isOptIn: json["isOptIn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "emailAddress": emailAddress,
        "username": username,
        "country": country,
        "stateOrTerritory": stateOrTerritory,
        "countyId": countyId,
        "regionId": regionId,
        "isOptIn": isOptIn,
      };
}
