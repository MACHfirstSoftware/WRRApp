import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/widgets/custom_input.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  File? _image;

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

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) {
        return;
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      print("Failed to pick image : $e");
    } catch (e) {
      print("Failed to pick image : $e");
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
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 400.w,
        height: 650.h,
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Add Post",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.btnColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 30.h,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              CustomInputField(
                controller: _titleController,
                label: "Title",
                hintText: "Title",
              ),
              CustomInputField(
                controller: _titleController,
                label: "Body",
                hintText: "Body",
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
                              _image!,
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
                              print("Get image source failed");
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
              SizedBox(
                height: 25.h,
              )
            ],
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
      onTap: () {},
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
