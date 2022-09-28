import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/search_service.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/user_card_widget.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class LikesPreview extends StatefulWidget {
  final List<Like> likes;
  const LikesPreview({Key? key, required this.likes}) : super(key: key);

  @override
  State<LikesPreview> createState() => _LikesPreviewState();
}

class _LikesPreviewState extends State<LikesPreview> {
  late User _user;
  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 450.h),
      decoration: BoxDecoration(
          color: AppColors.popBGColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.w),
            topRight: Radius.circular(25.w),
          )),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 25.h,
            width: 300.w,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                "${widget.likes.length} Likes",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.btnColor,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(color: Colors.grey[200], height: .5.h),
          SizedBox(
            height: 5.h,
            width: 428.w,
          ),
          Expanded(
            child: widget.likes.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(top: 5.h),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return UserCard(
                        id: widget.likes[index].personId,
                        name: widget.likes[index].firstName +
                            " " +
                            widget.likes[index].lastName,
                        personCode: widget.likes[index].code,
                        county: widget.likes[index].countyName,
                        profileImageUrl: widget.likes[index].imageLocation,
                        onTap: () {
                          if (widget.likes[index].isFollower) {
                            _personUnfollow(index);
                          } else {
                            _personFollow(index);
                          }
                        },
                        isFollowed: widget.likes[index].isFollower,
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 5.h,
                      );
                    },
                    itemCount: widget.likes.length)
                : Center(child: ViewModels.postEmply(text: "No likes")),
          )
        ],
      ),
    );
  }

  _personFollow(int index) async {
    PageLoader.showLoader(context);
    final res = await SearchService.personFollow(
        _user.id, widget.likes[index].personId);
    Navigator.pop(context);
    if (res) {
      setState(() {
        widget.likes[index].isFollower = true;
      });
    }
  }

  _personUnfollow(int index) async {
    PageLoader.showLoader(context);
    final res = await SearchService.personUnfollow(
        _user.id, widget.likes[index].personId);
    Navigator.pop(context);
    if (res) {
      setState(() {
        widget.likes[index].isFollower = false;
      });
    }
  }
}
