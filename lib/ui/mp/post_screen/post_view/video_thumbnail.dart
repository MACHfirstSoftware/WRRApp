import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_media_view.dart';

class VideoThumbs extends StatefulWidget {
  final List<Media>? medias;
  final String videoUrl;
  final int? index;
  const VideoThumbs({
    Key? key,
    required this.videoUrl,
    this.medias,
    this.index,
  }) : super(key: key);

  @override
  State<VideoThumbs> createState() => _VideoThumbsState();
}

class _VideoThumbsState extends State<VideoThumbs> {
  String? _thumbnailUrl;

  _getVideoThumbnail() async {
    print("Thumbs Called");
    // print(widget.videoUrl);
    // double hb = 400.h;
    // int hh = int.parse(hb.toStringAsFixed(0));
    _thumbnailUrl = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).absolute.path,
      imageFormat: ImageFormat.WEBP,
      // maxHeight: 400,
      maxWidth: int.parse((428.w).toStringAsFixed(0)),
      quality: 75,
    );

    print("THUMS URL $_thumbnailUrl");
    setState(() {});
  }

  @override
  void initState() {
    _getVideoThumbnail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.medias != null && widget.index != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PostMediaView(
                      medias: widget.medias!, index: widget.index!)));
        }
      },
      child: Container(
        // color: widget.medias != null
        //     ? AppColors.backgroundColor
        //     : AppColors.popBGColor,
        color: AppColors.popBGColor.withOpacity(0.8),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_thumbnailUrl != null)
              Image.file(
                File(_thumbnailUrl!),
                fit: BoxFit.fill,
              ),
            CircleAvatar(
              radius: 20.h,
              backgroundColor: Colors.black45,
              child: Icon(
                Icons.play_arrow,
                size: 20.h,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
