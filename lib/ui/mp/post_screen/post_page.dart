import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_county_posts/my_county_posts.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_wrr_posts/my_wrr_posts.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/report_page_appbar.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const ReportPageAppBar(),
          elevation: 0,
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
          bottom: const TabBar(tabs: [
            Tab(
              text: "My WRR",
            ),
            Tab(
              text: "My County",
            ),
          ]),
        ),
        body: const TabBarView(children: [MyWRRPosts(), MyCountyPosts()]),
      ),
    );
  }
}