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
  int lastPostId = 0;

  ApiStatus get apiStatus => _apiStatus;
  int get countyId => _countyId!;

  void setCountyId(int id) {
    _countyId = id;
  }

  void chnageCounty(int id) {
    allCountyPostLoaded = false;
    postsOfCounty = [];
    lastPostId = 0;
    _countyId = id;
    getMyCountyPosts();
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

  Future<void> getMyCountyPosts({bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final postResponse =
        await PostService.getMyCountyPosts(lastPostId, _countyId!);
    postResponse.when(success: (List<Post> postsList) async {
      postsOfCounty = postsList;
      if (postsList.isNotEmpty) {
        lastPostId = postsList.last.id;
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
