import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class RegionPostProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  List<Post> postsOfRegion = [];
  bool allPostLoaded = false;
  // int? _countyId;
  int? _regionId;
  DateTime? lastRecordTime;

  ApiStatus get apiStatus => _apiStatus;
  // int get countyId => _countyId!;
  int get regionId => _regionId!;

  // void setCountyId(int id) {
  //   _countyId = id;
  // }

  void setRegionId(int rId) {
    _regionId = rId;
  }

  void chnageRegion(String userId, int rId) {
    allPostLoaded = false;
    postsOfRegion = [];
    lastRecordTime = null;
    _regionId = rId;
    getMyRegionPosts(userId);
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
    postsOfRegion.insert(0, _post);
    notifyListeners();
  }

  void updatePost(Post _post) {
    for (int i = 0; i < postsOfRegion.length; i++) {
      if (_post.id == postsOfRegion[i].id) {
        postsOfRegion[i] = _post;
        break;
      }
    }
    notifyListeners();
  }

  void deletePost(Post _post) {
    int? index;
    for (int i = 0; i < postsOfRegion.length; i++) {
      if (_post.id == postsOfRegion[i].id) {
        index = i;
        break;
      }
    }
    if (index != null) {
      postsOfRegion.removeAt(index);
    }
    notifyListeners();
  }

  void reFreshData() {
    notifyListeners();
  }

  Future<void> getMyRegionPosts(String userId, {bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final postResponse = await PostService.getMyRegionPosts(userId, _regionId!);
    postResponse.when(success: (List<Post> postsList) async {
      postsOfRegion = postsList;
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
