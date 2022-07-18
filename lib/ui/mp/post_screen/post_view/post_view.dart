import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/contest.dart';
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
import 'package:wisconsin_app/ui/mp/post_screen/create_update_post/update_post.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_share/post_share.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/comment_section.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/image_preview.dart';
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
  late User _user;
  bool _showComments = false;
  @override
  void initState() {
    _isApiCall = false;
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
                  ? (widget.post.sharePersonFirstName +
                      " " +
                      widget.post.sharePersonLastName)
                  : (widget.post.firstName + " " + widget.post.lastName),
              widget.post.postPersonCounty,
              widget.post.createdOn),
          if (!widget.post.isShare) _buildPostTitleAndBody(widget.post.title),
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
                      widget.post.firstName + " " + widget.post.lastName,
                      widget.post.postPersonCounty,
                      widget.post.createdOn),
                  _buildPostTitleAndBody(widget.post.title),
                  _buildPostTitleAndBody(widget.post.body, isTitle: false),
                ],
              ),
            ),
          if (widget.post.media.isNotEmpty) MediaView(media: widget.post.media),
          if (widget.post.report != null)
            ReportView(report: widget.post.report!),
          if (widget.post.contest != null)
            ContestView(contest: widget.post.contest!),
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
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(5.h),
              //   border: Border.all(
              //     color: Colors.grey[400]!,
              //     width: 1.h
              //   )
              // ),
              // height: 40.h,
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
                    // IconButton(
                    // onPressed: _isApiCall
                    //     ? null
                    //     : () {
                    //         if (likeIndex == null) {
                    //           _postLike();
                    //         } else {
                    //           _postLikeDelete();
                    //         }
                    //       },
                    //     icon: Icon(
                    //       Icons.thumb_up_off_alt_rounded,
                    //       size: 40.h,
                    // color: likeIndex != null
                    //     ? AppColors.btnColor
                    //     : AppColors.iconGrey,
                    //     )),
                    // IconButton(
                    //     onPressed: () {
                    //       // CommentSection cc = const CommentSection(comments: []);
                    //       // cc.aa();
                    //     },

                    // icon: Icon(
                    //   Icons.insert_comment_rounded,
                    //   size: 40.h,
                    //   color: AppColors.iconGrey,
                    // )),

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
                              fit:BoxFit.scaleDown,
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
                           Expanded(
                             child: FittedBox(
                                fit:BoxFit.scaleDown,
                                child: Text(
                                  "Comments",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColors.iconGrey,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
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
                              fit:BoxFit.scaleDown,
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
                    // IconButton(
                    //     onPressed: () {
                    // Navigator.of(context).push(
                    //   HeroDialogRoute(
                    //       builder: (context) =>
                    //           PostSharePage(postId: widget.post.id)),
                    // );
                    //     },
                    //     icon: Icon(
                    //       Icons.redo_rounded,
                    //       size: 40.h,
                    //       color: AppColors.iconGrey,
                    //     )),
                    // Expanded(
                    //   child: Align(
                    //     alignment: Alignment.centerRight,
                    //     child: IconButton(
                    //         onPressed: () {
                    // Navigator.of(context).push(HeroDialogRoute(
                    //     builder: (context) => ConfirmationPopup(
                    //         onTap: _postAbuse,
                    //         title: "Report",
                    //         message: "Do you want to report post?",
                    //         leftBtnText: "Report",
                    //         rightBtnText: "Cancel")));
                    //         },
                    //         icon: Icon(
                    //           Icons.report_gmailerrorred_rounded,
                    //           size: 40.h,
                    //           color: AppColors.iconGrey,
                    //         )),
                    //   ),
                    // ),
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
        child: Text(
          text,
          style: TextStyle(
              fontSize: isTitle ? 16.sp : 12.sp,
              color: isTitle ? Colors.black : Colors.grey[400],
              fontWeight: isTitle ? FontWeight.w500 : FontWeight.w400),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Container _buildPersonRow(String name, String county, DateTime date) {
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
                  name,
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
                Text(
                  county + " County",
                  style: TextStyle(
                      fontSize: 12.sp,
                      // color: Colors.grey[800],
                      color: Colors.black54,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
                Text(
                  UtilCommon.convertToAgo(date),
                  style: TextStyle(
                      fontSize: 11.sp,
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
              child: PopupMenuButton(
                icon: Icon(Icons.more_horiz_rounded, size: 40.h),
                itemBuilder: (context) => [
                  if (!widget.post.isShare && _user.id != widget.post.personId)
                    PopupMenuItem<String>(
                      value: "Report",
                      child: ListTile(
                        title: Text(
                          "Report",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        trailing: const Icon(
                          Icons.error_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (!widget.post.isShare && _user.id == widget.post.personId)
                    const PopupMenuItem<String>(
                      value: "Edit",
                      child: ListTile(
                        title: Text(
                          "Edit",
                        ),
                        trailing: Icon(
                          Icons.mode_edit_outline_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (!widget.post.isShare && _user.id == widget.post.personId)
                    const PopupMenuItem<String>(
                      value: "Delete",
                      child: ListTile(
                        title: Text(
                          "Delete",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        trailing: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    )
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
                  if (value == "Edit") {
                    if (widget.post.report == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => UpdatePost(
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
        height: 350.h,
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
    return _imageTile(context, media[0].imageUrl, 0);
  }

  _buildTwoMedia(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 350.h,
            child: _imageTile(context, media[0].imageUrl, 0),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Expanded(
          child: SizedBox(
            height: 350.h,
            child: _imageTile(context, media[1].imageUrl, 1),
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
            child: _imageTile(context, media[0].imageUrl, 0),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _imageTile(context, media[1].imageUrl, 1),
              ),
              SizedBox(
                height: 3.w,
              ),
              Expanded(
                child: _imageTile(context, media[2].imageUrl, 2),
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
            child: _imageTile(context, media[0].imageUrl, 0),
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
                  child: _imageTile(context, media[1].imageUrl, 1),
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
                        child: _imageTile(context, media[2].imageUrl, 2),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: media.length == 4
                          ? SizedBox(
                              height: 350.h / 2,
                              child: _imageTile(context, media[3].imageUrl, 3),
                            )
                          : Stack(
                              children: [
                                SizedBox(
                                  height: 350.h / 2,
                                  child:
                                      _imageTile(context, media[3].imageUrl, 0),
                                ),
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ImagePreview(medias: media)));
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
                builder: (_) => ImagePreview(medias: media, index: index)));
      },
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) {
          return Image(
            image: imageProvider,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
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
        errorWidget: (context, url, error) =>
            Icon(Icons.error, color: AppColors.btnColor, size: 30.h),
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
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
      margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 0),
      // color: Colors.transparent,
      decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.h),
                    border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 0.75.w),
                      top: BorderSide(color: Colors.black54, width: 0.75.w),
                      left: BorderSide(color: Colors.black54, width: 0.75.w),
                      right: BorderSide(color: Colors.black54, width: 0.75.w),
                    )),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportDataRow("Start time", report.startDateTime,
                isTop: true),
            // _buildReportDataRow("End time : ", report.endDateTime),
            _buildReportDataRow(
                "No. Deer Seen", report.numDeer.toString()),
            _buildReportDataRow(
                "No. Bucks Seen", report.numBucks.toString()),
            _buildReportDataRow(
                "Weather Rating", report.weatherRating.toString()),
            _buildReportDataRow(
                "Duration", "${report.numHours} hour/s"),
            _buildReportDataRow(
                "Type", report.weaponUsed == "A" ? "Bow" : "Gun"),
            _buildReportDataRow(
                "Successful?", report.isSuccess ? "Yes" : "No"),
            // _buildReportDataRow("Hunt success time : ",
            //     "${report.successTime == null || report.successTime == "" ? "-" : report.successTime}"),
          ]),
    );
  }

  _buildReportDataRow(String name, String data, {bool isTop = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
      child: Container(
        alignment: Alignment.centerLeft,
        // height: 30.h,
        width: 428.w,
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
        // decoration: BoxDecoration(
        //     border: Border(
        //         top: isTop
        //             ? BorderSide(
        //                 color: Colors.blueGrey.withOpacity(0.5), width: 1.25.h)
        //             : BorderSide.none,
        //         bottom: BorderSide(
        //             color: Colors.blueGrey.withOpacity(0.5), width: 1.25.h))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                data,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.h),
                    border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 0.75.w),
                      top: BorderSide(color: Colors.black54, width: 0.75.w),
                      left: BorderSide(color: Colors.black54, width: 0.75.w),
                      right: BorderSide(color: Colors.black54, width: 0.75.w),
                    )),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportDataRow("Spread", contest.spread.toString(),
                isTop: true),
            _buildReportDataRow("Length", contest.length.toString()),
            _buildReportDataRow(
                "Number of Tines", contest.numTines.toString()),
            _buildReportDataRow(
                "Length Tines", contest.lengthTines.toString()),
          ]),
    );
  }

  _buildReportDataRow(String name, String data, {bool isTop = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
      child: Container(
        alignment: Alignment.centerLeft,
        // height: 30.h,
        width: 428.w,
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
        // decoration: BoxDecoration(
        //     border: Border(
        //         top: isTop
        //             ? BorderSide(
        //                 color: Colors.blueGrey.withOpacity(0.5), width: 1.25.h)
        //             : BorderSide.none,
        //         bottom: BorderSide(
        //             color: Colors.blueGrey.withOpacity(0.5), width: 1.25.h))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                data,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
