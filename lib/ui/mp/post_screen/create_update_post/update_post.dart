import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:wisconsin_app/models/report.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/upload_video.dart';
import 'package:wisconsin_app/providers/all_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/video_thumbnail.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';
import 'package:wisconsin_app/widgets/number_drop_menu.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class UpdatePost extends StatefulWidget {
  final Post post;
  const UpdatePost({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  // late TextEditingController _titleController;
  late TextEditingController _bodyController;
  FocusNode focusNode = FocusNode();
  late List<XFile> _images;
  late List<Media> _medias;
  late List<UploadVideoModel> _videos;
  Media? _mediaForDelete;
  bool _isPostUpdate = false;
  String hintText = '...';

  // int _deerSeen = 0;
  // int _bulkSeen = 0;
  // int _huntHours = 0;
  // double weatherRate = 0.0;
  // String huntType = "G";
  // bool _isHuntSuccess = false;
  bool _isReportDataInclude = false;
  // DateTime startAt = DateTime.now();

  late List<County> _counties;
  late County _selectedCounty;
  Report? _updatedReport;

  bool isExpanded = false;

  @override
  void initState() {
    _images = [];
    _medias = [];
    _videos = [];
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _selectedCounty = widget.post.county;
    // _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
    _medias.addAll(widget.post.media);

    if (widget.post.report != null) {
      final report = widget.post.report;
      _updatedReport = Report(
          id: report?.id ?? -1,
          postId: report?.postId ?? -1,
          numDeer: report?.numDeer ?? 0,
          numBucks: report?.numBucks ?? 0,
          numHours: report?.numHours ?? 0,
          weaponUsed: report?.weaponUsed ?? "G",
          weatherRating: report?.weatherRating ?? 0,
          startDateTime:
              report?.startDateTime ?? UtilCommon.formatDate(DateTime.now()),
          endDateTime:
              report?.endDateTime ?? UtilCommon.formatDate(DateTime.now()),
          isSuccess: report?.isSuccess ?? false);
    }
    // _deerSeen = widget.post.report?.numDeer;
    // _bulkSeen = widget.post.report?.numBucks;
    // _huntHours = widget.post.report?.numHours;
    // weatherRate = widget.post.report?.weatherRating.toDouble() - 1;
    // startAt = UtilCommon.getDatefromString(widget.post.report?.startDateTime);
    // huntType = widget.post.report?.weaponUsed;
    // _isHuntSuccess = widget.post.report?.isSuccess;
    _isReportDataInclude = widget.post.report != null;
    isExpanded = widget.post.report != null;
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
    // bool videoWhileProcessing = false;
    // for (var element in _videos) {
    //   if (element.isUploading) {
    //     videoWhileProcessing = true;
    //   }
    // }
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
    // if (videoWhileProcessing) {
    //   ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
    //       context: context,
    //       messageText: "Video uploads are being processed.",
    //       type: SnackBarType.warning));
    //   return false;
    // }
    return true;
  }

  _validateAllVideosUploaded() {
    bool isAllUploaded = true;

    for (var element in _videos) {
      if (!element.isUploaded) {
        isAllUploaded = false;
      }
    }
    return isAllUploaded;
  }

  _updatePost() async {
    if (_validatePostDetails()) {
      ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
      PageLoader.showLoader(context);
      if (!_validateAllVideosUploaded()) {
        final bulkUpload = await _videoBulkUploader();
        if (!bulkUpload) {
          Navigator.pop(context);
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
              context: context,
              messageText: "Unable to published the post.",
              type: SnackBarType.error));
          return;
        }
      }
      List<Map<String, dynamic>> videoUrls = [];
      for (var element in _videos) {
        if (element.storeUrl != null) {
          videoUrls.add({
            "id": 0,
            "postId": 0,
            "caption": "",
            "imageUrl": "",
            "videoUrl": element.storeUrl!["url"],
            "blobVideoUrl": element.storeUrl!["bloburl"],
            "thumbnail": element.storeUrl!["thumbnail"],
            "sortOrder": 0,
            "createdOn": DateTime.now().toIso8601String()
          });
        }
      }
      final res = await PostService.addPostVideoUrl(widget.post.id, videoUrls);
      res.when(success: (List<Media> data) async {
        if (_images.isEmpty) {
          Post _updatedPost = widget.post;
          _updatedPost.media = data;
//------------------------------------------ change bellow to update------------------

          Provider.of<WRRPostProvider>(context, listen: false)
              .updatePost(_updatedPost);
          Provider.of<RegionPostProvider>(context, listen: false)
              .updatePost(_updatedPost);
          Provider.of<AllPostProvider>(context, listen: false)
              .updatePost(_updatedPost);

//---------------------------------------------------------------------------------------
        }
        final updateResponse = await PostService.updateReportPost(
            widget.post.id,
            "",
            _bodyController.text,
            _selectedCounty.id,
            _selectedCounty.regionId);

        if (updateResponse) {
          setState(() {
            _isPostUpdate = true;
          });
          bool reportResponse = true;
          if (_isReportDataInclude && _updatedReport != null) {
            reportResponse = await PostService.updateReport(_updatedReport!);
          }

          if (reportResponse) {
            if (_images.isNotEmpty) {
              List<Map<String, dynamic>> uploadList = [];
              for (XFile image in _images) {
                uploadList.add({
                  "postId": widget.post.id,
                  "caption": "No Caption",
                  "image": ImageUtil.getBase64Image(image.path),
                  "fileName": ImageUtil.getImageName(image.name),
                  "type": ImageUtil.getImageExtension(image.name),
                  "sortOrder": 0
                });
              }
              final imageResponse = await PostService.addPostImage(uploadList);
              imageResponse.when(success: (List<Media> media) {
                Post _updatedPost = widget.post;
                // _updatedPost.title = _titleController.text;
                _updatedPost.title = "";
                _updatedPost.body = _bodyController.text;
                _updatedPost.media = media;
                _updatedPost.report = _updatedReport;
//------------------------------------------ change bellow to update------------------

                Provider.of<WRRPostProvider>(context, listen: false)
                    .updatePost(_updatedPost);
                Provider.of<RegionPostProvider>(context, listen: false)
                    .updatePost(_updatedPost);
                Provider.of<AllPostProvider>(context, listen: false)
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
              // _updatedPost.title = _titleController.text;
              _updatedPost.title = "";
              _updatedPost.body = _bodyController.text;
              if (data.isEmpty) {
                _updatedPost.media = _medias;
              }
              _updatedPost.report = _updatedReport;
//------------------------------------------ change bellow to update------------------
              Provider.of<WRRPostProvider>(context, listen: false)
                  .updatePost(_updatedPost);
              Provider.of<RegionPostProvider>(context, listen: false)
                  .updatePost(_updatedPost);
              Provider.of<AllPostProvider>(context, listen: false)
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
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
              context: context,
              messageText: "Post update failed.",
              type: SnackBarType.error));
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

  _updateImage() async {
    if (_images.isNotEmpty) {
      PageLoader.showLoader(context);
      List<Map<String, dynamic>> uploadList = [];
      for (XFile image in _images) {
        uploadList.add({
          "postId": widget.post.id,
          "caption": "No Caption",
          "image": ImageUtil.getBase64Image(image.path),
          "fileName": ImageUtil.getImageName(image.name),
          "type": ImageUtil.getImageExtension(image.name),
          "sortOrder": 0
        });
      }
      final imageResponse = await PostService.addPostImage(uploadList);
      imageResponse.when(success: (List<Media> media) {
        Post _updatedPost = widget.post;
        // _updatedPost.title = _titleController.text;
        _updatedPost.title = "";
        _updatedPost.body = _bodyController.text;
        _updatedPost.media = media;
//------------------------------------------ change bellow to update------------------
        Provider.of<WRRPostProvider>(context, listen: false)
            .updatePost(_updatedPost);
        Provider.of<RegionPostProvider>(context, listen: false)
            .updatePost(_updatedPost);
        Provider.of<AllPostProvider>(context, listen: false)
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
      final pickedFile = await picker.pickMultiImage(
        imageQuality: 50,
      );
      if (pickedFile == null) {
        return;
      } else {
        bool isHasOverSizeImage = false;
        for (var element in pickedFile) {
          var size = (await element.readAsBytes()).lengthInBytes;
          if ((size / (1024 * 1024)) >= 5) {
            isHasOverSizeImage = true;
          } else {
            _images.add(element);
          }
        }
        if (isHasOverSizeImage) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
              context: context,
              messageText: "Images larger than 5MB cannot be uploaded.",
              type: SnackBarType.error,
              duration: 5));
        }
        setState(() {});
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

  Future getVideo() async {
    PageLoader.showLoader(context);
    try {
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile == null) {
        Navigator.pop(context);
        return;
      } else {
        // final compressedVideo =
        //     await VideoUtil.compressVideo(filePath: pickedFile.path);
        final thumb =
            await VideoUtil.generateThumbnail(filePath: pickedFile.path);
        Navigator.pop(context);
        // if (compressedVideo != null) {
        setState(() {
          _videos.add(UploadVideoModel(
              file: pickedFile,
              thubmnail: thumb)); // ---------------------------
        });
        // _videoUploader(_videos.last);
        // } else {
        //   ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
        //       context: context,
        //       messageText: "Unable to add video",
        //       type: SnackBarType.error));
        // }
      }
    } on PlatformException catch (e) {
      Navigator.pop(context);
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to add video",
          type: SnackBarType.error));
    } catch (e) {
      Navigator.pop(context);
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to add video",
          type: SnackBarType.error));
    }
  }

  _discardPost() {
    if (widget.post.media.length > _medias.length) {
      Post _updatedPost = widget.post;
      _updatedPost.media = _medias;

      Provider.of<WRRPostProvider>(context, listen: false)
          .updatePost(_updatedPost);
      Provider.of<RegionPostProvider>(context, listen: false)
          .updatePost(_updatedPost);
      Provider.of<AllPostProvider>(context, listen: false)
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

  _removeVideo() async {
    PageLoader.showLoader(context);
    final res = await PostService.videoDelete(_mediaForDelete!.id);
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
                                  "If you discard now, you'll lose these changes.",
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
                      "Update Post",
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
                      if (_isPostUpdate) {
                        _updateImage();
                      } else {
                        _updatePost();
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
                            "Apply",
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
            child: SingleChildScrollView(
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
                      maxLines: 4,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  if (widget.post.report != null)
                    Theme(
                      data:
                          ThemeData(unselectedWidgetColor: AppColors.btnColor),
                      child: ExpansionTile(
                          key: Key(isExpanded.toString()),
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (value) {
                            setState(() {
                              isExpanded = value;
                            });
                          },
                          iconColor: AppColors.btnColor,
                          collapsedIconColor: AppColors.btnColor,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Report Data",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.btnColor,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 30.h,
                                width: 70.h,
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  fit: BoxFit.scaleDown,
                                  child: CupertinoSwitch(
                                    value: _isReportDataInclude,
                                    onChanged: (value) {
                                      if (widget.post.report == null) {
                                        setState(() {
                                          _isReportDataInclude =
                                              !_isReportDataInclude;
                                          isExpanded = _isReportDataInclude;
                                        });
                                      }
                                    },
                                    activeColor: AppColors.btnColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "County  :  ",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.btnColor,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(child: _buildDropMenu())
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.w),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "What time did you start your hunt  :  ",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.btnColor,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      GestureDetector(
                                        onTap: () => _pickDateTime(),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.h),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.h)),
                                          child: Text(
                                            UtilCommon.formatDate(
                                                UtilCommon.getDatefromString(
                                                    _updatedReport!
                                                        .startDateTime)),
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                // color: AppColors.btnColor,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
                                    ])),
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Number of deer seen  :  ",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.btnColor,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  // _buildTextField(_deerSeenController)
                                  NumberDropMenu(
                                      value: _updatedReport!.numDeer,
                                      onChange: (seen) {
                                        setState(() {
                                          _updatedReport!.numDeer = seen;
                                        });
                                      })
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Number of bucks seen  :  ",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.btnColor,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  // _buildTextField(_bucksSeenController)
                                  NumberDropMenu(
                                      value: _updatedReport!.numBucks,
                                      onChange: (seen) {
                                        setState(() {
                                          _updatedReport!.numBucks = seen;
                                        });
                                      })
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: SizedBox(
                                width: 428.w,
                                child: Text(
                                  "Weather Condition : ",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.btnColor,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            _weatherSlider(),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "How long did you hunt  :  ",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.btnColor,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  NumberDropMenu(
                                      isStartFromZero: false,
                                      value: _updatedReport!.numHours,
                                      onChange: (hour) {
                                        setState(() {
                                          _updatedReport!.numHours = hour;
                                        });
                                      })
                                  // _buildTextField(_huntHoursController,
                                  //     onChange: _onHuntHourChange, hintText: "Hours")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Theme(
                                data: ThemeData(
                                  // unselectedWidgetColor: Colors.grey[300],
                                  unselectedWidgetColor: AppColors.btnColor,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "How did you hunt  :  ",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.btnColor,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        Radio(
                                            value: "G",
                                            groupValue:
                                                _updatedReport!.weaponUsed,
                                            activeColor: AppColors.btnColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _updatedReport!.weaponUsed =
                                                    value.toString();
                                              });
                                            }),
                                        Text(
                                          "Gun",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              // color: AppColors.btnColor,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const Spacer(),
                                        Radio(
                                            value: "B",
                                            groupValue:
                                                _updatedReport!.weaponUsed,
                                            activeColor: AppColors.btnColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _updatedReport!.weaponUsed =
                                                    value.toString();
                                              });
                                            }),
                                        Text(
                                          "Bow",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              // color: AppColors.btnColor,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const Spacer(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Was your hunt successful  :  ",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.btnColor,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.left,
                                  ),
                                  Theme(
                                    data: ThemeData(
                                      // unselectedWidgetColor: Colors.grey[300],
                                      unselectedWidgetColor: AppColors.btnColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        Radio(
                                            value: true,
                                            groupValue:
                                                _updatedReport!.isSuccess,
                                            activeColor: AppColors.btnColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _updatedReport!.isSuccess =
                                                    value as bool;
                                              });
                                            }),
                                        Text(
                                          "Yes",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              // color: AppColors.btnColor,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const Spacer(),
                                        Radio(
                                            value: false,
                                            groupValue:
                                                _updatedReport!.isSuccess,
                                            activeColor: AppColors.btnColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _updatedReport!.isSuccess =
                                                    value as bool;
                                              });
                                            }),
                                        Text(
                                          "No",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              // color: AppColors.btnColor,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    ),
                  if (widget.post.report == null ? false : isExpanded) ...[
                    SizedBox(
                      height: 5.h,
                    ),
                    Divider(
                      color: AppColors.btnColor,
                      thickness: 1.h,
                    ),
                  ],
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                            height: 40.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                                color: AppColors.popBGColor,
                                borderRadius: BorderRadius.circular(7.5.w)),
                            child: SizedBox(
                              height: 30.h,
                              width: 120.w,
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Upload Image",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.btnColor,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                            // Icon(Icons.photo_library,
                            //     color: AppColors.btnColor, size: 25.h),
                            ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getVideo();
                        },
                        child: Container(
                            height: 40.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                                color: AppColors.popBGColor,
                                borderRadius: BorderRadius.circular(7.5.w)),
                            // child: Icon(Icons.video_collection_rounded,
                            //     color: AppColors.btnColor, size: 25.h),
                            child: SizedBox(
                              height: 30.h,
                              width: 120.w,
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Upload Video",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.btnColor,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  if (_medias.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Current available image(s) & video(s) in post",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.btnColor,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Scrollbar(
                            thickness: 5.w,
                            showTrackOnHover: true,
                            isAlwaysShown: false,
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
                                                color: AppColors.popBGColor
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        7.5.w)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7.5.w),
                                              child: media.imageUrl != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: media.imageUrl!,
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Image(
                                                          image: imageProvider,
                                                          height: 300.h,
                                                          width: 360.w,
                                                          fit: BoxFit.fill,
                                                        );
                                                      },
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  progress) =>
                                                              Center(
                                                        child: SizedBox(
                                                          height: 15.h,
                                                          width: 15.h,
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: progress
                                                                .progress,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error,
                                                              color: AppColors
                                                                  .btnColor,
                                                              size: 15.h),
                                                    )
                                                  : SizedBox(
                                                      height: 300.h,
                                                      width: 360.w,
                                                      child: VideoThumbs(
                                                          thumbnail:
                                                              media.thumbnail),
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
                                                      builder: (_) =>
                                                          ConfirmationPopup(
                                                            title: "Remove",
                                                            message:
                                                                "This ${media.videoUrl != null ? "video" : "image"} is currently available in the post. If you remove now, no longer available this ${media.videoUrl != null ? "video" : "image"}.",
                                                            leftBtnText:
                                                                "Remove",
                                                            rightBtnText:
                                                                "Keep",
                                                            onTap: media.videoUrl !=
                                                                    null
                                                                ? _removeVideo
                                                                : _removeImage,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Select image(s) or video(s) to upload",
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.btnColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "You can upload as many as you want. Upload time will vary based on your service.",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.btnColor,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Scrollbar(
                      thickness: 5.w,
                      showTrackOnHover: true,
                      isAlwaysShown: false,
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
                          ..._videos.map(
                            (video) => Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.5.w),
                                    child: video.thubmnail != null
                                        ? Image.memory(
                                            video.thubmnail!,
                                            height: 300.h,
                                            width: 360.w,
                                            fit: BoxFit.fill,
                                          )
                                        : Container(
                                            color: AppColors.popBGColor,
                                            height: 300.h,
                                            width: 360.w,
                                          ),
                                  ),
                                ),
                                if (!video.isUploading)
                                  Center(
                                    child: GestureDetector(
                                      // onTap: () {
                                      //   if (video.mediaInfo != null &&
                                      //       !video.isUploaded) {
                                      //     _videoUploader(video);
                                      //   }
                                      // },
                                      child: CircleAvatar(
                                        radius: 20.h,
                                        backgroundColor: Colors.black45,
                                        child: Icon(
                                          video.isUploaded
                                              ? Icons
                                                  .check_circle_outline_outlined
                                              : Icons.cloud_upload,
                                          size: 20.h,
                                          color: video.isUploaded
                                              ? Colors.greenAccent[400]
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (video.isUploading)
                                  Center(
                                    child: CircleAvatar(
                                      radius: 20.h,
                                      backgroundColor: Colors.transparent,
                                      child: CircularProgressIndicator(
                                        value: video.progressValue,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () {
                                      if (!video.isUploading) {
                                        setState(() {
                                          _videos.remove(video);
                                        });
                                      }
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
                        ],
                      ),
                    ),
                  ),
                  if (_videos.isNotEmpty)
                    SizedBox(
                      height: 10.h,
                    ),
                  if (_videos.isNotEmpty)
                    Text(
                      "Note: video uploads may experience a delay while processing",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _videoUploader(UploadVideoModel videoModel) async {
  //   setState(() {
  //     videoModel.isUploading = true;
  //   });
  //   final res = await PostService.postVideotoStore(
  //       file: videoModel.mediaInfo!,
  //       sendProgress: (double value) {
  //         setState(() {
  //           videoModel.progressValue = value;
  //         });
  //       });

  //   if (res != null) {
  //     setState(() {
  //       videoModel.storeUrl = res;
  //       videoModel.isUploading = false;
  //       videoModel.isUploaded = true;
  //     });
  //   } else {
  //     setState(() {
  //       videoModel.isUploading = false;
  //       videoModel.isUploaded = false;
  //     });
  //     ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
  //         context: context,
  //         messageText: "Unable upload video",
  //         type: SnackBarType.error));
  //   }
  // }

  Future<bool> _videoBulkUploader() async {
    bool isBulkUploadComplete = true;
    for (var video in _videos) {
      if (!video.isUploaded) {
        setState(() {
          video.isUploading = true;
        });
        final res = await PostService.postVideotoStore(
            file: video.file!,
            sendProgress: (double value) {
              setState(() {
                video.progressValue = value;
              });
            });

        if (res != null) {
          setState(() {
            video.storeUrl = res;
            video.isUploading = false;
            video.isUploaded = true;
          });
        } else {
          setState(() {
            video.isUploading = false;
            video.isUploaded = false;
          });
          isBulkUploadComplete = false;
          // ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          //     context: context,
          //     messageText: "Unable upload video",
          //     type: SnackBarType.error));
        }
      }
    }
    return isBulkUploadComplete;
  }

  _buildDropMenu() {
    return PopupMenuButton(
      child: Container(
        height: 40.h,
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedCounty.name,
                  style: TextStyle(
                      fontSize: 16.sp,
                      // color: AppColors.btnColor,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.btnColor,
              ),
            ]),
      ),
      color: AppColors.popBGColor,
      itemBuilder: (context) => [
        ..._counties.map((county) => PopupMenuItem<County>(
            value: county,
            child: SizedBox(
              width: 200.w,
              child: ListTile(
                trailing: county.id == _selectedCounty.id
                    ? const Icon(
                        Icons.check,
                        color: AppColors.btnColor,
                      )
                    : null,
                title: Text(
                  county.name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            )))
      ],
      onSelected: (County value) {
        setState(() {
          _selectedCounty = value;
        });
      },
    );
  }

  Future _pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _updatedReport!.startDateTime = UtilCommon.formatDate(dateTime);
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate:
            UtilCommon.getDatefromString(_updatedReport!.startDateTime),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour:
              UtilCommon.getDatefromString(_updatedReport!.startDateTime).hour,
          minute: UtilCommon.getDatefromString(_updatedReport!.startDateTime)
              .minute));

  _weatherSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        children: [
          Text(
            "Bad",
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 10.h,
                trackShape: const RoundedRectSliderTrackShape(),
                activeTrackColor: AppColors.popBGColor,
                inactiveTrackColor: AppColors.primaryColor,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 14.0,
                  pressedElevation: 8.0,
                ),
                thumbColor: AppColors.btnColor,
                overlayColor: AppColors.btnColor.withOpacity(0.2),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 30.w),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: AppColors.btnColor,
                inactiveTickMarkColor: Colors.white,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: AppColors.popBGColor,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              child: Slider(
                  value: _updatedReport!.weatherRating.toDouble() - 1,
                  min: 0.0,
                  max: 4.0,
                  divisions: 4,
                  label: '${_updatedReport!.weatherRating}',
                  onChanged: (double value) {
                    setState(() {
                      _updatedReport!.weatherRating = value.toInt() + 1;
                    });
                  }),
            ),
          ),
          Text(
            "Good",
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          )
        ],
      ),
    );
  }
}
