import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  late AssetImage mapImage;
  @override
  void initState() {
    mapImage = const AssetImage(
      "assets/images/WRR-REGIONS.png",
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(mapImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: const DefaultAppbar(title: "WRR Regions Map"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: PhotoViewGallery(
        pageOptions: [
          PhotoViewGalleryPageOptions(
              imageProvider: mapImage,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4)
        ],
      )),
    );
  }
}
