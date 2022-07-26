import 'dart:convert';

List<SubscriptionPerson> subscriptionPersonFromJson(String str) =>
    List<SubscriptionPerson>.from(
        json.decode(str).map((x) => SubscriptionPerson.fromJson(x)));

String subscriptionPersonToJson(List<SubscriptionPerson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionPerson {
  SubscriptionPerson({
    required this.id,
    required this.subscriptionId,
    this.externalId,
    required this.createdOn,
    required this.nextRunOn,
    this.cancelledOn,
    required this.isActive,
    required this.isCancelled,
    required this.subscriptionApiModel,
  });

  int id;
  int subscriptionId;
  int? externalId;
  DateTime createdOn;
  DateTime nextRunOn;
  DateTime? cancelledOn;
  bool isActive;
  bool isCancelled;
  Subscription subscriptionApiModel;

  factory SubscriptionPerson.fromJson(Map<String, dynamic> json) =>
      SubscriptionPerson(
        id: json["id"],
        subscriptionId: json["subscriptionId"],
        externalId: json["externalId"],
        createdOn: DateTime.parse(json["createdOn"]),
        nextRunOn: DateTime.parse(json["nextRunOn"]),
        cancelledOn: json["cancelledOn"],
        isActive: json["isActive"],
        isCancelled: json["isCancelled"],
        subscriptionApiModel:
            Subscription.fromJson(json["subscriptionApiModel"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscriptionId": subscriptionId,
        "externalId": externalId,
        "createdOn": createdOn.toIso8601String(),
        "nextRunOn": nextRunOn.toIso8601String(),
        "cancelledOn": cancelledOn,
        "isActive": isActive,
        "isCancelled": isCancelled,
        "subscriptionApiModel": subscriptionApiModel.toJson(),
      };
}

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
