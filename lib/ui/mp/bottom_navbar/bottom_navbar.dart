import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/notification_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/my_account_page.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_page.dart';
import 'package:wisconsin_app/ui/mp/report_screen/report_main_page.dart';
import 'package:wisconsin_app/ui/mp/shop_screen/shop_page.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/weather_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
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
    // Provider.of<AllPostProvider>(context, listen: false)
    //     .setRegionId(userProvider.user.regionId);
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
    // _init(userProvider.user);
    super.initState();
  }

  // _init(User _user) async {
  //   print("APP USER ID FROM USER : ${_user.appUserId}");
  //   // if (_user.appUserId != null) {
  //   //   final res = await PurchasesService.login(appUserId: _user.appUserId!);
  //   //   if (res) {
  //   //     Provider.of<RevenueCatProvider>(context, listen: false)
  //   //         .setSubscriptionStatus(SubscriptionStatus.premium, isInit: true);
  //   //   }
  //   // } else {
  //   //   Provider.of<RevenueCatProvider>(context, listen: false)
  //   //       .setSubscriptionStatus(SubscriptionStatus.free, isInit: true);
  //   // }
  // }

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
}
