import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class PostSharePage extends StatefulWidget {
  final int postId;
  const PostSharePage({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostSharePage> createState() => _PostSharePageState();
}

class _PostSharePageState extends State<PostSharePage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _dataLoading;
  late User _user;
  List<User> _followers = [];
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    _dataLoading = true;
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _init();
    super.initState();
  }

  _init() async {
    final response = await UserService.getFollowedList(_user.id);
    response.when(success: (List<User> followers) {
      setState(() {
        _followers = followers;
        _dataLoading = false;
      });
    }, failure: (NetworkExceptions error) {
      Navigator.pop(context);
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Sharing unsuccessful",
          type: SnackBarType.error));
    }, responseError: (ResponseError responseError) {
      Navigator.pop(context);
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Sharing unsuccessful",
          type: SnackBarType.error));
    });
  }

  _doPostShare() async {
    if (data.isNotEmpty) {
      PageLoader.showLoader(context);
      final response = await PostService.postShare(data);
      Navigator.pop(context);
      if (response) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Successfully shared",
            type: SnackBarType.success));
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(customSnackBar(
            context: context,
            messageText: "Sharing unsuccessful",
            type: SnackBarType.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Material(
          color: Colors.transparent,
          child: _dataLoading
              ? ViewModels.postLoader()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 25.h),
                      decoration: BoxDecoration(
                          color: AppColors.popBGColor,
                          borderRadius: BorderRadius.circular(20.w)),
                      child: Column(
                        children: [
                          Text(
                            "Post Share",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 400.h,
                                maxWidth: 400.w,
                                minWidth: 400.w,
                                minHeight: 150.h),
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _followers.length,
                              itemBuilder: (_, index) {
                                return Material(
                                  color: AppColors.popBGColor,
                                  borderRadius: BorderRadius.circular(10.w),
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white,
                                    ),
                                    child: CheckboxListTile(
                                      tileColor: Colors.white10,
                                      activeColor: AppColors.btnColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      value: data.any((element) =>
                                          element["sharePersonId"] ==
                                          _followers[index].id),
                                      onChanged: (bool? value) {
                                        if (value!) {
                                          setState(() {
                                            data.add({
                                              "personId": _user.id,
                                              "sharePersonId":
                                                  _followers[index].id,
                                              "postId": widget.postId
                                            });
                                          });
                                        } else {
                                          for (final answerData in data) {
                                            if (answerData["sharePersonId"] ==
                                                _followers[index].id) {
                                              data.remove(answerData);
                                              break;
                                            }
                                          }
                                          setState(() {});
                                        }
                                      },
                                      contentPadding: EdgeInsets.only(
                                          left: 15.w, right: 15.w),
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      secondary: Container(
                                          alignment: Alignment.center,
                                          height: 60.h,
                                          width: 60.h,
                                          // padding: EdgeInsets.all(10.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.popBGColor,
                                            borderRadius:
                                                BorderRadius.circular(10.h),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.h),
                                            child: _followers[index]
                                                        .profileImageUrl !=
                                                    null
                                                ? SizedBox(
                                                    height: 60.h,
                                                    width: 60.h,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          _followers[index]
                                                              .profileImageUrl!,
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Image(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                          alignment:
                                                              Alignment.center,
                                                        );
                                                      },
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  progress) =>
                                                              Center(
                                                        child: SizedBox(
                                                          height: 10.h,
                                                          width: 10.h,
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: progress
                                                                .progress,
                                                            color: AppColors
                                                                .btnColor,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(
                                                              Icons
                                                                  .broken_image_outlined,
                                                              color: AppColors
                                                                  .btnColor,
                                                              size: 10.h),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 40.h,
                                                    width: 40.h,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        _followers[index]
                                                                .firstName
                                                                .substring(0, 1)
                                                                .toUpperCase() +
                                                            _followers[index]
                                                                .lastName
                                                                .substring(0, 1)
                                                                .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 18.sp,
                                                            color: AppColors
                                                                .btnColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                          )),
                                      title: SizedBox(
                                        height: 20.h,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            _followers[index].code,
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),

                                      // Text(
                                      //   // _followers[index].firstName +
                                      //   //     " " +
                                      //   //     _followers[index].lastName,
                                      //   _followers[index].code,
                                      //   style: TextStyle(
                                      //     color: Colors.white,
                                      //     fontSize: 18.sp,
                                      //     fontWeight: FontWeight.w600,
                                      //   ),
                                      // ),
                                      subtitle: SizedBox(
                                        height: 15.h,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            (CountyUtil.getCountyNameById(
                                                    counties: Provider.of<
                                                                CountyProvider>(
                                                            context,
                                                            listen: false)
                                                        .counties,
                                                    countyId: _followers[index]
                                                        .countyId) +
                                                " County"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, index) {
                                return SizedBox(
                                  height: 5.h,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [_cancel(), _share()],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _cancel() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        width: 130.w,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 2.h,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.h)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 25.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _share() {
    return GestureDetector(
      onTap: data.isNotEmpty
          ? () {
              _doPostShare();
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        width: 130.w,
        decoration: BoxDecoration(
            color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(5.h)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Colors.white,
              size: 25.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                "Share",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
