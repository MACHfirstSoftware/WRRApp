import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class ReportPostProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  bool allPostLoaded = false;
  List<Post> posts = [];
  int? _regionId;
  int get regionId => _regionId!;
  ApiStatus get apiStatus => _apiStatus;

  void setRegionId(int rId) {
    _regionId = rId;
  }

  void chnageRegion(String userId, int rId) {
    allPostLoaded = false;
    posts = [];
    _regionId = rId;
    getReportPosts(userId);
  }

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
    posts.insert(0, _post);
    notifyListeners();
  }

  void updatePost(Post _post) {
    // print("Provider update called");
    for (int i = 0; i < posts.length; i++) {
      // print("Loop working : $i");
      if (_post.id == posts[i].id) {
        // print("fount post");
        posts[i] = _post;
        break;
      }
    }
    notifyListeners();
  }

  void deletePost(Post _post) {
    int? index;
    for (int i = 0; i < posts.length; i++) {
      if (_post.id == posts[i].id) {
        index = i;
        break;
      }
    }
    if (index != null) {
      posts.removeAt(index);
    }
    notifyListeners();
  }

  void reFreshData() {
    notifyListeners();
  }

  Future<void> getReportPosts(String userId, {bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final postResponse = await PostService.getReportPosts(userId, _regionId!);
    postResponse.when(success: (List<Post> postsList) async {
      posts = postsList;
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
