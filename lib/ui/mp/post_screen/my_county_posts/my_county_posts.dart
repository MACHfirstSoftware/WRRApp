import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_county_posts/widgets/my_county_post_appbar.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';

class MyCountyPosts extends StatefulWidget {
  const MyCountyPosts({Key? key}) : super(key: key);

  @override
  State<MyCountyPosts> createState() => _MyCountyPostsState();
}

class _MyCountyPostsState extends State<MyCountyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const MyCountyPostAppBar(),
          elevation: 0,
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (_, index) {
                return const PostView();
              }),
        ));
  }
}
