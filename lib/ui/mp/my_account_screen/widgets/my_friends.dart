import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/followers.dart';
import 'package:wisconsin_app/ui/mp/my_account_screen/widgets/following.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/tab_title.dart';

class MyFriends extends StatelessWidget {
  const MyFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: 70.h,
          title: const DefaultAppbar(title: "My Friends"),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(tabs: [
            Tab(
              child: TabTitle(title: "Following"),
            ),
            Tab(
              child: TabTitle(title: "Followers"),
            )
          ]),
        ),
        body: const TabBarView(children: [Following(), Followers()]),
      ),
    );
  }
}
