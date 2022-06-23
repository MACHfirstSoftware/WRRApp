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
  bool _isMeLike() {
    bool likeMe = false;
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    for (Like like in widget.post.likes) {
      if (like.personId == _user.id) {
        likeMe = true;
        break;
      }
    }
    return likeMe;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.media.isNotEmpty) {
      print(widget.post.media[0].imageUrl);
    }
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 5.w),
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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      if (!_isMeLike()) {
                        User _user =
                            Provider.of<UserProvider>(context, listen: false)
                                .user;
                        Like _like = Like(
                            id: -1,
                            personId: _user.id,
                            firstName: _user.firstName,
                            lastName: _user.lastName,
                            createdOn: UtilCommon.getDateTimeNow(),
                            postId: widget.post.id);

                        final res = await PostService.postLike(_like);
                        if (res) {
                          setState(() {
                            widget.post.likes.add(_like);
                          });
                        }
                      }
                    },
                    icon: Icon(
                      Icons.thumb_up_off_alt_rounded,
                      size: 40.h,
                      color:
                          _isMeLike() ? AppColors.btnColor : AppColors.iconGrey,
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
          // Container(
          //   alignment: Alignment.center,
          //   color: Colors.white,
          //   height: 80.h,
          //   child: Text(
          //     "Comments appeare here",
          //     style: TextStyle(
          //         fontSize: 16.sp,
          //         color: Colors.black,
          //         fontWeight: FontWeight.w600),
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          CommentSection(
            comments: widget.post.comments,
            postId: widget.post.id,
          )
        ],
      ),
    );
  }
}
