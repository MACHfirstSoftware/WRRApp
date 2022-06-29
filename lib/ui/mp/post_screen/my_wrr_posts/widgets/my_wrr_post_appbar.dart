import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/ui/mp/post_screen/add_post/create_post.dart';

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
        child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NewPost(
                          isWRRPost: true,
                        )),
              );
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.btnColor,
              size: 30.h,
            )),
      ),
    );
  }
}
