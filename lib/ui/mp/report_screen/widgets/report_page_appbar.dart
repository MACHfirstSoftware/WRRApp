import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/notification_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/contest_main_page.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/contest_free_subs.dart';
import 'package:wisconsin_app/ui/mp/notifications/notification_page.dart';
import 'package:wisconsin_app/ui/mp/post_screen/search_page/search_hunters.dart';
import 'package:wisconsin_app/widgets/view_map.dart';

class ReportPageAppBar extends StatefulWidget {
  final bool isReports;
  const ReportPageAppBar({Key? key, this.isReports = true}) : super(key: key);

  @override
  State<ReportPageAppBar> createState() => _ReportPageAppBarState();
}

class _ReportPageAppBarState extends State<ReportPageAppBar> {
  // late List<County> _counties;
  late List<Region> _regions;

  @override
  void initState() {
    // _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _regions = Provider.of<RegionProvider>(context, listen: false).regions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Stack(
        children: [
          if (!widget.isReports)
            Positioned(
                bottom: 10.h, left: 0.w, child: _buildDropMenu(userProvider)),
          Positioned(
              bottom: 10.h,
              left: widget.isReports ? 0.w : 40.w,
              child: GestureDetector(
                onTap: (() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SearchHunters()));
                }),
                child: SvgPicture.asset(
                  'assets/icons/search.svg',
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  height: 30.h,
                  width: 30.h,
                  color: Colors.white,
                ),
              )),
          if (!widget.isReports)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 35.h,
                child: SvgPicture.asset(
                  'assets/icons/WRR.svg',
                  alignment: Alignment.center,
                  height: 35.h,
                ),
              ),
            ),
          if (widget.isReports)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 250.w,
                  height: 30.h,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        "WRR Premium",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ))),
            ),
          Positioned(
              bottom: 10.h,
              right: 40.w,
              child: GestureDetector(
                onTap: () {
                  // final _subscriptionStatus =
                  //     Provider.of<RevenueCatProvider>(context, listen: false)
                  //         .subscriptionStatus;
                  // // print(_subscriptionStatus);
                  // if (_subscriptionStatus == SubscriptionStatus.premium) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ContestMainPage()));
                  // } else {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) => const ContestFreeSubs()));
                  // }
                },
                child: SvgPicture.asset(
                  'assets/icons/trophy-bold.svg',
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  height: 30.h,
                  width: 30.h,
                  color: Colors.white,
                ),
              )),
          Positioned(
              bottom: 10.h,
              right: 0.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationPage()));
                },
                child: Consumer<NotificationProvider>(
                    builder: (context, model, _) {
                  return Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                        height: 27.5.h,
                        width: 27.5.h,
                        color: Colors.white,
                      ),
                      if (!model.isAllViewed)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: 15.5.h,
                            width: 15.5.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(7.25.h)),
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                model.unReadCount.toString(),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                }),
              )),
        ],
      ),
    );
  }

  _buildDropMenu(UserProvider userProvider) {
    return PopupMenuButton(
      child: SvgPicture.asset(
        'assets/icons/location.svg',
        height: 30.h,
        width: 30.h,
        fit: BoxFit.fill,
        alignment: Alignment.center,
        color: Colors.white,
      ),
      color: AppColors.popBGColor,
      itemBuilder: (context) => [
        PopupMenuItem<Region>(
          value: Region(id: -1, name: "View Map"),
          child: SizedBox(
              width: 200.w,
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    height: 45.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20.w)),
                    child: SizedBox(
                        height: 25.h,
                        width: 120.w,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text("View Map",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.btnColor))))),
              )),
        ),
        ..._regions.map((region) => PopupMenuItem<Region>(
            value: region,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: region.name == userProvider.user.regionName
                    ? const Icon(
                        Icons.check,
                        color: AppColors.btnColor,
                      )
                    : null,
                title: Text(
                  region.name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (Region value) {
        if (value.id == -1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ViewMap()));
        } else {
          if (userProvider.user.regionName != value.name) {
            User _user = userProvider.user;
            _user.regionName = value.name;
            userProvider.setUser(_user);
            Provider.of<RegionPostProvider>(context, listen: false)
                .chnageRegion(_user.id, value.id);
            // Provider.of<ReportPostProvider>(context, listen: false)
            //     .chnageRegion(_user.id, value.id);
            // Provider.of<AllPostProvider>(context, listen: false)
            //     .chnageRegion(_user.id, value.id);
            Provider.of<ContestProvider>(context, listen: false)
                .chnageRegion(_user.id, value.id);
          }
        }
      },
    );
  }
}
