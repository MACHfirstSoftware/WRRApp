// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:wisconsin_app/services/post_service.dart';

// class VideoApp extends StatefulWidget {
//   const VideoApp({Key? key}) : super(key: key);

//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<VideoApp> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         "https://eattend-uswe.streaming.media.azure.net/4f45e49c-677e-4dc0-920b-ceb66975d149/abc.ism/manifest(format=m3u8-cmaf).m3u8"
//         // "https://usrutreports.blob.core.windows.net/media/abc.mp4"
//         )
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   final picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: _controller.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: 9 / 16,
//                   child: VideoPlayer(_controller),
//                 )
//               : Container(
//                   color: Colors.yellow,
//                   height: 20,
//                   width: 10,
//                   child: CircularProgressIndicator(),
//                 )
//           // child: Container(
//           //   child: Center(
//           //     child: ElevatedButton(
//           //       onPressed: () async {
//           //         XFile? _file =
//           //             await picker.pickVideo(source: ImageSource.gallery);
//           //         if (_file != null) {
//           //           await PostService.addPostVideo(_file.path);
//           //         }
//           //       },
//           //       child: Text("upload"),
//           //     ),
//           //   ),
//           // ),
//           ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying
//                 ? _controller.pause()
//                 : _controller.play();
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
