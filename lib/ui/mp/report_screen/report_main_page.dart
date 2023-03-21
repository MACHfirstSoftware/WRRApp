import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/mp/report_screen/create_update_report/create_report_post.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/report_content_page.dart';
import 'package:wisconsin_app/ui/mp/report_screen/widgets/report_page_appbar.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with WidgetsBindingObserver {
  // late bool isPremium;
  bool keyboardIsOpen = false;
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    // isPremium = Provider.of<UserProvider>(context, listen: false)
    //     .user
    //     .subscriptionPerson![0]
    //     .subscriptionApiModel
    //     .isPremium;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != keyboardIsOpen) {
      setState(() {
        keyboardIsOpen = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _subscriptionStatus =
        Provider.of<RevenueCatProvider>(context).subscriptionStatus;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const ReportPageAppBar(),
        elevation: 0,
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
      ),
      body: _subscriptionStatus == SubscriptionStatus.premium
          ? const ReportContents()
          : ViewModels.freeSubscription(
              context: context,
              userId:
                  Provider.of<UserProvider>(context, listen: false).user.id),
      // floatingActionButton: _subscriptionStatus == SubscriptionStatus.premium
      //     ? Visibility(
      //         visible: !keyboardIsOpen,
      //         child: FloatingActionButton(
      //             heroTag: "2",
      //             backgroundColor: AppColors.btnColor,
      //             child: Icon(
      //               Icons.add,
      //               size: 30.h,
      //             ),
      //             onPressed: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                     builder: (context) => const NewReportPost()),
      //               );
      //             }),
      //       )
      //     : null,
    );
  }
}
