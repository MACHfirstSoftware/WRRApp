import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/super_region.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';

class ContestAppBar extends StatefulWidget {
  const ContestAppBar({Key? key}) : super(key: key);

  @override
  State<ContestAppBar> createState() => _ContestAppBarState();
}

class _ContestAppBarState extends State<ContestAppBar> {
  late List<SuperRegion> _superRegions;
  @override
  void initState() {
    _superRegions =
        Provider.of<ContestProvider>(context, listen: false).superRegions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              alignment: Alignment.center,
              child: Text(
                "Contests",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
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
      itemBuilder: (context) => [
        ..._superRegions.map((superRegion) => PopupMenuItem<SuperRegion>(
            value: superRegion,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: superRegion.id == contestProvider.superRegionId
                    ? const Icon(
                        Icons.check,
                        color: AppColors.btnColor,
                      )
                    : null,
                title: Text(
                  superRegion.name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (SuperRegion value) {
        if (contestProvider.superRegionId != value.id) {
          contestProvider.chnageSuperRegion(
              Provider.of<UserProvider>(context, listen: false).user.id,
              Provider.of<UserProvider>(context, listen: false).user.regionId,
              value.id);
        }
      },
    );
  }
}
