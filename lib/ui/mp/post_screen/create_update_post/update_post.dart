import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class UpdatePost extends StatefulWidget {
  final Post post;
  const UpdatePost({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  List<XFile> _images = [];
  List<Media> _medias = [];
  Media? _mediaForDelete;
  // Post? newPost;
  bool _isPostUpdate = false;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
    _medias = widget.post.media;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  _validatePostDetails() {
    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Title is required",
          type: SnackBarType.error));
      return false;
    }
    if (_bodyController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Body is required",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  String _getImageName(String str) {
    str = str.replaceAll('.jpg', '');
    str = str.replaceAll('.png', '');
    str = str.replaceAll('.jpeg', '');
    return str;
  }

  String _getImageExtension(String str) {
    if (str.contains(".jpeg")) {
      return ".jpeg";
    }
    if (str.contains(".png")) {
      return ".png";
    }
    return ".jpg";
  }

  _updatePost() async {
    if (_validatePostDetails()) {
      ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
      PageLoader.showLoader(context);
      final updateResponse = await PostService.updatePost(
          widget.post.id, _titleController.text, _bodyController.text);

      if (updateResponse) {
        User _user = Provider.of<UserProvider>(context, listen: false).user;
        setState(() {
          _isPostUpdate = true;
        });
        if (_images.isNotEmpty) {
          List<Map<String, dynamic>> uploadList = [];
          for (XFile image in _images) {
            final bytes = File(image.path).readAsBytesSync();
            String img64 = base64Encode(bytes);
            uploadList.add({
              "postId": widget.post.id,
              "caption": "No Caption",
              "image": img64,
              "fileName": _getImageName(image.name),
              "type": _getImageExtension(image.name),
              "sortOrder": 0
            });
          }
          final imageResponse = await PostService.addPostImage(uploadList);
          imageResponse.when(success: (List<Media> media) {
            Post _updatedPost = widget.post;
            _updatedPost.title = _titleController.text;
            _updatedPost.body = _bodyController.text;
            _updatedPost.media = media;
//------------------------------------------ change bellow to update------------------

            Provider.of<WRRPostProvider>(context, listen: false)
                .updatePost(_updatedPost);
            Provider.of<CountyPostProvider>(context, listen: false)
                .updatePost(_updatedPost);

//---------------------------------------------------------------------------------------
            Navigator.pop(context);
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
                context: context,
                messageText: "Successfully updated",
                type: SnackBarType.success));
            Navigator.pop(context);
          }, failure: (NetworkExceptions error) {
            Navigator.pop(context);
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
                context: context,
                messageText: NetworkExceptions.getErrorMessage(error),
                type: SnackBarType.error));
          }, responseError: (ResponseError responseError) {
            Navigator.pop(context);
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
                context: context,
                messageText: responseError.error,
                type: SnackBarType.error));
          });
        } else {
          Post _updatedPost = widget.post;
          _updatedPost.title = _titleController.text;
          _updatedPost.body = _bodyController.text;
          _updatedPost.media = _medias;
//------------------------------------------ change bellow to update------------------
          Provider.of<WRRPostProvider>(context, listen: false)
              .updatePost(_updatedPost);
          Provider.of<CountyPostProvider>(context, listen: false)
              .updatePost(_updatedPost);
//---------------------------------------------------------------------------------------
          Navigator.pop(context);
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
              context: context,
              messageText: "Successfully updated",
              type: SnackBarType.success));
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
            context: context,
            messageText: "Post update failed.",
            type: SnackBarType.error));
      }
    }
  }

  _updateImage() async {
    if (_images.isNotEmpty) {
      PageLoader.showLoader(context);
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      List<Map<String, dynamic>> uploadList = [];
      for (XFile image in _images) {
        final bytes = File(image.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        uploadList.add({
          "postId": widget.post.id,
          "caption": "No Caption",
          "image": img64,
          "fileName": _getImageName(image.name),
          "type": _getImageExtension(image.name),
          "sortOrder": 0
        });
      }
      final imageResponse = await PostService.addPostImage(uploadList);
      imageResponse.when(success: (List<Media> media) {
        Post _updatedPost = widget.post;
        _updatedPost.title = _titleController.text;
        _updatedPost.body = _bodyController.text;
        _updatedPost.media = media;
//------------------------------------------ change bellow to update------------------
        Provider.of<WRRPostProvider>(context, listen: false)
            .updatePost(_updatedPost);
        Provider.of<CountyPostProvider>(context, listen: false)
            .updatePost(_updatedPost);
//---------------------------------------------------------------------------------------
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
            context: context,
            messageText: "Successfully updated",
            type: SnackBarType.success));
        Navigator.pop(context);
      }, failure: (NetworkExceptions error) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
            context: context,
            messageText: NetworkExceptions.getErrorMessage(error),
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
            context: context,
            messageText: responseError.error,
            type: SnackBarType.error));
      });
    }
  }

  final picker = ImagePicker();

  Future getImage() async {
    try {
      final pickedFile = await picker.pickMultiImage();
      if (pickedFile == null) {
        return;
      } else {
        setState(() {
          _images.addAll(pickedFile);
        });
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
    }
  }

  _discardPost() {
    if (widget.post.media.length > _medias.length) {
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      Post _updatedPost = widget.post;
      _updatedPost.media = _medias;

      Provider.of<WRRPostProvider>(context, listen: false)
          .updatePost(_updatedPost);
      Provider.of<CountyPostProvider>(context, listen: false)
          .updatePost(_updatedPost);
    }
    if (_isPostUpdate) {
      PostService.updatePost(
          widget.post.id, widget.post.title, widget.post.body);
    }
    Navigator.pop(context);
  }

  _removeImage() async {
    PageLoader.showLoader(context);
    final res = await PostService.imageDelete(_mediaForDelete!.id);
    Navigator.pop(context);
    if (res) {
      setState(() {
        _medias.remove(_mediaForDelete);
        _mediaForDelete = null;
      });
    } else {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to remove image",
          type: SnackBarType.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.push(
            context,
            HeroDialogRoute(
                builder: (_) => ConfirmationPopup(
                      title: "Discard",
                      message: "If you discard now, you'll lose these changes.",
                      leftBtnText: "Discard",
                      rightBtnText: "Keep",
                      onTap: _discardPost,
                    )));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .8],
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    HeroDialogRoute(
                        builder: (_) => ConfirmationPopup(
                              title: "Discard",
                              message:
                                  "If you discard now, you'll lose these changes.",
                              leftBtnText: "Discard",
                              rightBtnText: "Keep",
                              onTap: _discardPost,
                            )));
              },
              icon: const Icon(Icons.close_rounded),
              splashColor: AppColors.btnColor.withOpacity(0.5),
            ),
            title: Text(
              "Update WRR",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.btnColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            elevation: 0,
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () {
                  if (_isPostUpdate) {
                    _updateImage();
                  } else {
                    _updatePost();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10.w),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(7.5.w)),
                  child: Text(
                    "Apply",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomInputField(
                  controller: _titleController,
                  label: "Title",
                  hintText: "Title",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomInputField(
                  controller: _bodyController,
                  label: "Body",
                  hintText: "Body",
                  maxLines: 5,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                child: Scrollbar(
                  thickness: 5.w,
                  showTrackOnHover: true,
                  isAlwaysShown: true,
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.w,
                    mainAxisSpacing: 5.w,
                    shrinkWrap: true,
                    children: [
                      ..._medias.map((media) => Stack(
                            children: [
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.5),
                                      borderRadius:
                                          BorderRadius.circular(7.5.w)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.5.w),
                                    child: CachedNetworkImage(
                                      imageUrl: media.imageUrl,
                                      imageBuilder: (context, imageProvider) {
                                        return Image(
                                          image: imageProvider,
                                          height: 300.h,
                                          width: 360.w,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: SizedBox(
                                          height: 15.h,
                                          width: 15.h,
                                          child: CircularProgressIndicator(
                                            value: progress.progress,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error,
                                              color: AppColors.btnColor,
                                              size: 15.h),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    _mediaForDelete = media;
                                    Navigator.push(
                                        context,
                                        HeroDialogRoute(
                                            builder: (_) => ConfirmationPopup(
                                                  title: "Remove",
                                                  message:
                                                      "This image is currently available in the post. If you remove now, no longer available this image.",
                                                  leftBtnText: "Remove",
                                                  rightBtnText: "Keep",
                                                  onTap: _removeImage,
                                                )));
                                    //------------------------------------------------------------
                                  },
                                  child: SizedBox(
                                    height: 50.w,
                                    width: 50.w,
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      size: 30.w,
                                      color: AppColors.btnColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      ..._images.map(
                        (image) => Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.5.w),
                                child: Image.file(
                                  File(image.path),
                                  height: 300.h,
                                  width: 360.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _images.remove(image);
                                  });
                                },
                                child: SizedBox(
                                  height: 50.w,
                                  width: 50.w,
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size: 30.w,
                                    color: AppColors.btnColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.secondaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7.5.w)),
                          child: Icon(Icons.camera_alt_rounded,
                              color: AppColors.btnColor, size: 30.h),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}