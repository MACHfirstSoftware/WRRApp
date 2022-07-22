import 'package:flutter/material.dart';
import 'package:wisconsin_app/models/user.dart';

class UserProvider with ChangeNotifier {
  UserProvider(User? loggedUser) {
    _user = loggedUser;
  }

  User? _user;
  User get user => _user!;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserCountyName(String value) {
    _user?.countyName = value;
  }

  void setUserRegionName(String value) {
    _user?.regionName = value;
  }

  void setUserProfile(String url) {
    _user?.profileImageUrl = url;
    notifyListeners();
  }
}
