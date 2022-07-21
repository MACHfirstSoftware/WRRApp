import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/leaderboard.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/contest_appbar.dart';

class ContestMainPage extends StatefulWidget {
  const ContestMainPage({Key? key}) : super(key: key);

  @override
  State<ContestMainPage> createState() => _ContestMainPageState();
}

class _ContestMainPageState extends State<ContestMainPage> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: ContestAppBar(tabIndex: tabIndex),
            elevation: 0,
            toolbarHeight: 70.h,
            automaticallyImplyLeading: false,
            bottom: TabBar(
                onTap: (int? index) {
                  setState(() {
                    tabIndex = index!;
                  });
                },
                tabs: [
                  Tab(
                    child: Icon(
                      Icons.leaderboard_rounded,
                      size: 25.h,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.rule_rounded,
                      size: 25.h,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.add_chart_rounded,
                      size: 25.h,
                      color: Colors.white,
                    ),
                  ),
                ]),
          ),
          body: const TabBarView(children: [
            Leaderboard(),
            SizedBox(),
            SizedBox(),
          ]),
        ),
      ),
    );
  }
}
