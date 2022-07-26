import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/post_screen/all_posts/all_post_page.dart';
import 'package:wisconsin_app/ui/mp/post_screen/create_update_post/create_post.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_region_posts/my_region_posts.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_wrr_posts/my_wrr_posts.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/report_page_appbar.dart';
import 'package:wisconsin_app/widgets/tab_title.dart';

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
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: const ReportPageAppBar(isReports: false),
          elevation: 0,
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
          bottom: const TabBar(tabs: [
            Tab(
              child: TabTitle(title: "All"),
            ),
            Tab(
              child: TabTitle(title: "My WRR"),
            ),
            Tab(
              child: TabTitle(title: "My Region"),
            ),
          ]),
        ),
        body: const TabBarView(
            children: [AllPostsPage(), MyWRRPosts(), MyRegionPosts()]),
        floatingActionButton: FloatingActionButton(
            heroTag: "1",
            backgroundColor: AppColors.btnColor,
            child: Icon(
              Icons.add,
              size: 30.h,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NewPost(
                        // isWRRPost: true,
                        )),
              );
            }),
      ),
    );
  }
}
