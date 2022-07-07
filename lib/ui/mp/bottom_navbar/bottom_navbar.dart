import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
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
    Provider.of<CountyPostProvider>(context, listen: false)
        .setCountyId(userProvider.user.countyId);
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    List<County> _counties =
        Provider.of<CountyProvider>(context, listen: false).counties;
    for (County county in _counties) {
      if (county.id == userProvider.user.countyId) {
        weatherProvider.setCounty(county);
        userProvider.setUserCountyName(county.name);
        break;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .8],
          colors: [AppColors.secondaryColor, AppColors.primaryColor],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const PostPage(),
              const ReportPage(),
              WeatherPage(
                county: weatherProvider.county,
              ),
              const ShopPage(),
              const MyAccount()
            ],
          ),
          bottomNavigationBar: _bottomNavbar()),
    );
  }

  _bottomNavbar() {
    return Container(
        width: 428.w,
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        ...listOfIcons.map((e) => GestureDetector(
              onTap: (() => setState(() {
                    currentIndex = listOfIcons.indexOf(e);
                    _pageController.jumpToPage(listOfIcons.indexOf(e));
                  })),
              child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  height: 60.h,
                  width: 60.h,
                  child: SvgPicture.asset(
                    e,
                    height: 30.h,
                    width: 30.h,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    color: currentIndex == listOfIcons.indexOf(e)
                        ? AppColors.btnColor
                        : Colors.white,
                  )),
            ))
          ],
        ));
  }
}
