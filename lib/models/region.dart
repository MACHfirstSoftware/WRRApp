import 'dart:convert';

List<Region> regionFromJson(String str) =>
    List<Region>.from(json.decode(str).map((x) => Region.fromJson(x)));

String regionToJson(List<Region> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Region {
  Region({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
