import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/contest.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/utils/common.dart';

class ContestPostView extends StatefulWidget {
  final Post post;
  final int sortOrder;
  const ContestPostView({Key? key, required this.post, required this.sortOrder})
      : super(key: key);

  @override
  State<ContestPostView> createState() => _ContestPostViewState();
}

class _ContestPostViewState extends State<ContestPostView> {
  bool showContest = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      color: Colors.white,
      width: 428.w,
      child: Column(
        children: [
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 10.w),
            title: _buildPersonRow(
                widget.post.firstName + " " + widget.post.lastName,
                widget.post.personCode,
                widget.post.postPersonCounty,
                widget.post.createdOn),
            children: [
              ContestView(contest: widget.post.contest!),
              SizedBox(
                height: 5.h,
              )
            ],
          )
        ],
      ),
    );
  }

  _buildPersonRow(
      String name, String personCode, String county, DateTime date) {
    return SizedBox(
      height: 75.h,
      width: 428.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              height: 60.h,
              width: 60.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.h),
                child: SizedBox(
                  height: 40.h,
                  width: 40.h,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      widget.sortOrder.toString(),
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
          SizedBox(
            width: 7.5.w,
          ),
          Expanded(
            child: SizedBox(
              height: 60.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        personCode,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        county + " County",
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.5.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        UtilCommon.convertToAgo(date),
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContestView extends StatelessWidget {
  final Contest contest;
  const ContestView({Key? key, required this.contest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.h),
          border: Border.all(color: Colors.black54, width: 0.75.w)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportDataRow("Spread", contest.spread.toString() + " in."),
            _buildReportDataRow("Length", contest.length.toString() + " in."),
            _buildReportDataRow("Number of Tines", contest.numTines.toString()),
            _buildReportDataRow(
                "Length of Tines", contest.lengthTines.toString() + " in."),
            _buildReportDataRow(
                "Weapon", contest.weapon == "G" ? "Gun" : "Bow"),
            _buildReportDataRow(
                "Harvest", UtilCommon.formatDate(contest.harvestedOn)),
          ]),
    );
  }

  _buildReportDataRow(String name, String data) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.left,
        ),
        Expanded(
          child: Text(
            data,
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
