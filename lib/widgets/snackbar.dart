import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _infoBackgroundColor = Color.fromRGBO(85, 85, 238, 1);
const _errorBackgrounColor = Color.fromRGBO(255, 0, 0, 1);
const _successBackgroundColor = Color.fromRGBO(99, 142, 90, 1);
const _warningBackgroundColor = Color.fromRGBO(232, 145, 72, 1);

// const _darkColor = Color.fromRGBO(45, 45, 40, 1);

enum SnackBarType {
  info,
  error,
  success,
  warning,
}

SnackBar customSnackBar(
    {required BuildContext context,
    required SnackBarType type,
    String? titleText,
    required String messageText,
    bool actionNeed = true,
    SnackBarBehavior? behavior,
    int? duration,
    double? margin}) {
  return SnackBar(
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: duration ?? 2),
    margin: EdgeInsets.only(bottom: margin ?? 0),
    content: SnackBarContent(
        type: type,
        titleText: titleText,
        messageText: messageText,
        actionNeed: actionNeed),
    behavior: behavior ?? SnackBarBehavior.floating,
  );
}

class SnackBarContent extends StatelessWidget {
  final SnackBarType type;
  final String? titleText;
  final String messageText;
  final bool actionNeed;
  const SnackBarContent(
      {Key? key,
      required this.type,
      this.titleText,
      required this.messageText,
      this.actionNeed = true})
      : super(key: key);

  Color get typeColor {
    switch (type) {
      case SnackBarType.info:
        return _infoBackgroundColor;

      case SnackBarType.error:
        return _errorBackgrounColor;

      case SnackBarType.success:
        return _successBackgroundColor;

      case SnackBarType.warning:
        return _warningBackgroundColor;

      default:
        throw UnimplementedError();
    }
  }

  String get title {
    switch (type) {
      case SnackBarType.info:
        return "INFO";

      case SnackBarType.error:
        return "ERROR";

      case SnackBarType.success:
        return "SUCCESS";

      case SnackBarType.warning:
        return "WARNING";

      default:
        throw UnimplementedError();
    }
  }

  IconData get iconData {
    switch (type) {
      case SnackBarType.info:
        return Icons.info_outline;

      case SnackBarType.error:
        return Icons.error_outline;

      case SnackBarType.success:
        return Icons.done;

      case SnackBarType.warning:
        return Icons.warning_amber_rounded;

      default:
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 428.w,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: typeColor, borderRadius: BorderRadius.circular(10.h)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              iconData,
              color: typeColor,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleText ?? title,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  messageText,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (actionNeed) SizedBox(width: 10.w),
          if (actionNeed)
            GestureDetector(
              onTap: (() =>
                  ScaffoldMessenger.of(context).removeCurrentSnackBar()),
              child: SizedBox(
                  width: 30.w,
                  height: 60.h,
                  child: Center(
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  )),
            )
        ],
      ),
    );
  }
}
