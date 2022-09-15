import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/notification_model.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';

class PostOpenPage extends StatefulWidget {
  final NotificationModelNew notification;
  const PostOpenPage({Key? key, required this.notification}) : super(key: key);

  @override
  State<PostOpenPage> createState() => _PostOpenPageState();
}

class _PostOpenPageState extends State<PostOpenPage> {
  @override
  void initState() {
    // _notificationMarkAsRead();
    super.initState();
  }

  // _notificationMarkAsRead() async {
  //   await NotificationService.notificationClick(widget.notification.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: DefaultAppbar(
            title: "${widget.notification.post?.personCode}'s Post"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: PostView(post: widget.notification.post!),
      )),
    );
  }
}
