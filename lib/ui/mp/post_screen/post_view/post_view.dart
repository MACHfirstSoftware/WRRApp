import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wisconsin_app/config.dart';
// import 'package:wisconsin_app/models/contest.dart';
import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/report.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/services/search_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/create_update_post/update_post.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_share/post_share.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/comment_section.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/image_preview.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_media_view.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/video_preview.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/video_thumbnail.dart';
import 'package:wisconsin_app/ui/mp/report_screen/create_update_report/update_report_post.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class PostView extends StatefulWidget {
  final Post post;
  const PostView({Key? key, required this.post}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int? likeIndex;
  late bool _isApiCall;
  late bool _isFollowed;
  late User _user;
  bool _showComments = false;
  @override
  void initState() {
    _isApiCall = false;
    _isFollowed = widget.post.isShare;
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _setLikeIndex();
    super.initState();
  }

  _setLikeIndex() {
    for (int i = 0; i < widget.post.likes.length; i++) {
      if (widget.post.likes[i].personId == _user.id) {
        likeIndex = i;
        break;
      }
    }
  }

  _postLike() async {
    setState(() {
      _isApiCall = true;
      likeIndex = widget.post.likes.length;
    });
    Like _like = Like(
        id: -1,
        personId: _user.id,
        firstName: _user.firstName,
        lastName: _user.lastName,
        createdOn: UtilCommon.getDateTimeNow(),
        postId: widget.post.id);

    final res = await PostService.postLike(_like);
    if (res != null) {
      _like.id = res;
      setState(() {
        widget.post.likes.add(_like);
        _isApiCall = false;
      });
    } else {
      setState(() {
        _isApiCall = false;
        likeIndex = null;
      });
    }
  }

  _postLikeDelete() async {
    int ind = likeIndex!;
    setState(() {
      _isApiCall = true;
      likeIndex = null;
    });
    final res = await PostService.postLikeDelete(widget.post.likes[ind].id);
    if (res) {
      setState(() {
        widget.post.likes.removeAt(ind);
        _isApiCall = false;
      });
    } else {
      setState(() {
        _isApiCall = false;
        likeIndex = ind;
      });
    }
  }

  _postAbuse() async {
    PageLoader.showLoader(context);
    final res = await PostService.postAbuse(_user.id, widget.post.id);
    Navigator.pop(context);
    if (res) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully reported",
          type: SnackBarType.success));
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Report unsuccessful",
          type: SnackBarType.error));
    }
  }

  _blockUser() async {
    PageLoader.showLoader(context);
    final res = await PostService.blockUser(_user.id, widget.post.personId);
    Navigator.pop(context);
    if (res) {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully blocked",
          type: SnackBarType.success));
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Blocking unsuccessful",
          type: SnackBarType.error));
    }
  }

  _deletePost() async {
    PageLoader.showLoader(context);
    final res = await PostService.postDelete(widget.post.id);
    Navigator.pop(context);
    if (res) {
      if (widget.post.report == null) {
        Provider.of<WRRPostProvider>(context, listen: false)
            .deletePost(widget.post);
        Provider.of<RegionPostProvider>(context, listen: false)
            .deletePost(widget.post);
      } else {
        Provider.of<ReportPostProvider>(context, listen: false)
            .deletePost(widget.post);
      }
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully deleted",
          type: SnackBarType.success));
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Delete unsuccessful",
          type: SnackBarType.error));
    }
  }

  _personFollow(String followerId, bool isOwner) async {
    setState(() {
      isOwner ? widget.post.isFollowed = true : _isFollowed = true;
    });
    final res = await SearchService.personFollow(_user.id, followerId);
    if (!res) {
      setState(() {
        isOwner ? widget.post.isFollowed = false : _isFollowed = false;
      });
    }
  }

  _personUnfollow(String unFollowerId, bool isOwner) async {
    setState(() {
      isOwner ? widget.post.isFollowed = false : _isFollowed = false;
    });
    final res = await SearchService.personUnfollow(_user.id, unFollowerId);
    if (!res) {
      setState(() {
        isOwner ? widget.post.isFollowed = true : _isFollowed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      color: Colors.white,
      width: 428.w,
      child: Column(
        children: [
          _buildPersonRow(
              widget.post.isShare
                  ? widget.post.sharePersonImage
                  : widget.post.profileImageUrl,
              widget.post.isShare
                  ? (widget.post.sharePersonFirstName +
                      " " +
                      widget.post.sharePersonLastName)
                  : (widget.post.firstName + " " + widget.post.lastName),
              widget.post.isShare
                  ? widget.post.sharePersonCode
                  : widget.post.personCode,
              widget.post.isShare
                  ? widget.post.sharePersonCountyName
                  : widget.post.postPersonCounty,
              widget.post.timeAgo,
              widget.post.isShare ? _isFollowed : widget.post.isFollowed,
              widget.post.isShare
                  ? widget.post.sharePersonId!
                  : widget.post.personId,
              !widget.post.isShare),
          // if (!widget.post.isShare) _buildPostTitleAndBody(widget.post.title),
          if (!widget.post.isShare)
            _buildPostTitleAndBody(widget.post.body, isTitle: false),
          if (widget.post.isShare)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black54, width: 1.w),
                      left: BorderSide(color: Colors.black54, width: 1.w),
                      right: BorderSide(color: Colors.black54, width: 1.w))),
              child: Column(
                children: [
                  _buildPersonRow(
                      widget.post.profileImageUrl,
                      widget.post.firstName + " " + widget.post.lastName,
                      widget.post.personCode,
                      widget.post.postPersonCounty,
                      widget.post.timeAgo,
                      widget.post.isFollowed,
                      widget.post.personId,
                      widget.post.isShare),
                  // _buildPostTitleAndBody(widget.post.title),
                  _buildPostTitleAndBody(widget.post.body, isTitle: false),
                ],
              ),
            ),
          if (widget.post.media.isNotEmpty) MediaView(media: widget.post.media),
          if (widget.post.report != null)
            ReportView(report: widget.post.report!),
          // if (widget.post.contest != null)
          //   ContestView(contest: widget.post.contest!),
          if (widget.post.isShare)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 10.h,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1.w),
                      left: BorderSide(color: Colors.black54, width: 1.w),
                      right: BorderSide(color: Colors.black54, width: 1.w))),
            ),
          if (widget.post.postType == "General" ||
              widget.post.postType == "Report")
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    "${widget.post.likes.length} likes",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 25.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showComments = !_showComments;
                      });
                    },
                    child: Text(
                      "${widget.post.comments.isEmpty ? "no" : widget.post.comments.length} comments",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.post.postType == "General" ||
              widget.post.postType == "Report")
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h),
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.h),
                    border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 0.75.w),
                      top: BorderSide(color: Colors.black54, width: 0.75.w),
                      left: BorderSide(color: Colors.black54, width: 0.75.w),
                      right: BorderSide(color: Colors.black54, width: 0.75.w),
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _isApiCall
                            ? null
                            : () {
                                if (likeIndex == null) {
                                  _postLike();
                                } else {
                                  _postLikeDelete();
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_up_rounded,
                              size: 25.h,
                              color: likeIndex != null
                                  ? AppColors.btnColor
                                  : AppColors.iconGrey,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Like",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.iconGrey,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showComments = !_showComments;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_rounded,
                              size: 25.h,
                              color: AppColors.iconGrey,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.iconGrey,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            HeroDialogRoute(
                                builder: (context) =>
                                    PostSharePage(postId: widget.post.id)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_rounded,
                              size: 25.h,
                              color: AppColors.iconGrey,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Share",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.iconGrey,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_showComments)
            CommentSection(
              comments: widget.post.comments,
              postId: widget.post.id,
            ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }

  _buildPostTitleAndBody(String text, {bool isTitle = true}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          // child: Text(
          //   text,
          //   style: TextStyle(
          // fontSize: isTitle ? 16.sp : 14.sp,
          // color: isTitle ? Colors.black : Colors.black87,
          //       fontWeight: isTitle ? FontWeight.w500 : FontWeight.w500),
          //   textAlign: TextAlign.left,
          // ),
          child: SelectableText.rich(
            TextSpan(
                children: extractText(text),
                style: TextStyle(
                  fontSize: isTitle ? 16.sp : 14.sp,
                  color: isTitle ? Colors.black : Colors.black87,
                )),
          )),
    );
  }

  List<TextSpan> extractText(String rawString) {
    List<TextSpan> textSpan = [];

    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

    getLink(String linkString) {
      textSpan.add(
        TextSpan(
          text: linkString,
          style: TextStyle(color: Colors.blue, fontSize: 14.sp),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              UtilCommon.launchAnUrl(linkString);
            },
        ),
      );
      return linkString;
    }

    getNormalText(String normalText) {
      textSpan.add(
        TextSpan(
          text: normalText,
          style: TextStyle(color: Colors.black87, fontSize: 14.sp),
        ),
      );
      return normalText;
    }

    rawString.splitMapJoin(
      urlRegExp,
      onMatch: (m) => getLink("${m.group(0)}"),
      onNonMatch: (n) => getNormalText(n.substring(0)),
    );

    return textSpan;
  }

  Container _buildPersonRow(
      String? profileImageUrl,
      String name,
      String personCode,
      String county,
      String timeAgo,
      bool isFollowed,
      String followerId,
      bool isOwner) {
    return Container(
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
                          imageUrl: profileImageUrl,
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
                  SizedBox(
                    height: 12.5.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        timeAgo,
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
          // if (_user.id != widget.post.personId)
          if ((isOwner && _user.id != widget.post.personId) ||
              (!isOwner && _user.id != widget.post.sharePersonId))
            SizedBox(
                height: 60.h,
                width: 40.h,
                child: IconButton(
                  splashColor: AppColors.btnColor.withOpacity(0.5),
                  iconSize: 25.h,
                  icon: Icon(
                    Icons.person_add_alt_rounded,
                    color: isFollowed ? AppColors.btnColor : Colors.black54,
                  ),
                  onPressed: () {
                    if (isFollowed) {
                      _personUnfollow(followerId, isOwner);
                    } else {
                      _personFollow(followerId, isOwner);
                    }
                  },
                )),
          SizedBox(
              height: 60.h,
              width: 50.h,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                color: AppColors.popBGColor,
                icon: Icon(Icons.more_horiz_rounded, size: 30.h),
                itemBuilder: (context) => [
                  if (isOwner && _user.id != widget.post.personId)
                    PopupMenuItem<String>(
                      value: "Report",
                      height: 30.h,
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: SizedBox(
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Report",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.error_rounded,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (isOwner && _user.id != widget.post.personId)
                    PopupMenuItem<String>(
                      value: "Block",
                      height: 30.h,
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: SizedBox(
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Block",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.person_off_rounded,
                                    color: Colors.redAccent,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!widget.post.isShare && _user.id == widget.post.personId)
                    PopupMenuItem<String>(
                      value: "Edit",
                      height: 30.h,
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: SizedBox(
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.mode_edit_outline_outlined,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!widget.post.isShare && _user.id == widget.post.personId)
                    PopupMenuItem<String>(
                      value: "Delete",
                      height: 30.h,
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: SizedBox(
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
                onSelected: (String value) {
                  if (value == "Report") {
                    Navigator.of(context).push(HeroDialogRoute(
                        builder: (context) => ConfirmationPopup(
                            onTap: _postAbuse,
                            title: "Report",
                            message: "Do you want to report post?",
                            leftBtnText: "Report",
                            rightBtnText: "Cancel")));
                  }
                  if (value == "Block") {
                    Navigator.of(context).push(HeroDialogRoute(
                        builder: (context) => ConfirmationPopup(
                            onTap: _blockUser,
                            title: "Block User",
                            message: "Do you want to block this user?",
                            leftBtnText: "Block",
                            rightBtnText: "Cancel")));
                  }
                  if (value == "Edit") {
                    if (widget.post.report == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => UpdatePost(
                                  post: widget.post,
                                )),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => UpdateReportPost(
                                  post: widget.post,
                                )),
                      );
                    }
                  }
                  if (value == "Delete") {
                    Navigator.push(
                        context,
                        HeroDialogRoute(
                            builder: (_) => ConfirmationPopup(
                                  title: "Delete",
                                  message:
                                      "If you delete now, you'll lose this post.",
                                  leftBtnText: "Delete",
                                  rightBtnText: "Cancel",
                                  onTap: _deletePost,
                                )));
                  }
                },
              ))
        ],
      ),
    );
  }
}

class MediaView extends StatelessWidget {
  const MediaView({
    Key? key,
    required this.media,
  }) : super(key: key);

  final List<Media> media;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: media.length == 1 ? 400.h : 350.h,
        width: 428.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: _mediaViewSelector(context));
  }

  _mediaViewSelector(BuildContext context) {
    switch (media.length) {
      case 1:
        return _buildOneMedia(context);
      // break;
      case 2:
        return _buildTwoMedia(context);
      // break;
      case 3:
        return _buildThreeMedia(context);
      // break;
      default:
        return _buildMoreThanThreeMedia(context);
      // break;
    }
  }

  _buildOneMedia(BuildContext context) {
    // if (media[0].imageUrl == null) {
    //   print("IMAGE URL IS : ${media[0].imageUrl}");
    //   print("VIDEO URL IS : ${media[0].videoUrl}");
    // }

    return media[0].imageUrl != null
        ? _imageTile(context, media[0].imageUrl!, 0)
        : VideoThumbs(videoUrl: media[0].videoUrl!, medias: media, index: 0);
    // return VideoThumbs(
    //     videoUrl:
    //         "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    // medias: media,
    // index: 0);
  }

  _buildTwoMedia(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 350.h,
            child: media[0].imageUrl != null
                ? _imageTile(context, media[0].imageUrl!, 0)
                : VideoThumbs(
                    videoUrl: media[0].videoUrl!, medias: media, index: 0),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Expanded(
          child: SizedBox(
            height: 350.h,
            child: media[1].imageUrl != null
                ? _imageTile(context, media[1].imageUrl!, 1)
                : VideoThumbs(
                    videoUrl: media[1].videoUrl!, medias: media, index: 1),
            // child: _imageTile(context, media[1].imageUrl!, 1),
          ),
        ),
      ],
    );
  }

  _buildThreeMedia(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 350.h,
            // child: _imageTile(context, media[0].imageUrl!, 0),
            child: media[0].imageUrl != null
                ? _imageTile(context, media[0].imageUrl!, 0)
                : VideoThumbs(
                    videoUrl: media[0].videoUrl!, medias: media, index: 0),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                // child: _imageTile(context, media[1].imageUrl!, 1),
                child: media[1].imageUrl != null
                    ? _imageTile(context, media[1].imageUrl!, 1)
                    : VideoThumbs(
                        videoUrl: media[1].videoUrl!, medias: media, index: 1),
              ),
              SizedBox(
                height: 3.w,
              ),
              Expanded(
                // child: _imageTile(context, media[2].imageUrl!, 2),
                child: media[2].imageUrl != null
                    ? _imageTile(context, media[2].imageUrl!, 2)
                    : VideoThumbs(
                        videoUrl: media[2].videoUrl!, medias: media, index: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildMoreThanThreeMedia(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 350.h,
            // child: _imageTile(context, media[0].imageUrl!, 0),
            child: media[0].imageUrl != null
                ? _imageTile(context, media[0].imageUrl!, 0)
                : VideoThumbs(
                    videoUrl: media[0].videoUrl!, medias: media, index: 0),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: 210.w,
                  // child: _imageTile(context, media[1].imageUrl!, 1),
                  child: media[1].imageUrl != null
                      ? _imageTile(context, media[1].imageUrl!, 1)
                      : VideoThumbs(
                          videoUrl: media[1].videoUrl!,
                          medias: media,
                          index: 1),
                ),
              ),
              SizedBox(
                height: 3.w,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 350.h / 2,
                        // child: _imageTile(context, media[2].imageUrl!, 2),
                        child: media[2].imageUrl != null
                            ? _imageTile(context, media[2].imageUrl!, 2)
                            : VideoThumbs(
                                videoUrl: media[2].videoUrl!,
                                medias: media,
                                index: 2),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: media.length == 4
                          ? SizedBox(
                              height: 350.h / 2,
                              // child: _imageTile(context, media[3].imageUrl!, 3),
                              child: media[3].imageUrl != null
                                  ? _imageTile(context, media[3].imageUrl!, 3)
                                  : VideoThumbs(
                                      videoUrl: media[3].videoUrl!,
                                      medias: media,
                                      index: 3),
                            )
                          : Stack(
                              children: [
                                SizedBox(
                                  height: 350.h / 2,
                                  child: media[3].imageUrl != null
                                      ? _imageTile(
                                          context, media[3].imageUrl!, 3)
                                      : VideoThumbs(
                                          videoUrl: media[3].videoUrl!,
                                          medias: media,
                                          index: 3),
                                ),
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PostMediaView(
                                                  medias: media)));
                                    },
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 3, sigmaY: 3),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "+${media.length - 4}",
                                    style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "+${media.length - 4}",
                                    style: TextStyle(
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 1.sp
                                          ..color = Colors.black38,
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _imageTile(BuildContext context, String url, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PostMediaView(medias: media, index: index)));
      },
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) {
          return Image(
            image: imageProvider,
            fit: BoxFit.cover,
            alignment:
                media.length == 1 ? Alignment.center : Alignment.topCenter,
          );
        },
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: SizedBox(
            height: 30.h,
            width: 30.h,
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.broken_image_outlined,
            color: AppColors.btnColor, size: 30.h),
      ),
    );
  }
}

class ReportView extends StatelessWidget {
  final Report report;
  const ReportView({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
      margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.h),
          border: Border.all(color: Colors.black54, width: 0.75.w)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportDataRow("Start time", report.startDateTime),
            _buildReportDataRow("No. Deer Seen", report.numDeer.toString()),
            _buildReportDataRow("No. Bucks Seen", report.numBucks.toString()),
            _buildReportDataRow(
                "Weather Rating", report.weatherRating.toString() + "/5"),
            _buildReportDataRow("Duration", "${report.numHours} hour(s)"),
            _buildReportDataRow(
                "Type", report.weaponUsed == "G" ? "Gun" : "Bow"),
            _buildReportDataRow("Successful?", report.isSuccess ? "Yes" : "No"),
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
