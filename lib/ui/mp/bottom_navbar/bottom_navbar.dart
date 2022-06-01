import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/dashboard.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  int currentIndex = 0;
  late PageController _pageController;

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const DashBorad(),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.blue,
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.green,
              child: SizedBox(
                  height: 50.w, width: 50.w, child: Icon(LineIcons.viber)),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavbar()
        // Container(
        //   height: 70.h,
        //   width: 428.w,
        //   decoration: BoxDecoration(
        //       // color: const Color(0xFF262626),
        //       color: Colors.white,
        //       boxShadow: [
        //         BoxShadow(blurRadius: 20.0, color: Colors.black.withOpacity(.1))
        //       ]),
        //   child: SafeArea(
        //       child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        //     child: GNav(
        //       curve: Curves.easeInCubic,
        //       rippleColor: Colors.blue,
        //       hoverColor: Colors.redAccent,
        //       gap: 35.w,
        //       activeColor: const Color(0xFFF23A02),
        //       iconSize: 25.w,
        //       duration: const Duration(microseconds: 500),
        //       tabBackgroundColor: Colors.white,
        //       tabActiveBorder: Border.all(color: Colors.grey),
        //       color: Colors.green,
        //       haptic: false,
        //       tabs: [
        //         const GButton(
        //           icon: Icons.home,
        //           text: 'HOME',
        //           iconColor: Colors.purple,
        //           // leading: SvgPicture.asset("assets/icons/nexagon.svg"),
        //         ),
        //         GButton(
        //           icon: Icons.home,
        //           iconColor: Colors.white,
        //           // leading: SvgPicture.asset("assets/icons/accuracy.svg"),
        //         ),
        //         GButton(
        //           icon: Icons.home,
        //           iconColor: Colors.white,
        //           leading: SizedBox(
        //               height: 24.w,
        //               width: 24.w,
        //               child:
        //                   SvgPicture.asset("assets/icons/icons8-verge-24.svg")),
        //         ),
        //         GButton(
        //           icon: Icons.home,
        //           iconColor: Colors.red,
        //           leading: Container(
        //             height: 30.w,
        //             width: 30.w,
        //             color: Colors.red,
        //           ),
        //         ),
        //       ],
        //       selectedIndex: _selectedIndex,
        //       onTabChange: _onItemTapped,
        //     ),
        //   )),
        // ),
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  _bottomNavbar() {
    return Container(
        width: 428.w,
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: 60.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: currentIndex == listOfIcons.indexOf(e)
                          ? const Color(0xFFF23A02)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15.w),
                    ),
                    child: Icon(
                      e,
                      size: 30.w,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        )));
  }
}
