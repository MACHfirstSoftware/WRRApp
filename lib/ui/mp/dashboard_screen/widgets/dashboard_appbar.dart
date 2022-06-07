import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardAppBar extends StatefulWidget {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  late List<String> _countries;
  late String _selectedCountry;

  @override
  void initState() {
    _selectedCountry = '';
    _countries = ["USA", "UK", "AUS"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Stack(
        children: [
          Positioned(bottom: 10.h, left: 0.w, child: _buildDropMenu()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                "WRR",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
              bottom: 10.h,
              right: 40.w,
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                fit: BoxFit.fill,
                alignment: Alignment.center,
                height: 30.h,
                width: 30.h,
                color: Colors.white,
              )),
          Positioned(
              bottom: 10.h,
              right: 0.w,
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
              )),
        ],
      ),
    );
  }

  _buildDropMenu() {
    return PopupMenuButton(
      child: SvgPicture.asset(
        'assets/icons/location.svg',
        height: 30.h,
        width: 30.h,
        fit: BoxFit.fill,
        alignment: Alignment.center,
        color: Colors.white,
      ),
      itemBuilder: (context) => [
        ..._countries.map((country) => PopupMenuItem<String>(
            value: country,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: country == _selectedCountry
                    ? const Icon(
                        Icons.check,
                        color: Colors.blue,
                      )
                    : null,
                title: Text(
                  country,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (String value) {
        _selectedCountry = value;
      },
    );
  }
}
