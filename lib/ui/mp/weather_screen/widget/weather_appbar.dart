import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';

class WeatherAppBar extends StatefulWidget {
  const WeatherAppBar({Key? key}) : super(key: key);

  @override
  State<WeatherAppBar> createState() => _WeatherAppBarState();
}

class _WeatherAppBarState extends State<WeatherAppBar> {
  late List<County> _counties;
  @override
  void initState() {
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
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
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: 10.h),
            //     child: Text(
            //       _countyName,
            //       style: TextStyle(
            //           fontSize: 20.sp,
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 10.h,
              left: 50.h,
              child: Text(
                userProvider.user.countyName!,
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
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
      itemBuilder: (context) => [
        ..._counties.map((county) => PopupMenuItem<County>(
            value: county,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: county.name == userProvider.user.countyName
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
        User _user = userProvider.user;
        // _user.countyId = value.id;
        // print(_user.countyId);
        _user.countyName = value.name;
        userProvider.setUser(_user);
        Provider.of<WeatherProvider>(context, listen: false)
            .changeCounty(value);
        Provider.of<CountyPostProvider>(context, listen: false)
            .chnageCounty(_user.id, value.id);
      },
    );
  }
}
