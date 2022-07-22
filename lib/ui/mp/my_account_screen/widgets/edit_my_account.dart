import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/all_post_provider.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/input_field.dart';
import 'package:wisconsin_app/ui/landing/common_widgets/logo_image.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class EditMyAccount extends StatefulWidget {
  const EditMyAccount({Key? key}) : super(key: key);

  @override
  State<EditMyAccount> createState() => _EditMyAccountState();
}

class _EditMyAccountState extends State<EditMyAccount> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _personCodeController;
  late TextEditingController _phoneController;
  late User _user;
  late List<County> _counties;
  late List<Region> _regions;
  late County _selectedCounty;
  final List<String> _weapon = ["Bow", "Gun", "Both"];
  int _selectedWeaponId = 1;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _regions = Provider.of<RegionProvider>(context, listen: false).regions;
    _selectedCounty = County(
        id: _user.countyId, name: _user.countyName!, regionId: _user.regionId);
    _firstNameController = TextEditingController(text: _user.firstName);
    _lastNameController = TextEditingController(text: _user.lastName);
    _personCodeController = TextEditingController(text: _user.code);
    _phoneController = TextEditingController(text: _user.phoneMobile);
    _selectedWeaponId = _user.answerId ?? 1;

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _personCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  _validateEdit() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "First name is empty",
          type: SnackBarType.error));
      return false;
    }
    if (_lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Last name is empty",
          type: SnackBarType.error));
      return false;
    }
    if (_personCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Handle name is empty",
          type: SnackBarType.error));
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Phone number is empty",
          type: SnackBarType.error));
      return false;
    }
    if (_phoneController.text.trim().length != 12) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Phone number is invalid",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _doUpdate() async {
    if (_validateEdit()) {
      PageLoader.showLoader(context);
      final updateUser = await UserService.updateUser(
          _user.id,
          _firstNameController.text,
          _lastNameController.text,
          _personCodeController.text,
          _phoneController.text,
          _selectedCounty.id,
          _selectedCounty.regionId);

      if (updateUser) {
        final res = await UserService.updateWeapon(_user.id, _selectedWeaponId);
        Navigator.pop(context);
        if (res) {
          User newUser = User(
              id: _user.id,
              lastName: _lastNameController.text,
              firstName: _firstNameController.text,
              emailAddress: _user.emailAddress,
              username: _user.username,
              code: _personCodeController.text,
              country: _user.country,
              stateOrTerritory: _user.stateOrTerritory,
              countyId: _selectedCounty.id,
              regionId: _selectedCounty.regionId,
              isOptIn: _user.isOptIn,
              answerId: _selectedWeaponId,
              countyName: CountyUtil.getCountyNameById(
                  counties: _counties, countyId: _selectedCounty.id),
              isFollowed: _user.isFollowed,
              phoneMobile: _phoneController.text,
              profileImageUrl: _user.profileImageUrl,
              regionName: CountyUtil.getRegionNameById(
                  regions: _regions, regionId: _selectedCounty.regionId));

          Provider.of<UserProvider>(context, listen: false).setUser(newUser);
          Provider.of<RegionPostProvider>(context, listen: false)
              .chnageRegion(_user.id, _selectedCounty.regionId);
          Provider.of<ReportPostProvider>(context, listen: false)
              .chnageRegion(_user.id, _selectedCounty.regionId);
          Provider.of<AllPostProvider>(context, listen: false)
              .chnageRegion(_user.id, _selectedCounty.regionId);
          Provider.of<ContestProvider>(context, listen: false)
              .chnageRegion(_user.id, _selectedCounty.regionId);
          Provider.of<WeatherProvider>(context, listen: false)
              .changeCounty(_selectedCounty);
          ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
              context: context,
              messageText: "Succefully updated",
              type: SnackBarType.success));
        } else {
          ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
              context: context,
              messageText: "Unable to update",
              type: SnackBarType.error));
        }
      }
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to update",
          type: SnackBarType.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: const DefaultAppbar(title: "Edit My Account"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 35.h,
                width: 428.w,
              ),
              const LogoImage(),
              SizedBox(
                height: 35.h,
              ),
              InputField(
                hintText: "First Name",
                prefixIconPath: "assets/icons/user.svg",
                controller: _firstNameController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Last Name",
                prefixIconPath: "assets/icons/user.svg",
                controller: _lastNameController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Handle Name",
                prefixIconPath: "assets/icons/user.svg",
                controller: _personCodeController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              InputField(
                hintText: "Phone Number",
                prefixIconPath: "assets/icons/phone.svg",
                controller: _phoneController,
                textInputType: TextInputType.number,
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 310.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "County  :",
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(child: _buildCountyDropMenu())
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 310.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Weapon  :",
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(child: _buildWeaponDropMenu())
                  ],
                ),
              ),
              SizedBox(
                height: 55.h,
                width: 428.w,
              ),
              GestureDetector(
                  onTap: _doUpdate,
                  child: Container(
                    alignment: Alignment.center,
                    height: 40.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: AppColors.btnColor,
                        borderRadius: BorderRadius.circular(7.5.w)),
                    child: SizedBox(
                      height: 30.h,
                      width: 100.w,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 35.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCountyDropMenu() {
    return PopupMenuButton(
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    _selectedCounty.name,
                    style: TextStyle(
                        fontSize: 18.sp,
                        // color: AppColors.btnColor,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.btnColor,
              ),
            ]),
      ),
      color: AppColors.popBGColor,
      itemBuilder: (context) => [
        ..._counties.map((county) => PopupMenuItem<County>(
            value: county,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: county.id == _selectedCounty.id
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
        setState(() {
          _selectedCounty = value;
        });
      },
    );
  }

  _buildWeaponDropMenu() {
    return PopupMenuButton(
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    _weapon[_selectedWeaponId - 1],
                    style: TextStyle(
                        fontSize: 18.sp,
                        // color: AppColors.btnColor,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.btnColor,
              ),
            ]),
      ),
      color: AppColors.popBGColor,
      itemBuilder: (context) => [
        ..._weapon.map((weapon) => PopupMenuItem<String>(
            value: weapon,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: weapon == _weapon[_selectedWeaponId - 1]
                    ? const Icon(
                        Icons.check,
                        color: AppColors.btnColor,
                      )
                    : null,
                title: Text(
                  weapon,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (String value) {
        for (int i = 0; i < _weapon.length; i++) {
          if (_weapon[i] == value) {
            setState(() {
              _selectedWeaponId = i + 1;
            });
            break;
          }
        }
      },
    );
  }
}
