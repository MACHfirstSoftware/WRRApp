import 'package:flutter/material.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/notification_model.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/services/notification_service.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

class NotificationProvider with ChangeNotifier {
  ApiStatus _apiStatus = ApiStatus.isInitial;
  String errorMessage = '';
  bool _isAllViewed = true;
  bool allLoaded = false;
  int unReadCount = 0;
  List<NotificationModelNew> _notifications = [];

  ApiStatus get apiStatus => _apiStatus;
  bool get isAllViewed => _isAllViewed;
  List<NotificationModelNew> get notifications => _notifications;
  List<NotificationModelNew>? get notificationsList =>
      _notifications.isEmpty ? null : _notifications;

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

  void checkUnread() {
    unReadCount = 0;
    if (_notifications.isEmpty) {
      _isAllViewed = true;
    } else {
      _isAllViewed = true;
      for (final noti in _notifications) {
        if (!noti.viewed) {
          _isAllViewed = false;
          unReadCount++;
        }
      }
    }
  }

  void markAsRead(NotificationModelNew noti) {
    for (var element in _notifications) {
      if (element.id == noti.id) {
        element.viewed = true;
      }
    }
    // _notifications[index].viewed = true;
    checkUnread();
    notifyListeners();
  }

  void setNotification(NotificationModelNew data) {
    _notifications.insert(0, data);
    checkUnread();
    notifyListeners();
  }

  void addMoreNotification(List<NotificationModelNew> data) {
    _notifications.addAll(data);
    checkUnread();
    notifyListeners();
  }

  Future<void> getMyNotifications(String userId,
      {bool isInit = false,
      String? lastRecordTime,
      int? notificationId}) async {
    isInit ? _apiStatus = ApiStatus.isBusy : setBusy();
    final notificationResponse = await NotificationService.getAllNotifications(
        userId: userId,
        lastRecordTime: lastRecordTime,
        notificationId: notificationId);
    notificationResponse.when(
        success: (List<NotificationModelNew> notificationList) async {
      _notifications = notificationList;
      checkUnread();
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
