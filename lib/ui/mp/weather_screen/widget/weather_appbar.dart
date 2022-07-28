import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/widgets/view_map.dart';

class WeatherAppBar extends StatefulWidget {
  const WeatherAppBar({Key? key}) : super(key: key);

  @override
  State<WeatherAppBar> createState() => _WeatherAppBarState();
}

class _WeatherAppBarState extends State<WeatherAppBar> {
  late List<County> _counties;
  late List<Region> _regions;
  @override
  void initState() {
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _regions = Provider.of<RegionProvider>(context, listen: false).regions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (_, weatherProvider, __) {
      String date = "";
      if (weatherProvider.apiStatus == ApiStatus.isIdle) {
        if (weatherProvider.pageNum == -1) {
          date = " - " +
              UtilCommon.getDate(weatherProvider.weather.current.lastUpdated);
        } else {
          date = " - " +
              UtilCommon.getDate(weatherProvider.weather.current.lastUpdated,
                  forecasrDay: weatherProvider.pageNum);
        }
      }

      return SizedBox(
        height: AppBar().preferredSize.height,
        width: 428.w,
        child: Stack(
          children: [
            Positioned(bottom: 10.h, left: 0.w, child: _buildDropMenu()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: SizedBox(
                  width: 300.w,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      "${weatherProvider.county.name} County$date",
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 10.h,
            //   left: 50.h,
            //   child: Text(
            //     userProvider.user.regionName!,
            //     style: TextStyle(
            //         fontSize: 20.sp,
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold),
            //     textAlign: TextAlign.center,
            //   ),
            // )
            // Align(
            //   alignment: Alignment.center,
            //   child: SvgPicture.asset(
            //     'assets/icons/WRR.svg',
            //     // fit: BoxFit.fill,
            //     alignment: Alignment.center,
            //     height: 55.h,
            //     // width: 100.w,
            //     // color: Colors.red,
            //   ),
            // ),
            Positioned(
                bottom: 10.h,
                right: 0.w,
                child: _buildDropMenuForCounty(weatherProvider)),
          ],
        ),
      );
    });
  }

  _buildDropMenu() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
            Provider.of<ReportPostProvider>(context, listen: false)
                .chnageRegion(_user.id, value.id);
            // Provider.of<AllPostProvider>(context, listen: false)
            //     .chnageRegion(_user.id, value.id);
            Provider.of<ContestProvider>(context, listen: false)
                .chnageRegion(_user.id, value.id);
          }
        }
      },
    );
  }

  _buildDropMenuForCounty(WeatherProvider weatherProvider) {
    return PopupMenuButton(
      child: SvgPicture.asset(
        'assets/icons/home.svg',
        height: 30.h,
        width: 30.h,
        fit: BoxFit.fill,
        alignment: Alignment.center,
        color: Colors.white,
      ),
      // icon: Align(
      //   alignment: Alignment.center,
      //   child: Icon(
      //     Icons.home_work_rounded,
      //     size: 20.h,
      //     color: Colors.white,
      //   ),
      // ),
      color: AppColors.popBGColor,
      itemBuilder: (context) => [
        ..._counties.map((county) => PopupMenuItem<County>(
            value: county,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: county.name == weatherProvider.county.name
                    ? const Icon(
                        Icons.check,
                        color: AppColors.btnColor,
                      )
                    : null,
                title: Text(
                  county.name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (County value) {
        if (weatherProvider.county != value) {
          weatherProvider.changeCounty(value);
        }
      },
    );
  }
}
