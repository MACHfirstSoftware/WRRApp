import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class UploadVideoModel {
  Uint8List? thubmnail;
  XFile? file;
  Map<String, dynamic>? storeUrl;
  bool isUploaded;
  bool isUploading;
  double progressValue;

  UploadVideoModel(
      {this.thubmnail,
      this.file,
      this.storeUrl,
      this.isUploaded = false,
      this.isUploading = false,
      this.progressValue = 0.0});
}
