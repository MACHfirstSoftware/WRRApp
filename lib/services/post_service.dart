import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/comment.dart';
import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/reply_comment.dart';
import 'package:wisconsin_app/models/report.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class PostService {
  static Future<ApiResult<List<Post>>> getMyWRRPosts(String userId,
      {DateTime? lastRecordTime}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId/MyWRR" +
          (lastRecordTime != null ? "?lastRecordTime=$lastRecordTime" : ""));
      log(response.data.toString());
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => Post.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Post>>> getMyRegionPosts(
      String userId, int regionId,
      {DateTime? lastRecordTime}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId/MyRegion" +
          (lastRecordTime != null
              ? "?lastRecordTime=$lastRecordTime&regionId=$regionId"
              : "?regionId=$regionId"));
      inspect(response.data);
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => Post.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Post>>> getAllPosts(String userId,
      {DateTime? lastRecordTime}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId/All" +
          (lastRecordTime != null
              ? "?lastRecordTime=$lastRecordTime&regionId=0"
              : "?regionId=0"));
      if (response.statusCode == 200) {
        // print(response.data);
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => Post.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Post>>> getReportPosts(
      String userId, int regionId,
      {DateTime? lastRecordTime}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId/Report?regionId=$regionId" +
          (lastRecordTime != null ? "&lastRecordTime=$lastRecordTime" : ""));
      log(response.data.toString());
      inspect(response.data);
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => Post.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Post>>> getContest(
      String userId, int regionId, CustomSuperRegion customSuperRegion) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId/Contest?regionId=$regionId&superRegion=${customSuperRegion.superRegion.id}&weapon=${customSuperRegion.weapon}");

      inspect(response.data);
      if (response.statusCode == 200) {
        return ApiResult.success(
            data: (response.data as List<dynamic>)
                .map((d) => Post.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<int>> postPublish(
      Map<String, dynamic> postDetails) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/Post", data: postDetails);
      if (response.statusCode == 201) {
        // print(response.data);
        return ApiResult.success(data: response.data["id"] as int);
      } else {
        // print(response.data);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<Report>> reportPostPublish(
      Map<String, dynamic> postDetails) async {
    // log(postDetails.toString());
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/PostReport", data: postDetails);
      // log(response.data.toString());
      if (response.statusCode == 201) {
        // print(response.data);
        return ApiResult.success(data: Report.fromJson(response.data));
      } else {
        // print(response.data);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Media>>> addPostImage(
      List<Map<String, dynamic>> postImageDetails) async {
    // log(postImageDetails.toString());
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/PostImage",
          data: postImageDetails,
          options: Options(receiveTimeout: 60000, sendTimeout: 60000));
      // print(response);
      if (response.statusCode == 200) {
        // print(response.data);
        List<dynamic> res = response.data;
        List<dynamic> medias = res.last["media"];
        return ApiResult.success(
            data: medias
                .map((d) => Media.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        // print(response.data);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      // print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<void> addPostVideo(String path) async {
    print(path);
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromFileSync(path, filename: "abc.mp4"),
    });
    try {
      final response = await CustomHttp.getDio().post(
        Constant.baseUrl + "/PostVideo",
        data: formData,
        // options: Options(
        //     receiveTimeout: 60000,
        //     sendTimeout: 60000,
        //     contentType: "multipart/form-data")
      );
      if (response.statusCode == 200) {
        print(response.data);
      } else {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> imageDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteImage?id=$id");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> postDelete(int postId) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/Post?id=$postId");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePost(int postId, String title, String body) async {
    // print("update call");
    try {
      final response = await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/Patch?id=$postId", data: [
        {"path": "/title", "op": "Add", "value": title},
        {"path": "/body", "op": "Add", "value": body}
      ]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<bool> updateReportPost(
      int postId, String title, String body, int countyId, int regionId) async {
    // print("update call");
    try {
      final response = await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/Patch?id=$postId", data: [
        {"path": "/title", "op": "Add", "value": title},
        {"path": "/body", "op": "Add", "value": body},
        {"path": "/countyId", "op": "Add", "value": countyId},
        {"path": "/regionId", "op": "Add", "value": regionId},
      ]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<bool> updateReport(Report report) async {
    log(report.toJson().toString());
    // print("update call");
    try {
      final response = await CustomHttp.getDio().patch(
          Constant.baseUrl + "/ReportPatch?postId=${report.postId}",
          data: [
            {"path": "/numDeer", "op": "Add", "value": report.numDeer},
            {"path": "/numBucks", "op": "Add", "value": report.numBucks},
            {"path": "/numHours", "op": "Add", "value": report.numHours},
            {"path": "/weaponUsed", "op": "Add", "value": report.weaponUsed},
            {
              "path": "/weatherRating",
              "op": "Add",
              "value": report.weatherRating
            },
            {
              "path": "/startDateTime",
              "op": "Add",
              "value": report.startDateTime
            },
            {"path": "/endDateTime", "op": "Add", "value": report.endDateTime},
            {"path": "/successTime", "op": "Add", "value": report.successTime},
            {"path": "/isSuccess", "op": "Add", "value": report.isSuccess},
          ]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<int?> postLike(Like like) async {
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/PostLike",
          data: {"personId": like.personId, "postId": like.postId});
      if (response.statusCode == 201) {
        // print(response.data);
        return response.data["id"];
      } else {
        // print(response.data);
        return null;
      }
    } catch (e) {
      // print(e);
      return null;
    }
  }

  static Future<bool> postLikeDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteLike?id=$id");
      if (response.statusCode == 200) {
        // print(response.data);
        return true;
      } else {
        // print(response.data);
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<int?> postComment(Comment comment) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/PostComment", data: {
        "personId": comment.personId,
        "postId": comment.postId,
        "body": comment.body,
        "isFlagged": true
      });
      if (response.statusCode == 201) {
        // print(response.data["id"]);
        return response.data["id"];
      } else {
        // print(response.data);
        return null;
      }
    } catch (e) {
      // print(e);
      return null;
    }
  }

  static Future<bool> postCommentDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteComment?id=$id");
      if (response.statusCode == 200) {
        // print(response.data);
        return true;
      } else {
        // print(response.data);
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<int?> postCommentReply(ReplyComment replyComment) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/PostCommentReply", data: {
        "personId": replyComment.personId,
        "postCommentId": replyComment.postCommentId,
        "body": replyComment.body,
        "isFlagged": true
      });
      if (response.statusCode == 201) {
        return response.data["id"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> postCommentReplyDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteCommentReply?id=$id");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> postShare(
      // String personId, String sharePersonId, int postId
      List<Map<String, dynamic>> share) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/PostShare", data: share
              //     [
              //   {
              //     "personId": personId,
              //     "sharePersonId": sharePersonId,
              //     "postId": postId
              //   }
              // ]
              );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> postAbuse(String personId, int postId) async {
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/PostAbuse?personId=$personId&postId=$postId");
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> blockUser(String personId, String blockPersonId) async {
    try {
      final response = await CustomHttp.getDio().post(Constant.baseUrl +
          "/PersonBlock?personId=$personId&blockPersonId=$blockPersonId");

      // print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<bool> editComment(int id, String value) async {
    // print("$id : $value");
    try {
      final response = await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/PatchComment?id=$id", data: [
        {"path": "/body", "op": "Add", "value": value}
      ]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  static Future<bool> editCommentReply(int id, String value) async {
    try {
      final response = await CustomHttp.getDio()
          .patch(Constant.baseUrl + "/PatchCommentReply?id=$id", data: [
        {"path": "/body", "op": "Add", "value": value}
      ]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
