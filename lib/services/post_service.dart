import 'package:dio/dio.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/comment.dart';
import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/reply_comment.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/utils/api_results/api_result.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class PostService {
  static Future<ApiResult<List<Post>>> getMyWRRPosts(String userId,
      {String? lastRecordTime}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId" +
          (lastRecordTime != null ? "?lastRecordTime=$lastRecordTime" : ""));
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
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Post>>> getMyCountyPosts(
      String userId, int countyId,
      {String? lastRecordTime}) async {
    try {
      final response = await CustomHttp.getDio().get(Constant.baseUrl +
          "/Post/$userId" +
          (lastRecordTime != null
              ? "?lastRecordTime=$lastRecordTime&countyId=$countyId"
              : "?countyId=$countyId"));
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
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<int>> postPublish(
      Map<String, dynamic> postDetails) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/Post", data: postDetails);
      if (response.statusCode == 201) {
        print(response.data);
        return ApiResult.success(data: response.data["id"] as int);
      } else {
        print(response.data);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<ApiResult<List<Media>>> addPostImage(
      Map<String, dynamic> postImageDetails) async {
    // log(postImageDetails.toString());
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/PostImage",
          data: postImageDetails,
          options: Options(receiveTimeout: 60000));
      print(response);
      if (response.statusCode == 200) {
        print(response.data);
        List<dynamic> res = response.data["media"];
        return ApiResult.success(
            data: res
                .map((d) => Media.fromJson(d as Map<String, dynamic>))
                .toList());
      } else {
        print(response.data);
        return ApiResult.responseError(
            responseError: ResponseError(
                error: "Something went wrong!",
                errorCode: response.statusCode ?? 0));
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future<int?> postLike(Like like) async {
    try {
      final response = await CustomHttp.getDio().post(
          Constant.baseUrl + "/PostLike",
          data: {"personId": like.personId, "postId": like.postId});
      if (response.statusCode == 201) {
        print(response.data);
        return response.data["id"];
      } else {
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> postLikeDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteLike?id=$id");
      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        print(response.data);
        return false;
      }
    } catch (e) {
      print(e);
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
        print(response.data["id"]);
        return response.data["id"];
      } else {
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> postCommentDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteComment?id=$id");
      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        print(response.data);
        return false;
      }
    } catch (e) {
      print(e);
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
        print(response.data["id"]);
        return response.data["id"];
      } else {
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> postCommentReplyDelete(int id) async {
    try {
      final response = await CustomHttp.getDio()
          .delete(Constant.baseUrl + "/DeleteCommentReply?id=$id");
      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        print(response.data);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postShare(
      String postOwnerId, String sharePersonId, int postId) async {
    try {
      final response = await CustomHttp.getDio()
          .post(Constant.baseUrl + "/PostCommentReply", data: [
        {
          "personId": postOwnerId,
          "sharePersonId": sharePersonId,
          "postId": postId
        }
      ]);
      if (response.statusCode == 201) {
        print(response.data);
        return true;
      } else {
        print(response.data);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
