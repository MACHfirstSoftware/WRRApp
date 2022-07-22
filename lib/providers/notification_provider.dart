import 'package:flutter/material.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/notification.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/notification_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class NotificationProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  bool _isAllViewed = false;
  List<NotificationModel>? _notifications;

  ApiStatus get apiStatus => _apiStatus;
  bool get isAllViewed => _isAllViewed;
  List<NotificationModel> get notifications => _notifications!;

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

  bool checkUnread() {
    for (final noti in _notifications!) {
      if (!noti.viewed) {
        _isAllViewed = false;
        break;
      } else {
        _isAllViewed = true;
      }
    }
    return _isAllViewed;
  }

  Future<void> getMyNotifications(String userId, {bool isInit = false}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final notificationResponse =
        await NotificationService.getNotifications(userId);
    notificationResponse.when(
        success: (List<NotificationModel> notificationList) async {
      _notifications = notificationList;
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
