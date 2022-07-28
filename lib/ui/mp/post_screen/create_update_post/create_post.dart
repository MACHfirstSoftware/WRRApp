import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class NewPost extends StatefulWidget {
  // final bool isWRRPost;
  const NewPost({
    Key? key,
    // required this.isWRRPost
  }) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  // late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late List<XFile> _images;
  Post? newPost;
  bool _isPostPublished = false;
  FocusNode focusNode = FocusNode();
  String hintText = '...';

  @override
  void initState() {
    _images = [];
    // _titleController = TextEditingController();
    _bodyController = TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = 'Body';
      } else {
        hintText = '...';
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  _validatePostDetails() {
    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
    // if (_titleController.text.isEmpty) {
    //   ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
    //       context: context,
    //       messageText: "Title is required",
    //       type: SnackBarType.error));
    //   return false;
    // }
    if (_bodyController.text.isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Body is required",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _publishPost() async {
    if (_validatePostDetails()) {
      ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      final data = {
        "personId": _user.id,
        "postTypeId": 1,
        "regionId": _user.regionId,
        "countyId": _user.countyId,
        // "title": _titleController.text,
        "title": "General - ${UtilCommon.getDateTimeNow()} - ${_user.code}",
        "body": _bodyController.text,
        "isFlagged": false
      };

      log(data.toString());

      PageLoader.showLoader(context);
      final postResponse = await PostService.postPublish(data);

      postResponse.when(success: (int id) async {
        newPost = Post(
            id: id,
            personId: _user.id,
            firstName: _user.firstName,
            lastName: _user.lastName,
            personCode: _user.code,
            profileImageUrl: _user.profileImageUrl,
            isFollowed: true,
            // title: _titleController.text,
            title: "General - ${UtilCommon.getDateTimeNow()} - ${_user.code}",
            body: _bodyController.text,
            postPersonCounty: _user.countyName!,
            postType: "General",
            isShare: false,
            createdOn: UtilCommon.getDateTimeNow(),
            modifiedOn: UtilCommon.getDateTimeNow(),
            timeAgo: "Just now",
            likes: [],
            comments: [],
            media: [],
            county: County(
                id: _user.countyId,
                name: _user.countyName!,
                regionId: _user.regionId));
        setState(() {
          _isPostPublished = true;
        });
        if (_images.isNotEmpty) {
          List<Map<String, dynamic>> uploadList = [];
          for (XFile image in _images) {
            uploadList.add({
              "postId": newPost!.id,
              "caption": "No Caption",
              "image": ImageUtil.getBase64Image(image.path),
              "fileName": ImageUtil.getImageName(image.name),
              "type": ImageUtil.getImageExtension(image.name),
              "sortOrder": 0
            });
          }
          final imageResponse = await PostService.addPostImage(uploadList);
          imageResponse.when(success: (List<Media> media) {
            newPost?.media = media;

            Provider.of<WRRPostProvider>(context, listen: false)
                .addingNewPost(newPost!);

            final regionPostProvider =
                Provider.of<RegionPostProvider>(context, listen: false);
            if (_user.regionId == regionPostProvider.regionId) {
              regionPostProvider.addingNewPost(newPost!);
            }

            Navigator.pop(context);
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
                context: context,
                messageText: "Successfully published",
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
          Provider.of<WRRPostProvider>(context, listen: false)
              .addingNewPost(newPost!);

          final regionPostProvider =
              Provider.of<RegionPostProvider>(context, listen: false);
          if (_user.regionId == regionPostProvider.regionId) {
            regionPostProvider.addingNewPost(newPost!);
          }
          Navigator.pop(context);
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
              context: context,
              messageText: "Successfully published",
              type: SnackBarType.success));
          Navigator.pop(context);
        }
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

  _uploadImage() async {
    if (_images.isNotEmpty) {
      PageLoader.showLoader(context);
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      List<Map<String, dynamic>> uploadList = [];
      for (XFile image in _images) {
        uploadList.add({
          "postId": newPost!.id,
          "caption": "No Caption",
          "image": ImageUtil.getBase64Image(image.path),
          "fileName": ImageUtil.getImageName(image.name),
          "type": ImageUtil.getImageExtension(image.name),
          "sortOrder": 0
        });
      }
      final imageResponse = await PostService.addPostImage(uploadList);
      imageResponse.when(success: (List<Media> media) {
        newPost?.media = media;
        Provider.of<WRRPostProvider>(context, listen: false)
            .addingNewPost(newPost!);

        final regionPostProvider =
            Provider.of<RegionPostProvider>(context, listen: false);
        if (_user.regionId == regionPostProvider.regionId) {
          regionPostProvider.addingNewPost(newPost!);
        }
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
            context: context,
            messageText: "Successfully published",
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

  // Future<ImageSource?> showImageSource(BuildContext context) {
  //   if (Platform.isIOS) {
  //     return showCupertinoModalPopup<ImageSource>(
  //         context: context,
  //         builder: (context) => CupertinoActionSheet(actions: [
  //               CupertinoActionSheetAction(
  //                   onPressed: () =>
  //                       Navigator.of(context).pop(ImageSource.camera),
  //                   child: const Text("Camera")),
  //               CupertinoActionSheetAction(
  //                   onPressed: () =>
  //                       Navigator.of(context).pop(ImageSource.gallery),
  //                   child: const Text("Gallery")),
  //             ]));
  //   } else {
  //     return showModalBottomSheet<ImageSource>(
  //         context: context,
  //         builder: (context) => Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 ListTile(
  //                     leading: const Icon(Icons.camera_alt_outlined),
  //                     title: const Text("Camera"),
  //                     onTap: () =>
  //                         Navigator.of(context).pop(ImageSource.camera)),
  //                 ListTile(
  //                     leading: const Icon(Icons.image_outlined),
  //                     title: const Text("Gallery"),
  //                     onTap: () =>
  //                         Navigator.of(context).pop(ImageSource.gallery))
  //               ],
  //             ));
  //   }
  // }

  _discardPost() {
    if (_isPostPublished) {
      PostService.postDelete(newPost!.id);
    }
    Navigator.pop(context);
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
                      message: "If you discard now, you'll lose this post.",
                      leftBtnText: "Discard",
                      rightBtnText: "Keep",
                      onTap: _discardPost,
                    )));
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            toolbarHeight: 70.h,
            leading: IconButton(
              iconSize: 25.h,
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.push(
                    context,
                    HeroDialogRoute(
                        builder: (_) => ConfirmationPopup(
                              title: "Discard",
                              message:
                                  "If you discard now, you'll lose this post.",
                              leftBtnText: "Discard",
                              rightBtnText: "Keep",
                              onTap: _discardPost,
                            )));
              },
              icon: const Icon(Icons.close_rounded),
              splashColor: AppColors.btnColor.withOpacity(0.5),
            ),
            title: SizedBox(
                width: 300.w,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      "New Post",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))),
            elevation: 0,
            centerTitle: true,
            actions: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_isPostPublished) {
                        _uploadImage();
                      } else {
                        _publishPost();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      width: 90.w,
                      margin: EdgeInsets.only(right: 10.w),
                      // padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                          color: AppColors.btnColor,
                          borderRadius: BorderRadius.circular(7.5.w)),
                      child: SizedBox(
                        height: 30.h,
                        width: 70.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 15.h,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 25.w),
                //   child: CustomInputField(
                //     controller: _titleController,
                //     label: "Title",
                //     hintText: "Title",
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomInputField(
                    controller: _bodyController,
                    focusNode: focusNode,
                    label: hintText,
                    hintText: "...",
                    maxLines: 5,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Select image(s) to upload",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.btnColor,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
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
                                color: AppColors.popBGColor,
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
      ),
    );
  }
}
