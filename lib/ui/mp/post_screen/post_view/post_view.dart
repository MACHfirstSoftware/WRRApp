import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/add_post/update_post.dart';
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
        likeIndex = widget.post.likes.length;
        widget.post.likes.add(_like);
        _isApiCall = false;
      });
    } else {
      setState(() {
        _isApiCall = false;
      });
    }
  }

  _postLikeDelete() async {
    setState(() {
      _isApiCall = true;
    });
    final res =
        await PostService.postLikeDelete(widget.post.likes[likeIndex!].id);
    if (res) {
      setState(() {
        widget.post.likes.removeAt(likeIndex!);
        likeIndex = null;
        _isApiCall = false;
      });
    } else {
      setState(() {
        _isApiCall = false;
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
      Provider.of<WRRPostProvider>(context, listen: false)
          .deletePost(widget.post);
      Provider.of<CountyPostProvider>(context, listen: false)
          .deletePost(widget.post);
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
                      widget.post.createdOn),
                  _buildPostTitleAndBody(widget.post.title),
                  _buildPostTitleAndBody(widget.post.body, isTitle: false),
                ],
              ),
            ),
          if (widget.post.media.isNotEmpty) MediaView(media: widget.post.media),
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
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: 50.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: _isApiCall
                        ? null
                        : () {
                            if (likeIndex == null) {
                              _postLike();
                            } else {
                              _postLikeDelete();
                            }
                          },
                    icon: Icon(
                      Icons.thumb_up_off_alt_rounded,
                      size: 40.h,
                      color: likeIndex != null
                          ? AppColors.btnColor
                          : AppColors.iconGrey,
                    )),
                IconButton(
                    onPressed: () {
                      // CommentSection cc = const CommentSection(comments: []);
                      // cc.aa();
                    },
                    icon: Icon(
                      Icons.insert_comment_rounded,
                      size: 40.h,
                      color: AppColors.iconGrey,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        HeroDialogRoute(
                            builder: (context) =>
                                PostSharePage(postId: widget.post.id)),
                      );
                    },
                    icon: Icon(
                      Icons.redo_rounded,
                      size: 40.h,
                      color: AppColors.iconGrey,
                    )),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(HeroDialogRoute(
                              builder: (context) => ConfirmationPopup(
                                  onTap: _postAbuse,
                                  title: "Report",
                                  message: "Do you want to report post?",
                                  leftBtnText: "Report",
                                  rightBtnText: "Cancel")));
                        },
                        icon: Icon(
                          Icons.report_gmailerrorred_rounded,
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
              "${widget.post.likes.length} likes",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ),
          CommentSection(
            comments: widget.post.comments,
            postId: widget.post.id,
          )
        ],
      ),
    );
  }

  _buildPostTitleAndBody(String text, {bool isTitle = true}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.5.w),
        child: Text(
          text,
          style: TextStyle(
              fontSize: isTitle ? 18.sp : 16.sp,
              color: isTitle ? Colors.black : Colors.grey[600],
              fontWeight: isTitle ? FontWeight.w600 : FontWeight.w400),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Container _buildPersonRow(String name, String date) {
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
                  UtilCommon.convertToAgo(
                      DateFormat("MM/dd/yyyy HH:mm:ss a").parse(date)),
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
            child: !widget.post.isShare && _user.id == widget.post.personId
                ? PopupMenuButton(
                    icon: Icon(Icons.more_horiz_rounded, size: 40.h),
                    itemBuilder: (context) => [
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
                      if (value == "Edit") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => UpdatePost(
                                    post: widget.post,
                                  )),
                        );
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
                  )
                : Icon(
                    Icons.more_horiz_rounded,
                    size: 40.h,
                  ),
          )
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
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 350.h / 2,
                            child: _imageTile(context, media[3].imageUrl, 0),
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
      child: Image.network(
        url,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}
