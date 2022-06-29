import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class AddPost extends StatefulWidget {
  final bool isWRRPost;
  const AddPost({Key? key, required this.isWRRPost}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  XFile? _image;
  int? _postId;
  bool _isPostPublished = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _image = null;
    super.dispose();
  }

  _validatePostDetails() {
    scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    if (_titleController.text.isEmpty) {
      scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Title is required",
          type: SnackBarType.error));
      return false;
    }
    if (_bodyController.text.isEmpty) {
      scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Body is required",
          type: SnackBarType.error));
      return false;
    }
    // if () {
    //   scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
    //       context: context,
    //       messageText: "Password is incorrect",
    //       type: SnackBarType.error));
    //   return false;
    // }
    return true;
  }

  String _getImageName(String str) {
    str = str.replaceAll('.jpg', '');
    str = str.replaceAll('.png', '');
    str = str.replaceAll('.jpeg', '');
    return str;
  }

  String _getImageExtension(String str) {
    // if(str.contains(".jpg")){return ".jpg";}
    if (str.contains(".jpeg")) {
      return ".jpeg";
    }
    if (str.contains(".png")) {
      return ".png";
    }
    return ".jpg";
  }

  _publishPost() async {
    if (_validatePostDetails()) {
      scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      final data = {
        "personId": _user.id,
        "postTypeId": 1,
        "regionId": _user.regionId,
        "countyId": _user.countyId,
        "title": _titleController.text,
        "body": _bodyController.text,
        "isFlagged": false
      };

      PageLoader.showLoader(context);
      final postResponse = await PostService.postPublish(data);

      postResponse.when(success: (int id) async {
        if (_image != null) {
          final bytes = File(_image!.path).readAsBytesSync();
          String img64 = base64Encode(bytes);
          final imageData = {
            "postId": id,
            "caption": "No Caption",
            "image": img64,
            "fileName": _getImageName(_image!.name),
            "type": _getImageExtension(_image!.name),
            "sortOrder": 0
          };
          setState(() {
            _postId = id;
            _isPostPublished = true;
          });
          final imageResponse = await PostService.addPostImage([]);
          imageResponse.when(success: (List<Media> media) {
            Post _post = Post(
                id: id,
                personId: _user.id,
                firstName: _user.firstName,
                lastName: _user.lastName,
                isShare: false,
                title: _titleController.text,
                body: _bodyController.text,
                createdOn: UtilCommon.getDateTimeNow(),
                modifiedOn: UtilCommon.getDateTimeNow(),
                likes: [],
                comments: [],
                media: media);
            if (widget.isWRRPost) {
              Provider.of<WRRPostProvider>(context, listen: false)
                  .addingNewPost(_post);
            } else {
              final countyPostProvider =
                  Provider.of<CountyPostProvider>(context, listen: false);
              if (_user.countyId == countyPostProvider.countyId) {
                countyPostProvider.addingNewPost(_post);
              }
            }

            Navigator.pop(context);
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
                context: context,
                messageText: "Successfully published",
                type: SnackBarType.success));
            Navigator.pop(context);
          }, failure: (NetworkExceptions error) {
            Navigator.pop(context);
            scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
                context: context,
                messageText: NetworkExceptions.getErrorMessage(error),
                type: SnackBarType.error));
          }, responseError: (ResponseError responseError) {
            Navigator.pop(context);
            scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
                context: context,
                messageText: responseError.error,
                type: SnackBarType.error));
          });
        } else {
          Post _post = Post(
              id: id,
              personId: _user.id,
              firstName: _user.firstName,
              lastName: _user.lastName,
              isShare: false,
              title: _titleController.text,
              body: _bodyController.text,
              createdOn: UtilCommon.getDateTimeNow(),
              modifiedOn: UtilCommon.getDateTimeNow(),
              likes: [],
              comments: [],
              media: []);
          if (widget.isWRRPost) {
            Provider.of<WRRPostProvider>(context, listen: false)
                .addingNewPost(_post);
          } else {
            final countyPostProvider =
                Provider.of<CountyPostProvider>(context, listen: false);
            if (_user.countyId == countyPostProvider.countyId) {
              countyPostProvider.addingNewPost(_post);
            }
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
        scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
            context: context,
            messageText: NetworkExceptions.getErrorMessage(error),
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
        Navigator.pop(context);
        scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
            context: context,
            messageText: responseError.error,
            type: SnackBarType.error));
      });
    }
  }

  _uploadImage() async {
    if (_image != null) {
      PageLoader.showLoader(context);
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      final bytes = File(_image!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      final imageData = {
        "postId": _postId!,
        "caption": "No Caption",
        "image": img64,
        "fileName": _getImageName(_image!.name),
        "type": _getImageExtension(_image!.name),
        "sortOrder": 0
      };
      final imageResponse = await PostService.addPostImage([]);
      imageResponse.when(success: (List<Media> media) {
        Post _post = Post(
            id: _postId!,
            personId: _user.id,
            firstName: _user.firstName,
            lastName: _user.lastName,
            isShare: false,
            title: _titleController.text,
            body: _bodyController.text,
            createdOn: UtilCommon.getDateTimeNow(),
            modifiedOn: UtilCommon.getDateTimeNow(),
            likes: [],
            comments: [],
            media: media);
        if (widget.isWRRPost) {
          Provider.of<WRRPostProvider>(context, listen: false)
              .addingNewPost(_post);
        } else {
          final countyPostProvider =
              Provider.of<CountyPostProvider>(context, listen: false);
          if (_user.countyId == countyPostProvider.countyId) {
            countyPostProvider.addingNewPost(_post);
          }
        }
        Navigator.pop(context);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
            context: context,
            messageText: "Successfully published",
            type: SnackBarType.success));
        Navigator.pop(context);
      }, failure: (NetworkExceptions error) {
        Navigator.pop(context);
        scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
            context: context,
            messageText: NetworkExceptions.getErrorMessage(error),
            type: SnackBarType.error));
      }, responseError: (ResponseError responseError) {
        Navigator.pop(context);
        scaffoldMessengerKey.currentState?.showSnackBar(customSnackBar(
            context: context,
            messageText: responseError.error,
            type: SnackBarType.error));
      });
    }
  }

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) {
        return;
      } else {
        setState(() {
          _image = pickedFile;
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

  Future<ImageSource?> showImageSource(BuildContext context) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) => CupertinoActionSheet(actions: [
                CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.camera),
                    child: const Text("Camera")),
                CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.gallery),
                    child: const Text("Gallery")),
              ]));
    } else {
      return showModalBottomSheet<ImageSource>(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      leading: const Icon(Icons.camera_alt_outlined),
                      title: const Text("Camera"),
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.camera)),
                  ListTile(
                      leading: const Icon(Icons.image_outlined),
                      title: const Text("Gallery"),
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.gallery))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: 400.w,
          height: 700.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .8],
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
              ),
              borderRadius: BorderRadius.circular(20.w)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                const Spacer(),
                Text(
                  "Add Post",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.btnColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomInputField(
                  controller: _titleController,
                  label: "Title",
                  hintText: "Title",
                ),
                CustomInputField(
                  controller: _bodyController,
                  label: "Body",
                  hintText: "Body",
                  maxLines: 5,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: 300.h,
                  width: 360.w,
                  color: Colors.grey[100],
                  child: Stack(
                    children: [
                      Center(
                        child: _image != null
                            ? Image.file(
                                File(_image!.path),
                                height: 300.h,
                                width: 360.w,
                                fit: BoxFit.fill,
                              )
                            : const SizedBox(),
                      ),
                      if (_image != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            // splashColor: AppColors.btnColor.withOpacity(0.5),
                            // // splashColor: AppColors.btnColor.withOpacity(0.5),
                            // hoverColor: AppColors.btnColor.withOpacity(0.5),
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
                      if (_image == null)
                        Center(
                          child: InkWell(
                            onTap: () async {
                              ImageSource? source =
                                  await showImageSource(context);
                              if (source != null) {
                                getImage(source);
                              } else {
                                if (kDebugMode) {
                                  print("Get image source failed");
                                }
                              }
                            },
                            child: SizedBox(
                              height: 60.w,
                              width: 60.w,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 40.w,
                                color: AppColors.btnColor,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [_cancel(), _publish()],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cancel() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 2.5.w,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 24.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  _publish() {
    return GestureDetector(
      onTap: () {
        // final bytes = File(_image!.path).readAsBytesSync();
        // String img64 = base64Encode(bytes);
        // log(img64);
        // log(_getImageName(_image!.name));
        // log(_image!.name);
        // log(_getImageExtension(_image!.name));
        FocusScope.of(context).requestFocus(FocusNode());
        if (_isPostPublished) {
          _uploadImage();
        } else {
          _publishPost();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
            color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(5.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Colors.white,
              size: 24.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Publish",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
