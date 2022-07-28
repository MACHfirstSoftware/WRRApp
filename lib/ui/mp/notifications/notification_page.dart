import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/notification.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/notification_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/mp/notifications/post_open_page.dart';
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

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _refreshController = RefreshController(initialRefresh: false);
    _refreshController2 = RefreshController(initialRefresh: false);
    if (Provider.of<NotificationProvider>(context, listen: false)
            .notificationsList ==
        null) {
      _init(isInit: true);
    }
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
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
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 0.h),
                    itemCount: model.notifications.length,
                    itemBuilder: (_, index) => _buildNotificationCard(
                        model.notifications[index], index),
                    separatorBuilder: (_, index) => _buildSeparator(),
                  ),
          );
        }));
  }

  _buildNotificationCard(NotificationModel _notification, int index) {
    return GestureDetector(
      onTap: () => _notificationClick(_notification, index),
      child: Container(
        height: 70.h,
        margin: EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 2.5.h),
        decoration: BoxDecoration(
            color: _notification.viewed ? Colors.transparent : Colors.white10,
            borderRadius: BorderRadius.circular(5.h)),
        child: Row(
          children: [
            Container(
                height: 60.h,
                width: 60.h,
                margin: EdgeInsets.symmetric(horizontal: 7.5.w),
                decoration: BoxDecoration(
                    color: AppColors.popBGColor,
                    borderRadius: BorderRadius.circular(10.h)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.h),
                  child: _notification.shareBy.imageLocation != null
                      ? SizedBox(
                          height: 60.h,
                          width: 60.h,
                          child: CachedNetworkImage(
                            imageUrl: _notification.shareBy.imageLocation!,
                            imageBuilder: (context, imageProvider) {
                              return Image(
                                image: imageProvider,
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                              );
                            },
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: SizedBox(
                                height: 10.h,
                                width: 10.h,
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                  color: AppColors.btnColor,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.btnColor,
                                size: 10.h),
                          ),
                        )
                      : SizedBox(
                          height: 40.h,
                          width: 40.h,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _notification.shareBy.firstName
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  _notification.shareBy.lastName
                                      .substring(0, 1)
                                      .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.btnColor,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
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
                  "${_notification.shareBy.code} shared ${_notification.postOwner.code}'s post with you",
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

  _buildSeparator() {
    return SizedBox(
      height: 5.h,
      child: Center(
        child: Divider(
          color: Colors.grey,
          thickness: 1.25.h,
        ),
      ),
    );
  }

  _notificationClick(NotificationModel notificationModel, int index) async {
    Provider.of<NotificationProvider>(context, listen: false).markAsRead(index);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PostOpenPage(notification: notificationModel)));
    // final res =
    // await NotificationService.notificationClick(id);
    // if (res) {
    //   Provider.of<NotificationProvider>(context, listen: false)
    //       .markAsRead(index);
    // }
  }
}
