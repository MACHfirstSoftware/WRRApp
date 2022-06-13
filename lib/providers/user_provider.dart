import 'package:flutter/material.dart';
import 'package:wisconsin_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User get user => _user!;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserCountyName(String value) {
    _user?.countyName = value;
  }
}
