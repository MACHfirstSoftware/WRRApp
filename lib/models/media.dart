import 'dart:convert';

Media mediaFromJson(String str) => Media.fromJson(json.decode(str));

String mediaToJson(Media data) => json.encode(data.toJson());

class Media {
  Media({
    required this.id,
    required this.postId,
    required this.caption,
    required this.imageUrl,
    required this.videoUrl,
    required this.sortOrder,
    required this.createdOn,
  });

  int id;
  int postId;
  String caption;
  String imageUrl;
  String videoUrl;
  int sortOrder;
  String createdOn;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        postId: json["postId"],
        caption: json["caption"],
        imageUrl: json["imageUrl"],
        videoUrl: json["videoUrl"],
        sortOrder: json["sortOrder"],
        createdOn: json["createdOn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "caption": caption,
        "imageUrl": imageUrl,
        "videoUrl": videoUrl,
        "sortOrder": sortOrder,
        "createdOn": createdOn,
      };
}
