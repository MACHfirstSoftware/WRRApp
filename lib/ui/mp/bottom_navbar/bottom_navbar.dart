import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/notification_model.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/notification_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/services/notification_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/my_account_page.dart';
import 'package:wisconsin_app/ui/mp/notifications/notification_page.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_page.dart';
import 'package:wisconsin_app/ui/mp/report_screen/report_main_page.dart';
import 'package:wisconsin_app/ui/mp/shop_screen/shop_page.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/weather_page.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/local_notification_api.dart';

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
  // debugPrint("onMessage BG :");
  // log("notification id : ${message.data["Id"]}");
  // log(message.notification != null ? "" : "NUll Noti");
  // log(message.notification?.body ?? "Null Body");
  // log(message.notification?.title ?? "Null Title");
  // _BottomNavBarState().initState();
  // WidgetsBinding.instance?.addPostFrameCallback((_) =>
  //     _BottomNavBarState().getNotification(int.parse(message.data["Id"])));
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int currentIndex = 0;
  bool inCurrentThisPage = true;
  late PageController _pageController;
  List<String> listOfIcons = [
    "assets/icons/news-feed.svg",
    "assets/icons/WRR-icon.svg",
    "assets/icons/weather.svg",
    "assets/icons/shop-bag.svg",
    "assets/icons/account.svg",
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<RegionPostProvider>(context, listen: false)
        .setRegionId(userProvider.user.regionId);
    Provider.of<ReportPostProvider>(context, listen: false)
        .setRegionId(userProvider.user.regionId);
    Provider.of<ContestProvider>(context, listen: false)
        .setRegionId(userProvider.user.regionId);
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    List<County> _counties =
        Provider.of<CountyProvider>(context, listen: false).counties;
    List<Region> _regions =
        Provider.of<RegionProvider>(context, listen: false).regions;
    Provider.of<NotificationProvider>(context, listen: false)
        .getMyNotifications(userProvider.user.id, isInit: true);
    for (County county in _counties) {
      if (county.id == userProvider.user.countyId) {
        weatherProvider.setCounty(county);
        userProvider.setUserCountyName(county.name);
        break;
      }
    }

    for (Region region in _regions) {
      if (region.id == userProvider.user.regionId) {
        userProvider.setUserRegionName(region.name);
        break;
      }
    }
    LocalNotificationApi.init();
    listenNotifications();
    // _init(userProvider.user);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _firebaseMessaging.getToken().then((value) {
      // print("--------------- FCM TOKEN --------------");
      // print(value);
      // print("----------------------------------------");
      UserService.updateUserFcmToken(userProvider.user.id, value);
    });
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        // debugPrint("onMessage:");
        // log("notification id : ${message.data["Id"]}");
        // log(message.notification != null ? "" : "NUll Noti");
        // log(message.notification?.body ?? "Null Body");
        // log(message.notification?.title ?? "Null Title");
        await getNotification(int.parse(message.data["Id"]));
        LocalNotificationApi.showNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            payload: message.data["Id"]);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        // debugPrint("onMessage:");
        // log("notification id : ${message.data["Id"]}");
        // log(message.notification != null ? "" : "NUll Noti");
        // log(message.notification?.body ?? "Null Body");
        // log(message.notification?.title ?? "Null Title");
        await getNotification(int.parse(message.data["Id"]));
        if (inCurrentThisPage) {
          inCurrentThisPage = false;
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationPage()))
              .then((value) => inCurrentThisPage = true);
        }
      },
    );
    super.initState();
  }

  getNotification(int notificationId) async {
    final res = await NotificationService.getAllNotifications(
        userId: Provider.of<UserProvider>(context, listen: false).user.id,
        notificationId: notificationId);
    res.when(
        success: (List<NotificationModelNew> data) {
          Provider.of<NotificationProvider>(context, listen: false)
              .setNotification(data.first);
        },
        failure: (NetworkExceptions err) {},
        responseError: (ResponseError err) {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              PostPage(),
              ReportPage(),
              WeatherPage(),
              ShopPage(),
              MyAccount()
            ],
          ),
        ),
        bottomNavigationBar: _bottomNavbar());
  }

  _bottomNavbar() {
    return Container(
        width: 428.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...listOfIcons.map((e) => GestureDetector(
                    onTap: (() => setState(() {
                          currentIndex = listOfIcons.indexOf(e);
                          _pageController.jumpToPage(listOfIcons.indexOf(e));
                        })),
                    child: SizedBox(
                        height: 70.h,
                        width: 70.h,
                        child: Center(
                          child: SizedBox(
                            height: 35.h,
                            width: 35.h,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                e,
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                                color: currentIndex == listOfIcons.indexOf(e)
                                    ? AppColors.btnColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )),
                  ))
            ],
          ),
        ));
  }

  void listenNotifications() {
    LocalNotificationApi.onNotifications.stream.listen(onClickNotification);
  }

  void onClickNotification(String? payload) {
    if (inCurrentThisPage) {
      inCurrentThisPage = false;
      Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotificationPage()))
          .then((value) => inCurrentThisPage = true);
    }
  }
}
