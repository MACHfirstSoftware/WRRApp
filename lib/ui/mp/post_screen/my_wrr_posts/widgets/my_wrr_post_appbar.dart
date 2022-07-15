import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/post_screen/create_update_post/create_post.dart';

class MyWRRPostAppBar extends StatefulWidget {
  const MyWRRPostAppBar({Key? key}) : super(key: key);

  @override
  State<MyWRRPostAppBar> createState() => _MyWRRPostAppBarState();
}

class _MyWRRPostAppBarState extends State<MyWRRPostAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 428.w,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NewPost(
                        // isWRRPost: true,
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10.w),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(7.5.w)),
                  child: Text(
                    "New Post",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
