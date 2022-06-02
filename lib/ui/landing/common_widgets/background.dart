import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Background extends StatefulWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  late AssetImage bgImage;
  @override
  void initState() {
    bgImage = const AssetImage(
      "assets/images/bg.png",
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(bgImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: 926.h,
          width: 428.w,
          decoration: BoxDecoration(
              image: DecorationImage(image: bgImage, fit: BoxFit.fill)),
          child: widget.child),
    );
  }
}
