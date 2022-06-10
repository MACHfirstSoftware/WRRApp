import 'dart:convert';

Subscription subscriptionFromJson(String str) =>
    Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  Subscription({
    required this.id,
    required this.displayName,
    required this.groupName,
    this.externalId,
    required this.platform,
    required this.duration,
    required this.daysFree,
    required this.price,
    required this.sortOrder,
    required this.isPremium,
    required this.isActive,
  });

  int id;
  String displayName;
  String groupName;
  int? externalId;
  String platform;
  int duration;
  int daysFree;
  double price;
  int sortOrder;
  bool isPremium;
  bool isActive;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        displayName: json["displayName"],
        groupName: json["groupName"],
        externalId: json["externalId"],
        platform: json["platform"],
        duration: json["duration"],
        daysFree: json["daysFree"],
        price: json["price"].toDouble(),
        sortOrder: json["sortOrder"],
        isPremium: json["isPremium"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "displayName": displayName,
        "groupName": groupName,
        "externalId": externalId,
        "platform": platform,
        "duration": duration,
        "daysFree": daysFree,
        "price": price,
        "sortOrder": sortOrder,
        "isPremium": isPremium,
        "isActive": isActive,
      };
}
