import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/media.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_media_view.dart';

class VideoThumbs extends StatefulWidget {
  final List<Media>? medias;
  final String? thumbnail;
  final int? index;
  const VideoThumbs({
    Key? key,
    this.thumbnail,
    this.medias,
    this.index,
  }) : super(key: key);

  @override
  State<VideoThumbs> createState() => _VideoThumbsState();
}

class _VideoThumbsState extends State<VideoThumbs> {
  @override
  void initState() {
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
        color: AppColors.popBGColor.withOpacity(0.8),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            if (widget.thumbnail != null)
              CachedNetworkImage(
                imageUrl: widget.thumbnail!,
                imageBuilder: (context, imageProvider) {
                  return Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    alignment: widget.medias?.length == 1
                        ? Alignment.center
                        : Alignment.topCenter,
                  );
                },
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: SizedBox(
                    height: 15.h,
                    width: 15.h,
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: AppColors.btnColor, size: 15.h),
              ),
            Center(
              child: CircleAvatar(
                radius: 20.h,
                backgroundColor: Colors.black45,
                child: Icon(
                  Icons.play_arrow,
                  size: 20.h,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/**{
  "url": "https://rrmediaservice-uswe.streaming.media.azure.net/e1d50c66-8c67-484a-9399-f4fe58e3b49a/Butterfly-209-133084351480339619.ism/manifest(format=m3u8-cmaf).m3u8",
  "bloburl": "https://usrutreports.blob.core.windows.net/test/Butterfly-209-133084351480339619.mp4",
  "thumbnail": "https://usrutreports.blob.core.windows.net/test/thum_Butterfly-209-133084351480339619.jpg"
} */