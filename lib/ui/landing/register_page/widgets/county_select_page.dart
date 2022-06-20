import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/register_provider.dart';

class CountySelectPage extends StatefulWidget {
  const CountySelectPage({Key? key}) : super(key: key);

  @override
  State<CountySelectPage> createState() => _CountySelectPageState();
}

class _CountySelectPageState extends State<CountySelectPage> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<CountyProvider>(builder: (context, countyProvider, _) {
      return Consumer<RegisterProvider>(
          builder: (context, registerProvider, _) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.w),
              child: Text(
                "Which county do you typically hunt in?",
                style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 410.w,
              child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    unselectedWidgetColor: AppColors.btnColor,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      registerProvider.selectedCounty?.name ?? "County",
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    iconColor: AppColors.btnColor,
                    onExpansionChanged: (bool value) {
                      setState(() {
                        _isExpanded = value;
                      });
                    },
                  )),
            ),
            Flexible(
              child: _isExpanded
                  ? SizedBox(
                      width: 410.w,
                      child: Card(
                        color: Colors.white.withOpacity(0.15),
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.w)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 25.h),
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: countyProvider.counties.length,
                            itemBuilder: (_, index) {
                              return ListTile(
                                title: Text(
                                  countyProvider.counties[index].name,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.grey[200]!,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ),
                                trailing: registerProvider.selectedCounty ==
                                        countyProvider.counties[index]
                                    ? Icon(
                                        Icons.check,
                                        color: AppColors.btnColor,
                                        size: 30.h,
                                      )
                                    : null,
                                onTap: () {
                                  registerProvider.changeCounty(
                                      countyProvider.counties[index]);
                                },
                              );
                            },
                            separatorBuilder: (_, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1.25.h,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        );
      });
    });
  }
}
