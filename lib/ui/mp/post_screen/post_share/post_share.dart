import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
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
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(10.w),
                                  child: CheckboxListTile(
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
                                        left: 35.w, right: 15.w),
                                    title: Text(
                                      _followers[index].firstName +
                                          " " +
                                          _followers[index].lastName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
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
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 2.5.w,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 24.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
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
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
            color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(5.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Colors.white,
              size: 24.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Share",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
