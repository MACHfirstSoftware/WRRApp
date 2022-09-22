import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class VideoPreview extends StatefulWidget {
  final String videoUrl;
  const VideoPreview({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;
  bool isShow = true;

  @override
  void initState() {
    print(widget.videoUrl);
    super.initState();
    _controller = VideoPlayerController.network(
        // "https://rrmediaservice-uswe.streaming.media.azure.net/11dd311b-74d4-41d1-a8a1-5430647dcb44/abc-133082324312950384.ism/manifest(format=m3u8-cmaf).m3u8"
        // "https://rrmediaservice-uswe.streaming.media.azure.net/b7d63db1-7fa5-44b7-a4c0-afda1ae68b6a/wr-133082292067427884-1330829536.ism/manifest(format=m3u8-cmaf).m3u8")
        widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        Future.delayed(const Duration(milliseconds: 1500), () {
          isShow = false;
        });
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (_controller.value.isInitialized) {
              _showButtons();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : ViewModels.postLoader(),
              if (_controller.value.isInitialized && isShow)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: CircleAvatar(
                    radius: 20.h,
                    backgroundColor: AppColors.popBGColor.withOpacity(0.8),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 20.h,
                      color: Colors.white,
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
