import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class ContestFreeSubs extends StatelessWidget {
  const ContestFreeSubs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Contest",
          style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70.h,
      ),
      body: ViewModels.freeSubscription(
          context: context,
          userId: Provider.of<UserProvider>(context, listen: false).user.id),
    );
  }
}
