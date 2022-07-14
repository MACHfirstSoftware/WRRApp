import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class CountyPostProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  List<Post> postsOfCounty = [];
  bool allCountyPostLoaded = false;
  int? _countyId;
  DateTime? lastRecordTime;

  ApiStatus get apiStatus => _apiStatus;
  int get countyId => _countyId!;

  void setCountyId(int id) {
    _countyId = id;
  }

  void chnageCounty(String userId, int id) {
    allCountyPostLoaded = false;
    postsOfCounty = [];
    lastRecordTime = null;
    _countyId = id;
    getMyCountyPosts(userId);
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
    postsOfCounty.insert(0, _post);
    notifyListeners();
  }

  void updatePost(Post _post) {
    for (int i = 0; i < postsOfCounty.length; i++) {
      if (_post.id == postsOfCounty[i].id) {
        postsOfCounty[i] = _post;
        break;
      }
    }
    notifyListeners();
  }

  void deletePost(Post _post) {
    postsOfCounty.remove(_post);
    notifyListeners();
  }

  void reFreshData() {
    notifyListeners();
  }

  Future<void> getMyCountyPosts(String userId, {bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final postResponse = await PostService.getMyCountyPosts(userId, _countyId!);
    postResponse.when(success: (List<Post> postsList) async {
      postsOfCounty = postsList;
      if (postsList.isNotEmpty) {
        lastRecordTime = postsList.last.createdOn;
      }
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
