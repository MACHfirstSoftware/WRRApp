import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/comment.dart';
import 'package:wisconsin_app/models/reply_comment.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';

class CommentSection extends StatefulWidget {
  final List<Comment> comments;
  final int postId;
  const CommentSection({Key? key, required this.comments, required this.postId})
      : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  // bool _isSeeAll = false;
  bool _isSubmiting = false;
  bool _isComment = true;
  bool _isUpdate = false;
  String replyTo = '';
  int? _postCommentId;
  int? _commentIndex;
  int? _replyIndex;
  late User _user;
  late TextEditingController _commentController;
  late List<Comment> _comments;
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeEdit = FocusNode();

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _comments = widget.comments;
    _commentController = TextEditingController();
    // focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    focusNode.dispose();
    focusNodeEdit.dispose();
    super.dispose();
  }

  _submitComment() async {
    setState(() {
      _isSubmiting = true;
    });
    // User _user = Provider.of<UserProvider>(context, listen: false).user;
    Comment commentData = Comment(
        id: -1,
        personId: _user.id,
        firstName: _user.firstName,
        lastName: _user.lastName,
        code: _user.code,
        postId: widget.postId,
        body: _commentController.text,
        timeAgo: "Just Now",
        createdOn: UtilCommon.getDateTimeNow(),
        modifiedOn: UtilCommon.getDateTimeNow(),
        replyComments: []);
    final res = await PostService.postComment(commentData);

    if (res != null) {
      commentData.id = res;
      setState(() {
        _comments.add(commentData);
        _isSubmiting = false;
      });
      _commentController.clear();
      FocusScope.of(context).unfocus();
      Provider.of<WRRPostProvider>(context, listen: false).reFreshData();
      Provider.of<RegionPostProvider>(context, listen: false).reFreshData();
      Provider.of<ReportPostProvider>(context, listen: false).reFreshData();
    } else {
      setState(() {
        _isSubmiting = false;
      });
    }
  }

  _submitReplyComment() async {
    setState(() {
      _isSubmiting = true;
    });
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    ReplyComment replyCommentData = ReplyComment(
        id: -1,
        personId: _user.id,
        firstName: _user.firstName,
        lastName: _user.lastName,
        code: _user.code,
        postCommentId: _postCommentId!,
        body: _commentController.text,
        timeAgo: "Just Now",
        createdOn: UtilCommon.getDateTimeNow());
    final res = await PostService.postCommentReply(replyCommentData);
    if (res != null) {
      replyCommentData.id = res;
      // for (int i = 0; i < _comments.length; i++) {
      //   if (_comments[i].id == _postCommentId) {
      //     _comments[i].replyComments.add(replyCommentData);
      //     break;
      //   }
      // }
      _comments[_commentIndex!].replyComments.add(replyCommentData);
      setState(() {
        _isComment = true;
        _postCommentId = null;
        _commentIndex = null;
        replyTo = '';
        _isSubmiting = false;
      });
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        _isSubmiting = false;
      });
    }
  }

  _editComment() async {
    PageLoader.showLoader(context);
    Comment _comment = widget.comments[_commentIndex!];
    final res =
        await PostService.editComment(_comment.id, _commentController.text);
    Navigator.pop(context);
    if (res) {
      setState(() {
        widget.comments[_commentIndex!].body = _commentController.text;
        _isUpdate = false;
        _isComment = true;
      });
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  _editCommentReply() async {
    PageLoader.showLoader(context);
    ReplyComment _replyComment =
        widget.comments[_commentIndex!].replyComments[_replyIndex!];
    final res = await PostService.editCommentReply(
        _replyComment.id, _commentController.text);
    Navigator.pop(context);
    if (res) {
      setState(() {
        widget.comments[_commentIndex!].replyComments[_replyIndex!].body =
            _commentController.text;
        _isUpdate = false;
        _isComment = true;
      });
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  _deleteComment(int commentId, int commentIndex) async {
    final res = await PostService.postCommentDelete(commentId);
    if (res) {
      setState(() {
        _comments.removeAt(commentIndex);
      });
      Provider.of<WRRPostProvider>(context, listen: false).reFreshData();
      Provider.of<RegionPostProvider>(context, listen: false).reFreshData();
      Provider.of<ReportPostProvider>(context, listen: false).reFreshData();
    }
  }

  _deleteCommentReply(
      int commentReplyId, int commentIndex, int replyIndex) async {
    final res = await PostService.postCommentReplyDelete(commentReplyId);
    if (res) {
      setState(() {
        _comments[commentIndex].replyComments.removeAt(replyIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (!_isSeeAll && _comments.isNotEmpty)
        //   _buildCommentTile(_comments[0], 0),
        // if (_isSeeAll)
        for (int index = 0; index < _comments.length; index++)
          _buildCommentTile(_comments[index], index),
        // if (_comments.length > 1) _buildShowMoreIcon(),
        _isUpdate ? _buildEditField() : _buildWriteComment(),
      ],
    );
  }

  _buildCommentTile(Comment _comment, int commentIndex) {
    // print(_comment.createdOn);
    // print(_comment.body);
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.h),
              child: FocusedMenuHolder(
                onPressed: () {},
                menuWidth: 200.w,
                blurSize: 0.0,
                menuItemExtent: 45.h,
                menuBoxDecoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                duration: const Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black12,
                menuItems: [
                  FocusedMenuItem(
                      title: const Text("Reply"),
                      trailingIcon: const Icon(
                        Icons.reply_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _commentController.clear();
                        setState(() {
                          _isComment = false;
                          _isUpdate = false;
                          _postCommentId = _comment.id;
                          _commentIndex = commentIndex;
                          replyTo = _comment.code;
                        });
                        focusNode.requestFocus();
                      }),
                  if (_user.id == _comment.personId)
                    FocusedMenuItem(
                        title: const Text(
                          "Edit",
                        ),
                        trailingIcon: const Icon(
                          Icons.mode_edit_outline_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _commentIndex = commentIndex;
                            _isUpdate = true;
                            _isComment = true;
                            _commentController.text = _comment.body;
                          });
                          focusNodeEdit.requestFocus();
                          // FocusScope.of(context).requestFocus(focusNodeEdit);
                        }),
                  if (_user.id == _comment.personId)
                    FocusedMenuItem(
                        title: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        trailingIcon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          _deleteComment(_comment.id, commentIndex);
                        }),
                ],
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.h),
                  title: Text(_comment.code,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500)),
                  subtitle: Text(_comment.body,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Text(UtilCommon.toAgoShortForm(_comment.timeAgo)),
                SizedBox(
                  width: 30.w,
                ),
                GestureDetector(
                    onTap: () {
                      _commentController.clear();
                      setState(() {
                        _isComment = false;
                        _isUpdate = false;
                        _postCommentId = _comment.id;
                        _commentIndex = commentIndex;
                        replyTo = _comment.code;
                      });
                      focusNode.requestFocus();
                    },
                    child: const Text("Reply")),
              ],
            ),
            for (int index = 0; index < _comment.replyComments.length; index++)
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 10.w),
                child: _buildReplyCommentTile(
                    _comment.replyComments[index], commentIndex, index),
              ),
          ],
        ),
      ),
    );
  }

  _buildReplyCommentTile(
      ReplyComment replyComment, int commentIndex, int replyIndex) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.h),
              child: _user.id == replyComment.personId
                  ? FocusedMenuHolder(
                      onPressed: () {},
                      menuWidth: 200.w,
                      blurSize: 0.0,
                      menuItemExtent: 45.h,
                      menuBoxDecoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      duration: const Duration(milliseconds: 100),
                      animateMenuItems: true,
                      blurBackgroundColor: Colors.black12,
                      menuItems: [
                        FocusedMenuItem(
                            title: const Text(
                              "Edit",
                            ),
                            trailingIcon: const Icon(
                              Icons.mode_edit_outline_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _commentIndex = commentIndex;
                                _replyIndex = replyIndex;
                                _isUpdate = true;
                                _isComment = false;
                                _commentController.text = replyComment.body;
                              });
                              focusNodeEdit.requestFocus();
                            }),
                        FocusedMenuItem(
                            title: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            trailingIcon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              _deleteCommentReply(
                                  replyComment.id, commentIndex, replyIndex);
                            }),
                      ],
                      child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.h),
                          title: Text(replyComment.code,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text(replyComment.body,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400))),
                    )
                  : ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.h),
                      title: Text(replyComment.code,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500)),
                      subtitle: Text(replyComment.body,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400)),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(UtilCommon.toAgoShortForm(replyComment.timeAgo)),
            ),
          ],
        ),
      ),
    );
  }

  // _buildShowMoreIcon() {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _isSeeAll = !_isSeeAll;
  //       });
  //     },
  //     child: Icon(_isSeeAll
  //         ? Icons.keyboard_arrow_up_rounded
  //         : Icons.keyboard_arrow_down_rounded),
  //   );
  // }

  _buildWriteComment() {
    return Container(
      color: Colors.transparent,
      width: 428.w,
      margin: EdgeInsets.symmetric(vertical: 7.5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          if (!_isComment)
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              color: Colors.transparent,
              height: 25.h,
              child: RichText(
                  text: TextSpan(
                      text: "Replying to $replyTo  ",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                    TextSpan(
                      text: " Cancel",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _isComment = true;
                            _postCommentId = null;
                            _commentIndex = null;
                            _isSubmiting = false;
                            replyTo = '';
                          });
                        },
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w400),
                    )
                  ])),
            ),
          SizedBox(
            height: 50.h,
            child: TextField(
              controller: _commentController,
              focusNode: focusNode,
              readOnly: _isSubmiting,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.sp,
                  decoration: TextDecoration.none),
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.btnColor,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: EdgeInsets.all(10.h),
                  child: GestureDetector(
                    onTap: () {
                      if (_commentController.text.isNotEmpty && !_isSubmiting) {
                        if (_isComment) {
                          _submitComment();
                        } else {
                          _submitReplyComment();
                        }
                      }
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: AppColors.btnColor,
                      size: 25.h,
                    ),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                fillColor: Colors.transparent,
                filled: false,
                hintText: _isComment
                    ? "Write a comment..."
                    : "Replying to $replyTo...",
                hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.sp,
                    decoration: TextDecoration.none),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(10.h)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(10.h)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(10.h)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEditField() {
    return Container(
      color: Colors.transparent,
      width: 428.w,
      margin: EdgeInsets.symmetric(vertical: 7.5.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            focusNode: focusNodeEdit,
            maxLines: 3,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16.sp,
                decoration: TextDecoration.none),
            textAlignVertical: TextAlignVertical.center,
            cursorColor: AppColors.btnColor,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              fillColor: Colors.transparent,
              filled: false,
              hintText: "Write something...",
              hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.sp,
                  decoration: TextDecoration.none),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                  borderRadius: BorderRadius.circular(5.w)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                  borderRadius: BorderRadius.circular(5.w)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                  borderRadius: BorderRadius.circular(5.w)),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _commentController.clear();
                  setState(() {
                    _isUpdate = false;
                    _commentIndex = null;
                    _replyIndex = null;
                    _isComment = true;
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.5.h),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5.w),
                    //     color: Colors.transparent,
                    //     border:
                    //         Border.all(color: AppColors.btnColor, width: 1.5.w)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              // SizedBox(
              //   width: 15.w,
              // ),
              GestureDetector(
                onTap: () {
                  if (_commentController.text.isNotEmpty) {
                    if (_isComment) {
                      _editComment();
                    } else {
                      _editCommentReply();
                    }
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.5.h),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(5.w),
                    //   color: AppColors.btnColor,
                    // ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Update",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.btnColor,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              // SizedBox(
              //   width: 15.w,
              // ),
            ],
          )
        ],
      ),
    );
  }

  // _buildSeeAll() {
  //   // return LimitedBox(
  //   //   maxHeight: 300.h,
  //   //   child: ListView.builder(
  //   //       scrollDirection: Axis.vertical,
  //   //       shrinkWrap: true,
  //   //       itemCount: _comments.length,
  //   //       itemBuilder: (_, index) {
  //   //         return _buildCommentTile(_comments[index], index);
  //   //       }),
  //   // );
  //   return List.generate(_comments.length,
  //       (index) => _buildCommentTile(_comments[index], index));
  // }
}
