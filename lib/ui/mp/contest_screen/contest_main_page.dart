import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/leaderboard.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/contest_appbar.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/rules_page.dart';

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
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
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
                  ])),
          body: const TabBarView(children: [
            Leaderboard(),
            // SizedBox(
            //   child: Padding(
            //     padding: EdgeInsets.all(10.0),
            //     child: Text(
            //         "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
            //         style: TextStyle(color: Colors.grey, fontSize: 12)),
            //   ),
            // ),
            RulesPage(),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
          ])),
    );
  }
}
