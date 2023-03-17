import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class WRRPostProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  List<Post> postsOfWRR = [];

  ApiStatus get apiStatus => _apiStatus;

  void setBusy() {
    _apiStatus = ApiStatus.isBusy;
    notifyListeners();
  }

  void setError() {
    _apiStatus = ApiStatus.isError;
    notifyListeners();
  }

  void setIdle() {
    _apiStatus = ApiStatus.isIdle;
    notifyListeners();
  }

  void setInitial() {
    _apiStatus = ApiStatus.isInitial;
    errorMessage = '';
    notifyListeners();
  }

  void addingNewPost(Post _post) {
    postsOfWRR.insert(0, _post);
    notifyListeners();
  }

  void updatePost(Post _post) {
    for (int i = 0; i < postsOfWRR.length; i++) {
      if (_post.id == postsOfWRR[i].id) {
        postsOfWRR[i] = _post;
        break;
      }
    }
    notifyListeners();
  }

  void deletePost(Post _post) {
    int? index;
    for (int i = 0; i < postsOfWRR.length; i++) {
      if (_post.id == postsOfWRR[i].id) {
        index = i;
        break;
      }
    }
    if (index != null) {
      postsOfWRR.removeAt(index);
    }
    notifyListeners();
  }

  void reFreshData() {
    notifyListeners();
  }

  Future<void> getMyWRRPosts(String userId, {bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final postResponse = await PostService.getMyWRRPosts(userId);
    postResponse.when(success: (List<Post> postsList) async {
      postsOfWRR = postsList;
      errorMessage = '';
      setIdle();
    }, failure: (NetworkExceptions error) {
      errorMessage = NetworkExceptions.getErrorMessage(error);
      setError();
    }, responseError: (ResponseError responseError) {
      errorMessage = responseError.error;
      setError();
    });
  }
}
