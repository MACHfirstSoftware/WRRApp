import 'dart:convert';

County countyFromJson(String str) => County.fromJson(json.decode(str));

String countyToJson(County data) => json.encode(data.toJson());

class County {
  County({
    required this.id,
    required this.name,
    required this.regionId,
    this.seat,
  });

  int id;
  String name;
  int regionId;
  String? seat;

  factory County.fromJson(Map<String, dynamic> json) => County(
        id: json["id"],
        name: json["name"],
        regionId: json["regionId"],
        seat: json["seat"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "regionId": regionId, "seat": seat};
}
