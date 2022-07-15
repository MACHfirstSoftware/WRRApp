import 'dart:convert';

Contest contestFromJson(String str) => Contest.fromJson(json.decode(str));

String contestToJson(Contest data) => json.encode(data.toJson());

class Contest {
  Contest({
    required this.id,
    required this.postId,
    required this.spread,
    required this.length,
    required this.numTines,
    required this.lengthTines,
    required this.sortOrder,
  });

  int id;
  int postId;
  double spread;
  double length;
  int numTines;
  int lengthTines;
  int sortOrder;

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
        id: json["id"],
        postId: json["postId"],
        spread: json["spread"].toDouble(),
        length: json["length"].toDouble(),
        numTines: json["numTines"],
        lengthTines: json["lengthTines"],
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "spread": spread,
        "length": length,
        "numTines": numTines,
        "lengthTines": lengthTines,
        "sortOrder": sortOrder,
      };
}
