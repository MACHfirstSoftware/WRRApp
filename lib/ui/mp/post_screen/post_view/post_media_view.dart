import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/video_preview.dart';

class PostMediaView extends StatefulWidget {
  final List<Media> medias;
  final int index;
  const PostMediaView({Key? key, required this.medias, this.index = 0})
      : super(key: key);

  @override
  State<PostMediaView> createState() => _PostMediaViewState();
}

class _PostMediaViewState extends State<PostMediaView> {
  late PageController _pageController;
  late int _index;
  bool isShow = false;
  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    _index = widget.index;
    super.initState();
  }

  _showButtons() {
    setState(() {
      isShow = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        isShow = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            iconSize: 25.h,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel_rounded, color: Colors.white)),
        centerTitle: true,
        title: Text(
          "${_index + 1} of ${widget.medias.length}",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: _showButtons,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.medias.length,
                itemBuilder: (context, index) {
                  if (widget.medias[index].imageUrl != null) {
                    return PhotoView(
                        imageProvider:
                            NetworkImage(widget.medias[index].imageUrl!));
                  }
                  if (widget.medias[index].videoUrl != null) {
                    return VideoPreview(
                        videoUrl: widget.medias[index].videoUrl!);
                  }
                  return const SizedBox();
                },
                onPageChanged: (int page) {
                  setState(() {
                    _index = page;
                  });
                },
              ),

              // PhotoViewGallery.builder(
              //   pageController: _pageController,
              //   itemCount: widget.medias.length,
              //   builder: (context, index) {
              //     return PhotoViewGalleryPageOptions(
              //         imageProvider: NetworkImage(widget.medias[_index].imageUrl!),
              //         minScale: PhotoViewComputedScale.contained,
              //         maxScale: PhotoViewComputedScale.contained * 4);
              //   },
              // onPageChanged: (int page) {
              //   setState(() {
              //     _index = page;
              //   });
              // },
              // ),
              Positioned(
                top: 75.h,
                left: 0,
                child: SizedBox(
                  width: 428.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isShow && _index > 0)
                        IconButton(
                            iconSize: 45.h,
                            onPressed: () {
                              if (_index > 0) {
                                setState(() {
                                  _index--;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: Colors.white,
                            ))
                      else
                        const SizedBox(),
                      if (isShow && _index < widget.medias.length - 1)
                        IconButton(
                            iconSize: 45.h,
                            onPressed: () {
                              if (_index < widget.medias.length - 1) {
                                setState(() {
                                  _index++;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.white,
                            ))
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
