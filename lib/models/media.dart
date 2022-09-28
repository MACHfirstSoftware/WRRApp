import 'dart:convert';

Media mediaFromJson(String str) => Media.fromJson(json.decode(str));

String mediaToJson(Media data) => json.encode(data.toJson());

class Media {
  Media({
    required this.id,
    required this.postId,
    required this.caption,
    this.imageUrl,
    this.videoUrl,
    this.thumbnail,
    required this.sortOrder,
    // required this.createdOn,
  });

  int id;
  int postId;
  String caption;
  String? imageUrl;
  String? videoUrl;
  String? thumbnail;
  int sortOrder;
  // DateTime createdOn;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        postId: json["postId"],
        caption: json["caption"],
        imageUrl: json["imageUrl"] == null
            ? null
            : json["imageUrl"] == ""
                ? null
                : json["imageUrl"],
        videoUrl: json["videoUrl"] == null
            ? null
            : json["videoUrl"] == ""
                ? null
                : json["videoUrl"],
        thumbnail: json["thumbnail"] == null
            ? null
            : json["thumbnail"] == ""
                ? null
                : json["thumbnail"],
        sortOrder: json["sortOrder"],
        // createdOn: UtilCommon.getDatefromString(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "caption": caption,
        "imageUrl": imageUrl,
        "videoUrl": videoUrl,
        "sortOrder": sortOrder,
        // "createdOn": createdOn,
      };
}
