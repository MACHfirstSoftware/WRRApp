import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisconsin_app/ui/landing/sign_in_page/sign_in_page.dart';
import 'package:wisconsin_app/ui/mp/dashboard_screen/dashboard.dart';

class BottomNavBar extends StatefulWidget {
  final String? userName;
  const BottomNavBar({Key? key, this.userName}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // int _selectedIndex = 0;
  int currentIndex = 0;
  late PageController _pageController;

  List<String> listOfIcons = [
    "assets/icons/news-feed.svg",
    "assets/icons/weather.svg",
    "assets/icons/shop-bag.svg",
    "assets/icons/account.svg",
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
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    widget.userName ?? "",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  GestureDetector(
                    onTap: () => _doLogout(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.h,
                      width: 190.w,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF23A02),
                          borderRadius: BorderRadius.circular(5.w)),
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
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

  // void _onItemTapped(int index) {
  //   setState(() {
  //     // _selectedIndex = index;
  //   });
  //   _pageController.jumpToPage(index);
  // }

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
                  // child: TweenAnimationBuilder<Color>(
                  //     duration: const Duration(milliseconds: 1500),
                  //     tween: Tween<Color>(
                  //         begin: currentIndex == listOfIcons.indexOf(e)
                  //             ? Colors.white
                  //             : const Color(0xFFF23A02),
                  //         end: currentIndex == listOfIcons.indexOf(e)
                  //             ? const Color(0xFFF23A02)
                  //             : Colors.white),
                  //     child: Image.asset(
                  //       e,
                  //       height: 30.w,
                  //       width: 30.w,
                  //       // fit: BoxFit.fill,
                  //     ),
                  //     builder: (BuildContext _, Color value, Widget? child) {
                  //       return ColorFiltered(
                  //           child: child,
                  //           colorFilter:
                  //               ColorFilter.mode(value, BlendMode.modulate));
                  //     }),
                  // child: AnimatedContainer(
                  //     duration: const Duration(milliseconds: 1500),
                  //     curve: Curves.fastLinearToSlowEaseIn,
                  // width: 60.w,
                  // height: 50.h,
                  //     decoration: BoxDecoration(
                  // color: currentIndex == listOfIcons.indexOf(e)
                  //     ? const Color(0xFFF23A02)
                  //     : Colors.transparent,
                  //       // borderRadius: BorderRadius.circular(15.w),
                  //     ),
                  // child: Image.asset(
                  //   e,
                  //   height: 30.w,
                  //   width: 30.w,
                  //   // fit: BoxFit.fill,
                  // )
                  //     // Icon(
                  //     //   e,
                  //     //   size: 30.w,
                  //     //   color: Colors.white,
                  //     // ),
                  //     ),
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
                            ? const Color(0xFFF23A02)
                            : Colors.white,
                      )),
                ))
          ],
        )));
  }

  _doLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false);
  }
}
