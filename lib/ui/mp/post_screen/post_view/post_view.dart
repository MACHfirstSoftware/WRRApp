import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/like.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/comment_section.dart';
import 'package:wisconsin_app/utils/common.dart';

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

  // bool _isMeLike() {
  //   bool likeMe = false;
  //   for (Like like in widget.post.likes) {
  //     if (like.personId == _user.id) {
  //       likeMe = true;
  //       break;
  //     }
  //   }
  //   return likeMe;
  // }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      color: Colors.white,
      width: 428.w,
      child: Column(
        children: [
          Container(
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
                        widget.post.firstName + " " + widget.post.lastName,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        UtilCommon.convertToAgo(
                            DateFormat("MM/dd/yyyy HH:mm:ss a")
                                .parse(widget.post.createdOn)),
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
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person_add_alt_rounded,
                        size: 40.h,
                        color: AppColors.btnColor,
                      )),
                )
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 300.h,
            width: 428.w,
            margin: EdgeInsets.symmetric(horizontal: 3.5.w),
            child: widget.post.media.isNotEmpty
                ? Image.network(
                    widget.post.media[0].imageUrl,
                    width: 421.w,
                    height: 300.h,
                    fit: BoxFit.fill,
                  )
                // ? CachedNetworkImage(
                //     imageUrl:
                //         "https://static.remove.bg/remove-bg-web/913b22608288cd03cc357799d0d4594e2d1c6b41/assets/start_remove-c851bdf8d3127a24e2d137a55b1b427378cd17385b01aec6e59d5d4b5f39d2ec.png",
                //     // imageBuilder: (context, imageProvider) => SizedBox(
                //     //   height: 300.h,
                //     //   width: 421.w,
                //     //   child: Image(
                //     //     image: imageProvider,
                //     //     fit: BoxFit.fill,
                //     //   ),
                //     // ),

                //     imageBuilder: (context, imageProvider) => Container(
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //             image: imageProvider,
                //             fit: BoxFit.cover,
                //             colorFilter: const ColorFilter.mode(
                //                 Colors.red, BlendMode.colorBurn)),
                //       ),
                //     ),
                //     // placeholder: (context, url) => ViewModels.postLoader(),
                //     progressIndicatorBuilder:
                //         (context, url, downloadProgress) =>
                //             CircularProgressIndicator(
                //                 value: downloadProgress.progress),
                //     errorWidget: (context, url, error) =>
                //         const Icon(Icons.error),
                //   )
                : const Icon(Icons.warning_amber_rounded),
            // child: Image.asset(
            //   "assets/images/bg.png",
            //   fit: BoxFit.fill,
            // )
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.redo_rounded,
                      size: 40.h,
                      color: AppColors.iconGrey,
                    )),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_horiz_rounded,
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
}
