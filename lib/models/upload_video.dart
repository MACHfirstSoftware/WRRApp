import 'dart:typed_data';

import 'package:video_compress/video_compress.dart';

class UploadVideoModel {
  Uint8List? thubmnail;
  MediaInfo? mediaInfo;
  Map<String, dynamic>? storeUrl;
  bool isUploaded;
  bool isUploading;
  double progressValue;

  UploadVideoModel(
      {this.thubmnail,
      this.mediaInfo,
      this.storeUrl,
      this.isUploaded = false,
      this.isUploading = false,
      this.progressValue = 0.0});
}
