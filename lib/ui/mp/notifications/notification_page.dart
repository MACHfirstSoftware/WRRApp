import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context, listen: false).user;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .8],
          colors: [AppColors.secondaryColor, AppColors.primaryColor],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: 70.h,
          title: const DefaultAppbar(title: "Notifications"),
          centerTitle: true,
          elevation: 0,
        ),
      ),
    );
  }
}
