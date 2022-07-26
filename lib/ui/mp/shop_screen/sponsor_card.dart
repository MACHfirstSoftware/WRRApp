import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/sponsor.dart';

class SponsorCard extends StatelessWidget {
  final Sponsor sponsor;
  const SponsorCard({
    Key? key,
    required this.sponsor,
  }) : super(key: key);

  _launch(String url) async {
    Uri uri = Uri.parse(url);
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      uri = Uri.parse("https://" + url);
    }
    if (!await launchUrl(
      uri,
    )) {
      print("Couldn't launch");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 0.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(5.h)),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 10.w,
            leading: Container(
              alignment: Alignment.center,
              height: 60.w,
              width: 60.w,
              decoration: BoxDecoration(
                color: AppColors.popBGColor,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.w),
                child: sponsor.logoUrl != null
                    ? SizedBox(
                        height: 60.w,
                        width: 60.w,
                        child: CachedNetworkImage(
                          imageUrl: sponsor.logoUrl!,
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
                              height: 10.w,
                              width: 10.w,
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                color: AppColors.btnColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.btnColor,
                              size: 10.w),
                        ),
                      )
                    : SizedBox(
                        height: 40.w,
                        width: 40.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            sponsor.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
            ),
            title: Text(
              sponsor.name,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.btnColor,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            subtitle: Text(
              sponsor.description,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          ),
          ...sponsor.discounts
              .map((Discount discount) => _buildDiscountRow(discount: discount))
        ],
      ),
    );
  }

  _buildDiscountRow({required Discount discount}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 60.w),
          Container(
            alignment: Alignment.center,
            height: 30.h,
            width: 75.w,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(color: AppColors.btnColor, width: 1.h)),
            child: SizedBox(
              height: 25.h,
              width: 65.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  discount.offer,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 30.h,
            width: 125.w,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(color: AppColors.btnColor, width: 1.h)),
            child: SizedBox(
              height: 25.h,
              width: 115.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  discount.discountCode,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _launch(discount.link),
            child: Container(
              alignment: Alignment.center,
              height: 30.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: SizedBox(
                height: 25.h,
                width: 80.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    "Show Now",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}