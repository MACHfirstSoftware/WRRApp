import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/contest_page.dart';
import 'package:wisconsin_app/ui/mp/notifications/notification_page.dart';
import 'package:wisconsin_app/ui/mp/post_screen/search_page/search_hunters.dart';

class ReportPageAppBar extends StatefulWidget {
  const ReportPageAppBar({Key? key}) : super(key: key);

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
    return Consumer<UserProvider>(builder: (_, userProvider, __) {
      return SizedBox(
        height: AppBar().preferredSize.height,
        width: 428.w,
        child: Stack(
          children: [
            Positioned(
                bottom: 10.h, left: 0.w, child: _buildDropMenu(userProvider)),
            Positioned(
                bottom: 10.h,
                left: 40.w,
                child: GestureDetector(
                  onTap: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SearchHunters()));
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
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/WRR.svg',
                // fit: BoxFit.fill,
                alignment: Alignment.center,
                height: 55.h,
                // width: 100.w,
                // color: Colors.red,
              ),
            ),
            Positioned(
                bottom: 10.h,
                right: 40.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ContestPage()));
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
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                        height: 27.5.h,
                        width: 27.5.h,
                        color: Colors.white,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 12.5.h,
                          width: 12.5.h,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(6.25.h)),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      );
    });
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
      color: AppColors.secondaryColor,
      // itemBuilder: (context) => [
      //   ..._counties.map((county) => PopupMenuItem<County>(
      //       value: county,
      //       child: SizedBox(
      //         width: 200.w,
      //         child: ListTile(
      //           trailing: county.name == userProvider.user.countyName
      //               ? const Icon(
      //                   Icons.check,
      //                   color: AppColors.btnColor,
      //                 )
      //               : null,
      //           title: Text(
      //             county.name,
      //             style: const TextStyle(color: Colors.white),
      //             maxLines: 1,
      //           ),
      //         ),
      //       )))
      // ],
      // onSelected: (County value) {
      //   User _user = userProvider.user;
      //   _user.countyName = value.name;
      //   userProvider.setUser(_user);
      //   Provider.of<WeatherProvider>(context, listen: false)
      //       .changeCounty(value);
      //   Provider.of<CountyPostProvider>(context, listen: false)
      //       .chnageCounty(_user.id, value.id);
      // },

      itemBuilder: (context) => [
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
        if (userProvider.user.regionName != value.name) {
          User _user = userProvider.user;
          _user.regionName = value.name;
          userProvider.setUser(_user);
          Provider.of<RegionPostProvider>(context, listen: false)
              .chnageRegion(_user.id, value.id);
          Provider.of<ReportPostProvider>(context, listen: false)
              .chnageRegion(_user.id, value.id);
          Provider.of<ContestProvider>(context, listen: false)
              .chnageRegion(_user.id, value.id);
        }
      },
    );
  }
}
