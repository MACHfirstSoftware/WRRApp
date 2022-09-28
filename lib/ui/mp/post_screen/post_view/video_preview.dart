import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ChewieController? chewieController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    _initPlayer();
    super.initState();
  }

  _initPlayer() async {
    _controller = _controller = VideoPlayerController.network(widget.videoUrl);
    await Future.wait([_controller.initialize()]);
    chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: false,
        autoInitialize: true,
        showOptions: false,
        showControls: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
        ],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
        ],
        systemOverlaysAfterFullScreen: SystemUiOverlay.values,
        systemOverlaysOnEnterFullScreen: SystemUiOverlay.values,
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return VideoScaffold(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: AppColors.btnColor,
                  body: Container(
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: provider,
                  ),
                ),
              );
            },
          );
        });
    // chewieController?.addListener(() {
    //   if (chewieController!.isFullScreen) {
    //     if (Platform.isAndroid) {
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //       final or = MediaQuery.of(context).orientation;
    //       if (or == Orientation.portrait) {
    //         chewieController?.exitFullScreen();
    //       }
    //     }
    //     // SystemChrome.setPreferredOrientations([
    //     //   DeviceOrientation.landscapeRight,
    //     //   DeviceOrientation.landscapeLeft,
    //     // ]);
    //     // target = Orientation.portrait;
    //     // AutoOrientation.landscapeAutoMode();
    //     // NativeDeviceOrientationCommunicator()
    //     //     .onOrientationChanged(useSensor: true)
    //     //     .listen((event) {
    //     //   if (event == target) {
    //     //     target = null;
    //     //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //     //   } else {
    //     //     AutoOrientation.landscapeLeftMode();
    //     //   }
    //     // });
    //     // AutoOrientation.landscapeLeftMode();
    //   } else {
    //     if (Platform.isAndroid) {
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       final or = MediaQuery.of(context).orientation;
    //       if (or == Orientation.landscape) {
    //         chewieController?.enterFullScreen();
    //       }
    //     }
    //     // SystemChrome.setPreferredOrientations([
    //     //   DeviceOrientation.portraitUp,
    //     //   DeviceOrientation.portraitDown,
    //     // ]);
    //     // target = Orientation.landscape;
    //     // AutoOrientation.portraitUpMode();
    //     // AutoOrientation.portraitUpMode();
    //     // NativeDeviceOrientationCommunicator()
    //     //     .onOrientationChanged(useSensor: true)
    //     //     .listen((event) {
    //     //   if (event == target) {
    //     //     target = null;
    //     //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //     //   } else {
    //     //     AutoOrientation.portraitUpMode();
    //     //   }
    //     // });
    //   }
    // });
    setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
          child: chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? _buildVideo()
              : ViewModels.postLoader()),
    );
  }

  _setOrientation(bool isPortrait) {
    if (Platform.isIOS) {
      if (!isPortrait) {
        // print("LANDSCAPE");
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          chewieController?.enterFullScreen();
        });
      } else {
        // print("PORTRAIT");
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          chewieController?.exitFullScreen();
        });
      }
    }
  }

  OrientationBuilder _buildVideo() {
    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;
      _setOrientation(isPortrait);
      return Chewie(
        controller: chewieController!,
      );
    });
  }
}

class VideoScaffold extends StatefulWidget {
  const VideoScaffold({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _VideoScaffoldState();
}

class _VideoScaffoldState extends State<VideoScaffold> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    AutoOrientation.landscapeAutoMode();
    super.initState();
  }

  @override
  dispose() {
    if (Platform.isAndroid) {
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      //   DeviceOrientation.portraitUp
      // ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    AutoOrientation.fullAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
