import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/providers/user_provider.dart';

class UserCard extends StatelessWidget {
  final String id;
  final String name;
  final String personCode;
  final String county;
  final String? profileImageUrl;
  final VoidCallback onTap;
  final bool isFollowed;
  const UserCard(
      {Key? key,
      required this.name,
      required this.personCode,
      required this.county,
      this.profileImageUrl,
      required this.onTap,
      required this.isFollowed,
      this.id = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context).user;
    return Container(
      height: 75.h,
      width: 428.w,
      margin: EdgeInsets.symmetric(horizontal: 7.5.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 7.5.w,
          ),
          Container(
              alignment: Alignment.center,
              height: 60.h,
              width: 60.h,
              // padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: AppColors.popBGColor,
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.h),
                child: profileImageUrl != null
                    ? SizedBox(
                        height: 60.h,
                        width: 60.h,
                        child: CachedNetworkImage(
                          imageUrl: profileImageUrl!,
                          imageBuilder: (context, imageProvider) {
                            return Image(
                              image: imageProvider,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            );
                          },
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: SizedBox(
                              height: 10.h,
                              width: 10.h,
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                color: AppColors.btnColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.btnColor,
                              size: 10.h),
                        ),
                      )
                    : SizedBox(
                        height: 40.h,
                        width: 40.h,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            name.split(" ")[0].substring(0, 1).toUpperCase() +
                                name
                                    .split(" ")[1]
                                    .substring(0, 1)
                                    .toUpperCase(),
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
                            color: Colors.black87,
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
          if (_user.id != id)
            SizedBox(
                height: 60.h,
                width: 60.h,
                child: IconButton(
                  // splashColor: AppColors.btnColor.withOpacity(0.5),
                  iconSize: 25.h,
                  icon: Icon(
                    Icons.person_add_alt_rounded,
                    color: isFollowed ? AppColors.btnColor : Colors.black54,
                  ),
                  onPressed: onTap,
                ))
        ],
      ),
    );
  }
}
