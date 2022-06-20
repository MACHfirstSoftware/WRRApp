import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 5.w),
      margin: EdgeInsets.only(bottom: 4.h),
      color: Colors.white,
      width: 428.w,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 75.h,
            width: 428.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 7.5.w,
                ),
                SizedBox(
                    height: 60.h,
                    width: 60.h,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.h),
                        child: Image.asset(
                          "assets/images/bg.png",
                          fit: BoxFit.cover,
                        ))),
                SizedBox(
                  width: 7.5.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "standman",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "14 minutes ago",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person_add_alt_rounded,
                        size: 40.h,
                        color: AppColors.btnColor,
                      )),
                )
              ],
            ),
          ),
          Container(
              color: Colors.red,
              height: 300.h,
              width: 428.w,
              margin: EdgeInsets.symmetric(horizontal: 3.5.w),
              child: Image.asset(
                "assets/images/bg.png",
                fit: BoxFit.fill,
              )),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: 50.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_up_off_alt_rounded,
                      size: 40.h,
                      color: AppColors.iconGrey,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.insert_comment_rounded,
                      size: 40.h,
                      color: AppColors.iconGrey,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.redo_rounded,
                      size: 40.h,
                      color: AppColors.iconGrey,
                    )),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          size: 40.h,
                          color: AppColors.iconGrey,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            color: Colors.white,
            height: 40.h,
            child: Text(
              "${2} likes",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: 80.h,
            child: Text(
              "Comments appeare here",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
