import 'dart:convert';

SuperRegion superRegionFromJson(String str) =>
    SuperRegion.fromJson(json.decode(str));

String superRegionToJson(SuperRegion data) => json.encode(data.toJson());

class SuperRegion {
  SuperRegion({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory SuperRegion.fromJson(Map<String, dynamic> json) => SuperRegion(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
