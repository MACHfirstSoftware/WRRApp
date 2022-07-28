import 'dart:convert';

Sponsor sponsorFromJson(String str) => Sponsor.fromJson(json.decode(str));

String sponsorToJson(Sponsor data) => json.encode(data.toJson());

class Sponsor {
  Sponsor({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    required this.isActive,
    required this.discounts,
  });

  int id;
  String name;
  String description;
  String? logoUrl;
  bool isActive;
  List<Discount> discounts;

  factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        logoUrl: json["logoUrl"],
        isActive: json["isActive"],
        discounts: List<Discount>.from(
            json["discounts"].map((x) => Discount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "logoUrl": logoUrl,
        "isActive": isActive,
        "discounts": List<dynamic>.from(discounts.map((x) => x.toJson())),
      };
}

class Discount {
  Discount({
    required this.siteId,
    required this.sponsorId,
    this.discountCode,
    required this.link,
    this.offer,
    required this.startDateTime,
    required this.endDateTime,
    required this.sortOrder,
    required this.isActive,
  });

  int siteId;
  int sponsorId;
  String? discountCode;
  String link;
  String? offer;
  DateTime startDateTime;
  DateTime endDateTime;
  int sortOrder;
  bool isActive;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        siteId: json["siteId"],
        sponsorId: json["sponsorId"],
        discountCode: json["discountCode"],
        link: json["link"],
        offer: json["offer"],
        startDateTime: DateTime.parse(json["startDateTime"]),
        endDateTime: DateTime.parse(json["endDateTime"]),
        sortOrder: json["sortOrder"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "siteId": siteId,
        "sponsorId": sponsorId,
        "discountCode": discountCode,
        "link": link,
        "offer": offer,
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime.toIso8601String(),
        "sortOrder": sortOrder,
        "isActive": isActive,
      };
}
