import 'dart:convert';

County countyFromJson(String str) => County.fromJson(json.decode(str));

String countyToJson(County data) => json.encode(data.toJson());

class County {
  County({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory County.fromJson(Map<String, dynamic> json) => County(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
