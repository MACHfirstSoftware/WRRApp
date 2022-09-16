import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/notification_model.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/notification_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/notification_service.dart';
import 'package:wisconsin_app/ui/mp/notifications/post_open_page.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late RefreshController _refreshController2;
  late User _user;
  late ScrollController _scrollController;
  String? _lastRecordTime;
  bool onLoading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _refreshController = RefreshController(initialRefresh: false);
    _refreshController2 = RefreshController(initialRefresh: false);
    if (Provider.of<NotificationProvider>(context, listen: false)
            .notificationsList ==
        null) {
      _init(isInit: true);
    }
    _scrollController.addListener(() async {
      final notiProvider =
          Provider.of<NotificationProvider>(context, listen: false);

      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          _scrollController.position.atEdge &&
          !notiProvider.allLoaded &&
          notiProvider.notifications.length > 9) {
        _lastRecordTime = notiProvider.notifications.last.createdOn;
        setState(() {
          onLoading = true;
        });
        final postResponse = await NotificationService.getAllNotifications(
            userId: _user.id, lastRecordTime: _lastRecordTime);
        postResponse.when(success: (List<NotificationModelNew> notiList) async {
          notiProvider.addMoreNotification(notiList);
          if (notiList.length < 10) {
            notiProvider.allLoaded = true;
          }
          setState(() {
            onLoading = false;
          });
        }, failure: (NetworkExceptions error) {
          setState(() {
            onLoading = false;
          });
        }, responseError: (ResponseError responseError) {
          setState(() {
            onLoading = false;
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    _refreshController2.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _init({bool isInit = false}) async {
    await Provider.of<NotificationProvider>(context, listen: false)
        .getMyNotifications(_user.id, isInit: isInit);
  }

  Future<void> _onRefresh() async {
    Provider.of<NotificationProvider>(context, listen: false).allLoaded = false;
    onLoading = false;
    await _init(isInit: true);
    _refreshController.refreshCompleted();
    _refreshController2.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: 70.h,
          title: const DefaultAppbar(title: "Notifications"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer<NotificationProvider>(builder: (context, model, _) {
          if (model.apiStatus == ApiStatus.isBusy) {
            return ViewModels.buildLoader();
          }
          if (model.apiStatus == ApiStatus.isError) {
            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: _onRefresh,
                header: const WaterDropMaterialHeader(
                  backgroundColor: AppColors.popBGColor,
                  color: AppColors.btnColor,
                ),
                child: ViewModels.buildErrorWidget(model.errorMessage, _init));
          }

          return SmartRefresher(
              controller: _refreshController2,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _onRefresh,
              header: const WaterDropMaterialHeader(
                backgroundColor: AppColors.popBGColor,
                color: AppColors.btnColor,
              ),
              child: model.notifications.isEmpty
                  ? ViewModels.postEmply()
                  // : ListView.separated(
                  //     controller: _scrollController,
                  //     padding: EdgeInsets.symmetric(vertical: 0.h),
                  //     itemCount: model.notifications.length,
                  //     itemBuilder: (_, index) => _buildNotificationCard(
                  //         model.notifications[index], index),
                  //     separatorBuilder: (_, index) => _buildSeparator(),
                  //   ),
                  : ListView(
                      controller: _scrollController,
                      children: [
                        ...model.notifications
                            .map((noti) => _buildNotificationCard(noti))
                            .toList(),
                        Container(
                          color: Colors.transparent,
                          height: 5.h,
                          width: 428.w,
                          child: onLoading
                              ? const LinearProgressIndicator()
                              : null,
                        ),
                        if (model.allLoaded)
                          Padding(
                            padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
                            child: Text(
                              "No more data",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ],
                    ));
        }));
  }

  _buildNotificationCard(NotificationModelNew _notification) {
    return GestureDetector(
      onTap: () => _notificationClick(_notification),
      child: Container(
        height: 75.h,
        margin: EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: _notification.viewed ? Colors.transparent : Colors.white10,
            borderRadius: BorderRadius.circular(5.h)),
        child: Row(
          children: [
            Container(
                alignment: Alignment.center,
                height: 60.h,
                width: 60.h,
                margin: EdgeInsets.symmetric(horizontal: 7.5.w),
                decoration: BoxDecoration(
                    color: AppColors.popBGColor,
                    borderRadius: BorderRadius.circular(10.h)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.h),
                  child: SizedBox(
                    height: 25.h,
                    width: 25.h,
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        _notification.type == "Like"
                            ? Icons.thumb_up_alt_rounded
                            : _notification.type == "Follow"
                                ? Icons.handshake_rounded
                                : Icons.comment_rounded,
                        color: AppColors.btnColor,
                      ),
                    ),
                  ),
                )),
            Expanded(
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                height: 50.h,
                child: Text(
                  _notification.notification,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              width: 7.5.w,
            )
          ],
        ),
      ),
    );
  }

  _notificationClick(NotificationModelNew notificationModel) async {
    Provider.of<NotificationProvider>(context, listen: false)
        .markAsRead(notificationModel);
    NotificationService.notificationClick(notificationModel.id);
    if (notificationModel.post != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PostOpenPage(notification: notificationModel)));
    }
  }
}
