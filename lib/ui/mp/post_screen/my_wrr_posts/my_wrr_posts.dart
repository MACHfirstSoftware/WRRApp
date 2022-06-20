import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_wrr_posts/widgets/my_wrr_post_appbar.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';

class MyWRRPosts extends StatefulWidget {
  const MyWRRPosts({Key? key}) : super(key: key);

  @override
  State<MyWRRPosts> createState() => _MyWRRPostsState();
}

class _MyWRRPostsState extends State<MyWRRPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const MyWRRPostAppBar(),
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
