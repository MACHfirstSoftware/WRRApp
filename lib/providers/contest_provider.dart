import 'package:flutter/foundation.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/super_region.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class CustomSuperRegion {
  final SuperRegion superRegion;
  final String weapon;

  CustomSuperRegion({required this.superRegion, required this.weapon});
}

class ContestProvider with ChangeNotifier {
  // final List<SuperRegion> _superRegions = [
  //   SuperRegion(id: 1, name: "North"),
  //   SuperRegion(id: 2, name: "South"),
  // ];

  final List<CustomSuperRegion> _customSuperRegions = [
    CustomSuperRegion(
        superRegion: SuperRegion(id: 1, name: "North"), weapon: "G"),
    CustomSuperRegion(
        superRegion: SuperRegion(id: 1, name: "North"), weapon: "B"),
    CustomSuperRegion(
        superRegion: SuperRegion(id: 2, name: "South"), weapon: "G"),
    CustomSuperRegion(
        superRegion: SuperRegion(id: 2, name: "South"), weapon: "B"),
  ];

  // List<SuperRegion> get superRegions => _superRegions;
  List<CustomSuperRegion> get customSuperRegions => _customSuperRegions;

  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  CustomSuperRegion _customSuperRegion = CustomSuperRegion(
      superRegion: SuperRegion(id: 1, name: "North"), weapon: "G");
  // int _superRegionId = 1;
  int? _regionId;
  List<Post> _contestPosts = [];
  List<Post> get contestPosts => _contestPosts;
  ApiStatus get apiStatus => _apiStatus;
  // int get superRegionId => _superRegionId;
  CustomSuperRegion get customSuperRegion => _customSuperRegion;

  void chnageSuperRegion(String userId, int regionId, CustomSuperRegion value) {
    _contestPosts = [];
    _customSuperRegion = value;
    getContestPosts(userId);
  }

  void setRegionId(int rId) {
    _regionId = rId;
  }

  void chnageRegion(String userId, int rId) {
    _contestPosts = [];
    _regionId = rId;
    getContestPosts(userId);
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

  Future<void> getContestPosts(String userId, {bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final postResponse =
        await PostService.getContest(userId, _regionId!, _customSuperRegion);
    postResponse.when(success: (List<Post> postsList) async {
      _contestPosts = postsList;
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
