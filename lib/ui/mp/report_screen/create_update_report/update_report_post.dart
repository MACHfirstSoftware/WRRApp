import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';
import 'package:wisconsin_app/widgets/number_drop_menu.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class UpdateReportPost extends StatefulWidget {
  final Post post;
  const UpdateReportPost({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdateReportPost> createState() => _UpdateReportPostState();
}

class _UpdateReportPostState extends State<UpdateReportPost> {
  // late TextEditingController _titleController;
  late TextEditingController _bodyController;
  int _deerSeen = 0;
  int _bulkSeen = 0;
  int _huntHours = 1;
  FocusNode focusNode = FocusNode();
  String hintText = '...';
  late List<XFile> _images;
  late List<Media> _medias;
  Media? _mediaForDelete;
  late List<County> _counties;
  late County _selectedCounty;
  Post? _updatedPost;
  Report? _updatedReport;
  bool _isPostUpdate = false;
  double weatherRate = 0.0;
  String huntType = "G";
  bool _isHuntSuccess = false;
  DateTime startAt = DateTime.now();
  late Post _post;

  @override
  void initState() {
    _post = widget.post;
    _medias = [];
    _images = [];
    _medias.addAll(_post.media);
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _selectedCounty = _post.county;
    // _titleController = TextEditingController(text: _post.title);
    _bodyController = TextEditingController(text: _post.body);
    _deerSeen = _post.report!.numDeer;
    _bulkSeen = _post.report!.numBucks;
    _huntHours = _post.report!.numHours;
    weatherRate = _post.report!.weatherRating.toDouble() - 1;
    startAt = UtilCommon.getDatefromString(_post.report!.startDateTime);
    huntType = _post.report!.weaponUsed;
    _isHuntSuccess = _post.report!.isSuccess;

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
    if (_huntHours < 1) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Hunt hours is required",
          type: SnackBarType.error));
      return false;
    }
    return true;
  }

  _updateReportPost() async {
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    if (_validatePostDetails()) {
      ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
      PageLoader.showLoader(context);
      final postResponse = await PostService.updateReportPost(
          _post.id,
          // _titleController.text,
          "",
          _bodyController.text,
          _selectedCounty.id,
          _selectedCounty.regionId);

      if (postResponse) {
        _updatedPost = Post(
            id: _post.id,
            personId: _post.personId,
            firstName: _post.firstName,
            lastName: _post.lastName,
            personCode: _post.personCode,
            profileImageUrl: _user.profileImageUrl,
            isFollowed: true,
            // title: _titleController.text,
            title: "",
            body: _bodyController.text,
            postPersonCounty: _post.postPersonCounty,
            postType: _post.postType,
            isShare: _post.isShare,
            createdOn: _post.createdOn,
            modifiedOn: _post.modifiedOn,
            timeAgo: _post.timeAgo,
            likes: _post.likes,
            comments: _post.comments,
            media: [],
            county: County(
                id: _selectedCounty.id,
                name: _selectedCounty.name,
                regionId: _selectedCounty.regionId));
        _updatedReport = Report(
            id: _post.report!.id,
            postId: _post.id,
            numDeer: _deerSeen,
            numBucks: _bulkSeen,
            numHours: _huntHours,
            weaponUsed: huntType,
            weatherRating: (weatherRate.round() + 1),
            startDateTime: UtilCommon.formatDate(startAt),
            endDateTime: _post.report!.endDateTime,
            successTime: null,
            isSuccess: _isHuntSuccess);

        final reportResponse = await PostService.updateReport(_updatedReport!);
        if (reportResponse) {
          setState(() {
            _isPostUpdate = true;
          });
          _updatedPost!.report = _updatedReport;

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
              _updatedPost!.media = media;
//------------------------------------------ change bellow to update------------------
              // final reportPostProvider =
              //     Provider.of<ReportPostProvider>(context, listen: false);
              // if (reportPostProvider.regionId == _selectedCounty.regionId) {
              Provider.of<ReportPostProvider>(context, listen: false)
                  .updatePost(_updatedPost!);
              // }

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
            _updatedPost!.media = _medias;

//------------------------------------------ change bellow to update------------------
            Provider.of<ReportPostProvider>(context, listen: false)
                .updatePost(_updatedPost!);
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
        _updatedPost!.media = media;
//------------------------------------------ change bellow to update---------------------
        Provider.of<ReportPostProvider>(context, listen: false)
            .updatePost(_updatedPost!);
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

  _removeImage() async {
    PageLoader.showLoader(context);
    final res = await PostService.imageDelete(_mediaForDelete!.id);
    Navigator.pop(context);
    if (res) {
      // print(_medias.length);
      setState(() {
        _medias.remove(_mediaForDelete);
        // print(_medias.length);
        _mediaForDelete = null;
      });
    } else {
      _mediaForDelete = null;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to remove image",
          type: SnackBarType.error));
    }
  }

  void _discardPost() {
    if (_post.media.length > _medias.length) {
      Post _newPost = _post;
      _newPost.media = _medias;

      Provider.of<ReportPostProvider>(context, listen: false)
          .updatePost(_newPost);
    }
    if (_isPostUpdate) {
      PostService.updateReportPost(_post.id, _post.title, _post.body,
          _post.county.id, _post.county.regionId);
      PostService.updateReport(_post.report!);
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
                      "Update Report",
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
                        _updateReportPost();
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
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What time did you start your hunt  :  ",
                              // "",
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
                                    borderRadius: BorderRadius.circular(5.h),
                                    border: Border.all(
                                        color: Colors.white, width: 1.h)),
                                child: Text(
                                  UtilCommon.formatDate(startAt),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        NumberDropMenu(
                            value: _deerSeen,
                            onChange: (seen) {
                              setState(() {
                                _deerSeen = seen;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        NumberDropMenu(
                            value: _bulkSeen,
                            onChange: (seen) {
                              setState(() {
                                _bulkSeen = seen;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            value: _huntHours,
                            onChange: (hour) {
                              setState(() {
                                _huntHours = hour;
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
                    child: Theme(
                      data: ThemeData(
                        // unselectedWidgetColor: Colors.grey[300],
                        unselectedWidgetColor: AppColors.btnColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "How did you hunt  :  ",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.btnColor,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "G",
                                  groupValue: huntType,
                                  activeColor: AppColors.btnColor,
                                  onChanged: (value) {
                                    setState(() {
                                      huntType = value.toString();
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
                              Radio(
                                  value: "B",
                                  groupValue: huntType,
                                  activeColor: AppColors.btnColor,
                                  onChanged: (value) {
                                    setState(() {
                                      huntType = value.toString();
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Was your hunt successful  :  ",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                            // unselectedWidgetColor: Colors.grey[300],
                            unselectedWidgetColor: AppColors.btnColor,
                          ),
                          child: Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: _isHuntSuccess,
                                  activeColor: AppColors.btnColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _isHuntSuccess = value as bool;
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
                              Radio(
                                  value: false,
                                  groupValue: _isHuntSuccess,
                                  activeColor: AppColors.btnColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _isHuntSuccess = value as bool;
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
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 25.w),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           "What time were you successful (Optional) : ",
                  //           style: TextStyle(
                  //               fontSize: 16.sp,
                  //               color: AppColors.btnColor,
                  //               fontWeight: FontWeight.w500),
                  //           textAlign: TextAlign.left,
                  //         ),
                  //       ),
                  //       _buildDropButton()
                  //     ],
                  //   ),
                  // ),
                  if (_medias.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Current available image(s) in post",
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
                                              child: CachedNetworkImage(
                                                imageUrl: media.imageUrl!,
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Image(
                                                    image: imageProvider,
                                                    height: 300.h,
                                                    width: 360.w,
                                                    fit: BoxFit.fill,
                                                  );
                                                },
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child: SizedBox(
                                                    height: 15.h,
                                                    width: 15.h,
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: progress.progress,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons.error,
                                                        color:
                                                            AppColors.btnColor,
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
                                                      builder: (_) =>
                                                          ConfirmationPopup(
                                                            title: "Remove",
                                                            message:
                                                                "This image is currently available in the post. If you remove now, no longer available this image.",
                                                            leftBtnText:
                                                                "Remove",
                                                            rightBtnText:
                                                                "Keep",
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
                    "Select image(s) to upload",
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
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                  value: weatherRate,
                  min: 0.0,
                  max: 4.0,
                  divisions: 4,
                  label: '${weatherRate.round() + 1}',
                  onChanged: (double value) {
                    setState(() {
                      weatherRate = value;
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

  // _buildDropButton() {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton<int>(
  //         dropdownColor: AppColors.popBGColor,
  //         icon: Icon(
  //           Icons.keyboard_arrow_down_rounded,
  //           color: AppColors.btnColor,
  //           size: 30.h,
  //         ),
  //         style: TextStyle(
  //             fontSize: 16.sp,
  //             color: Colors.white,
  //             fontWeight: FontWeight.w600),
  //         iconSize: 30.h,
  //         value: _huntSuccessHour,
  //         items: _huntHours
  //             .map((e) => DropdownMenuItem<int>(
  //                 value: e,
  //                 child: Text(
  //                   UtilCommon.getTimeString(startAt.add(Duration(hours: e))),
  //                   style: TextStyle(
  //                       fontSize: 16.sp,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w600),
  //                 )))
  //             .toList(),
  //         onChanged: (int? value) {
  //           setState(() {
  //             _huntSuccessHour = value;
  //           });
  //         }),
  //   );
  // }

  // _buildTextField(TextEditingController controller,
  //         {Function? onChange, String hintText = "00"}) =>
  //     SizedBox(
  //       height: 40.h,
  //       width: 100.w,
  //       child: TextField(
  //         controller: controller,
  //         style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 16.sp,
  //             decoration: TextDecoration.none),
  //         textAlignVertical: TextAlignVertical.center,
  //         cursorColor: AppColors.btnColor,
  //         keyboardType: TextInputType.number,
  //         inputFormatters: [
  //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //         ],
  //         onChanged: (String value) {
  //           if (onChange != null) {
  //             onChange(value);
  //           }
  //         },
  //         decoration: InputDecoration(
  //           contentPadding:
  //               EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
  //           fillColor: Colors.transparent,
  //           filled: true,
  //           hintText: hintText,
  //           hintStyle: TextStyle(
  //             color: Colors.grey[200],
  //             fontSize: 16.sp,
  //             decoration: TextDecoration.none,
  //           ),
  //           border: OutlineInputBorder(
  //               borderSide: const BorderSide(color: Colors.white),
  //               borderRadius: BorderRadius.circular(5.w)),
  //           focusedBorder: OutlineInputBorder(
  //               borderSide: const BorderSide(color: AppColors.btnColor),
  //               borderRadius: BorderRadius.circular(5.w)),
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: const BorderSide(color: Colors.white),
  //               borderRadius: BorderRadius.circular(5.w)),
  //         ),
  //       ),
  //     );

  _buildDropMenu() {
    return PopupMenuButton(
      // child: Text(
      //   _selectedCounty.name,
      //   style: TextStyle(
      //       fontSize: 18.sp,
      //       color: AppColors.btnColor,
      //       fontWeight: FontWeight.w500),
      //   textAlign: TextAlign.left,
      // ),
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
      startAt = dateTime;
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: startAt,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: startAt.hour, minute: startAt.minute));
}
