import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/comment.dart';
import 'package:wisconsin_app/models/reply_comment.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/utils/common.dart';

// GlobalKey<_CommentSectionState> globalKey = GlobalKey();

class CommentSection extends StatefulWidget {
  final List<Comment> comments;
  final int postId;
  const CommentSection({Key? key, required this.comments, required this.postId})
      : super(key: key);
  // aa() {
  //   print("-----------------------------");
  //   _CommentSectionState ss = _CommentSectionState();
  //   ss.bb();
  // }

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool _isSeeAll = false;
  bool _isSubmiting = false;
  bool _isComment = true;
  String replyTo = '';
  int? _postCommentId;
  late TextEditingController _commentController;
  late List<Comment> _comments;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    _comments = widget.comments;
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // bb() {
  //   print("bbb---------");

  //   _isComment = true;
  //   if (mounted) {
  //     print("MOUNTED---------");
  //     FocusScope.of(context).requestFocus(focusNode);
  //   }
  //   focusNode.requestFocus();
  // }

  _submitComment() async {
    setState(() {
      _isSubmiting = true;
    });
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    Comment commentData = Comment(
        id: -1,
        personId: _user.id,
        firstName: _user.firstName,
        lastName: _user.lastName,
        postId: widget.postId,
        body: _commentController.text,
        createdOn: UtilCommon.getDateTimeNow(),
        modifiedOn: UtilCommon.getDateTimeNow(),
        replyComments: []);
    final res = await PostService.postComment(commentData);

    if (res) {
      setState(() {
        _comments.add(commentData);
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
        postCommentId: _postCommentId!,
        body: _commentController.text,
        createdOn: UtilCommon.getDateTimeNow());
    final res = await PostService.postCommentReply(replyCommentData);
    if (res) {
      for (int i = 0; i < _comments.length; i++) {
        if (_comments[i].id == _postCommentId) {
          _comments[i].replyComments.add(replyCommentData);
          break;
        }
      }
      setState(() {
        _isComment = true;
        _postCommentId = null;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_isSeeAll && _comments.isNotEmpty) _buildCommentTile(_comments[0]),
        if (_isSeeAll) _buildSeeAll(),
        if (_comments.length > 1) _buildShowMoreIcon(),
        _buildWriteComment(),
      ],
    );
  }

  _buildCommentTile(Comment _comment) {
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
              borderRadius: BorderRadius.circular(15.w),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                title: Text(_comment.firstName + " " + _comment.lastName),
                subtitle: Text(_comment.body),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Text(UtilCommon.convertToAgoShort(
                    DateFormat("MM/dd/yyyy HH:mm:ss a")
                        .parse(_comment.createdOn))),
                SizedBox(
                  width: 30.w,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _isComment = false;
                        _postCommentId = _comment.id;
                        replyTo = _comment.firstName + " " + _comment.lastName;
                      });
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                    child: const Text("Reply")),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 10.w),
              child: LimitedBox(
                maxHeight: 250.h,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _comment.replyComments.length,
                    itemBuilder: (_, index) {
                      return _buildReplyCommentTile(
                          _comment.replyComments[index]);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildReplyCommentTile(ReplyComment replyComment) {
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
              borderRadius: BorderRadius.circular(15.w),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                title:
                    Text(replyComment.firstName + " " + replyComment.lastName),
                subtitle: Text(replyComment.body),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(UtilCommon.convertToAgoShort(
                  DateFormat("MM/dd/yyyy HH:mm:ss a")
                      .parse(replyComment.createdOn))),
            ),
          ],
        ),
      ),
    );
  }

  _buildShowMoreIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSeeAll = !_isSeeAll;
        });
      },
      child: Icon(_isSeeAll
          ? Icons.keyboard_arrow_up_rounded
          : Icons.keyboard_arrow_down_rounded),
    );
  }

  _buildWriteComment() {
    return Container(
      color: Colors.transparent,
      width: 428.w,
      margin: EdgeInsets.symmetric(vertical: 7.5.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                  padding: EdgeInsets.all(10.w),
                  child: GestureDetector(
                    onTap: () {
                      // print(DateTime.now().toString());
                      // print(UtilCommon.getDateTimeNow());
                      if (_commentController.text.isNotEmpty && !_isSubmiting) {
                        if (_isComment) {
                          _submitComment();
                        } else {
                          _submitReplyComment();
                        }
                      }
                      print("send..........");
                    },
                    child: const Icon(
                      Icons.send_rounded,
                      color: AppColors.btnColor,
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
                    borderRadius: BorderRadius.circular(15.w)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(15.w)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(15.w)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSeeAll() {
    return LimitedBox(
      maxHeight: 300.h,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _comments.length,
          itemBuilder: (_, index) {
            return _buildCommentTile(_comments[index]);
          }),
    );
  }
}
