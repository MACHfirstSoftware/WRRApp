import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class NewReportPost extends StatefulWidget {
  // final bool isWRRPost;
  const NewReportPost({Key? key}) : super(key: key);

  @override
  State<NewReportPost> createState() => _NewReportPostState();
}

class _NewReportPostState extends State<NewReportPost> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TextEditingController _deerSeenController;
  late TextEditingController _bucksSeenController;
  late TextEditingController _huntHoursController;
  late List<XFile> _images;
  late List<County> _counties;
  late County _selectedCounty;
  late User _user;
  Post? newPost;
  bool _isPostPublished = false;
  double weatherRate = 0.0;
  String huntType = "Gun";
  bool _isHuntSuccess = false;
  DateTime startAt = DateTime.now();
  List<int> _huntHours = [];
  int? _huntSuccessHour;

  @override
  void initState() {
    _images = [];
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _selectedCounty = County(
        id: _user.countyId, name: _user.countyName!, regionId: _user.regionId);
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _deerSeenController = TextEditingController();
    _bucksSeenController = TextEditingController();
    _huntHoursController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _deerSeenController.dispose();
    _bucksSeenController.dispose();
    _huntHoursController.dispose();
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

  _publishPost() async {
    if (_validatePostDetails()) {
      ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
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
        newPost = Post(
            id: id,
            personId: _user.id,
            firstName: _user.firstName,
            lastName: _user.lastName,
            title: _titleController.text,
            body: _bodyController.text,
            isShare: false,
            createdOn: UtilCommon.getDateTimeNow(),
            modifiedOn: UtilCommon.getDateTimeNow(),
            likes: [],
            comments: [],
            media: []);
        setState(() {
          _isPostPublished = true;
        });
        if (_images.isNotEmpty) {
          List<Map<String, dynamic>> uploadList = [];
          for (XFile image in _images) {
            final bytes = File(image.path).readAsBytesSync();
            String img64 = base64Encode(bytes);
            uploadList.add({
              "postId": newPost!.id,
              "caption": "No Caption",
              "image": img64,
              "fileName": _getImageName(image.name),
              "type": _getImageExtension(image.name),
              "sortOrder": 0
            });
          }
          final imageResponse = await PostService.addPostImage(uploadList);
          imageResponse.when(success: (List<Media> media) {
            newPost?.media = media;
            // if (widget.isWRRPost) {
            //   Provider.of<WRRPostProvider>(context, listen: false)
            //       .addingNewPost(newPost!);
            // } else {
            //   final countyPostProvider =
            //       Provider.of<CountyPostProvider>(context, listen: false);
            //   if (_user.countyId == countyPostProvider.countyId) {
            //     countyPostProvider.addingNewPost(newPost!);
            //   }
            // }
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
          // if (widget.isWRRPost) {
          //   Provider.of<WRRPostProvider>(context, listen: false)
          //       .addingNewPost(newPost!);
          // } else {
          //   final countyPostProvider =
          //       Provider.of<CountyPostProvider>(context, listen: false);
          //   if (_user.countyId == countyPostProvider.countyId) {
          //     countyPostProvider.addingNewPost(newPost!);
          //   }
          // }
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
        final bytes = File(image.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        uploadList.add({
          "postId": newPost!.id,
          "caption": "No Caption",
          "image": img64,
          "fileName": _getImageName(image.name),
          "type": _getImageExtension(image.name),
          "sortOrder": 0
        });
      }
      final imageResponse = await PostService.addPostImage(uploadList);
      imageResponse.when(success: (List<Media> media) {
        newPost?.media = media;
        // if (widget.isWRRPost) {
        //   Provider.of<WRRPostProvider>(context, listen: false)
        //       .addingNewPost(newPost!);
        // } else {
        //   final countyPostProvider =
        //       Provider.of<CountyPostProvider>(context, listen: false);
        //   if (_user.countyId == countyPostProvider.countyId) {
        //     countyPostProvider.addingNewPost(newPost!);
        //   }
        // }
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
                                  "If you discard now, you'll lose this post.",
                              leftBtnText: "Discard",
                              rightBtnText: "Keep",
                              onTap: _discardPost,
                            )));
              },
              icon: const Icon(Icons.close_rounded),
              splashColor: AppColors.btnColor.withOpacity(0.5),
            ),
            title: Text(
              "Create Post",
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
                  if (_isPostPublished) {
                    _uploadImage();
                  } else {
                    _publishPost();
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
                    "Post",
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
          body: SingleChildScrollView(
            child: Column(
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
                            fontSize: 18.sp,
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Start at  :  ",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: GestureDetector(
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
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      // color: AppColors.btnColor,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.left,
                                ),
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
                              fontSize: 18.sp,
                              color: AppColors.btnColor,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      _buildTextField(_deerSeenController)
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
                              fontSize: 18.sp,
                              color: AppColors.btnColor,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      _buildTextField(_bucksSeenController)
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
                          fontSize: 18.sp,
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 25.w),
                //   child: Row(
                //     children: [
                //       Text(
                //         "Bad",
                //         style: TextStyle(
                //             fontSize: 14.sp,
                //             color: Colors.white,
                //             fontWeight: FontWeight.w500),
                //         textAlign: TextAlign.left,
                //       )
                //     ],
                //   ),
                // ),
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
                              fontSize: 18.sp,
                              color: AppColors.btnColor,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      _buildTextField(_huntHoursController,
                          onChange: _onHuntHourChange, hintText: "Hours")
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
                                fontSize: 18.sp,
                                color: AppColors.btnColor,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          children: [
                            Radio(
                                value: "Gun",
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
                                  fontSize: 18.sp,
                                  // color: AppColors.btnColor,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Radio(
                                value: "Bow",
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
                                  fontSize: 18.sp,
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
                              fontSize: 18.sp,
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
                                  fontSize: 18.sp,
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
                                  fontSize: 18.sp,
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
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "What time were you successful (Optional) : ",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.btnColor,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      _buildDropButton()
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
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
                                color:
                                    AppColors.secondaryColor.withOpacity(0.5),
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
                activeTrackColor: AppColors.secondaryColor,
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
                valueIndicatorColor: AppColors.secondaryColor,
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

  _buildDropButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
          dropdownColor: AppColors.secondaryColor,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.btnColor,
            size: 30.h,
          ),
          style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600),
          iconSize: 30.h,
          value: _huntSuccessHour,
          items: _huntHours
              .map((e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text(
                    UtilCommon.getTimeString(startAt.add(Duration(hours: e))),
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _huntSuccessHour = value;
            });
          }),
    );
  }

  _onHuntHourChange(String value) {
    if (value.isNotEmpty) {
      List<int> temp = [];
      for (int i = 0; i < int.parse(value); i++) {
        temp.add(i + 1);
      }
      setState(() {
        _huntHours = temp;
        _huntSuccessHour = null;
      });
    }
  }

  _buildTextField(TextEditingController controller,
          {Function? onChange, String hintText = "00"}) =>
      SizedBox(
        height: 40.h,
        width: 100.w,
        child: TextField(
          controller: controller,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              decoration: TextDecoration.none),
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.btnColor,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (String value) {
            if (onChange != null) {
              onChange(value);
            }
          },
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            fillColor: Colors.transparent,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[200],
              fontSize: 16.sp,
              decoration: TextDecoration.none,
            ),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(5.w)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.btnColor),
                borderRadius: BorderRadius.circular(5.w)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(5.w)),
          ),
        ),
      );

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
                      fontSize: 18.sp,
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
      color: AppColors.secondaryColor,
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
