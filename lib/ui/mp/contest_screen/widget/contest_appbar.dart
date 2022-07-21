import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';

class ContestAppBar extends StatefulWidget {
  final int tabIndex;
  const ContestAppBar({Key? key, required this.tabIndex}) : super(key: key);

  @override
  State<ContestAppBar> createState() => _ContestAppBarState();
}

class _ContestAppBarState extends State<ContestAppBar> {
  late List<CustomSuperRegion> _customSuperRegions;
  String title = '';
  @override
  void initState() {
    _customSuperRegions =
        Provider.of<ContestProvider>(context, listen: false).customSuperRegions;

    super.initState();
  }

  _titleSet() {
    if (widget.tabIndex == 0) {
      title = "Leaderboard";
    }
    if (widget.tabIndex == 1) {
      title = "Rules";
    }
    if (widget.tabIndex == 2) {
      title = "How to Enter";
    }
  }

  @override
  Widget build(BuildContext context) {
    _titleSet();
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    size: 30.h,
                    color: Colors.white,
                  ))),
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
                    title,
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
          Align(
              alignment: Alignment.centerRight,
              child: _buildDropMenuForCounty()),
        ],
      ),
    );
  }

  _buildDropMenuForCounty() {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);
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
      elevation: 2,
      itemBuilder: (context) => [
        ..._customSuperRegions.map((val) => PopupMenuItem<CustomSuperRegion>(
            value: val,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: val.superRegion.id ==
                            contestProvider.customSuperRegion.superRegion.id &&
                        val.weapon == contestProvider.customSuperRegion.weapon
                    ? const Icon(
                        Icons.check,
                        color: AppColors.btnColor,
                      )
                    : null,
                title: Text(
                  val.superRegion.name +
                      (val.weapon == "G" ? " - Gun" : " - Bow"),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (CustomSuperRegion value) {
        if (contestProvider.customSuperRegion != value) {
          contestProvider.chnageSuperRegion(
              Provider.of<UserProvider>(context, listen: false).user.id,
              Provider.of<UserProvider>(context, listen: false).user.regionId,
              value);
        }
      },
    );
  }
}
