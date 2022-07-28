import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/notification.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/services/notification_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class PostOpenPage extends StatefulWidget {
  final NotificationModel notification;
  const PostOpenPage({Key? key, required this.notification}) : super(key: key);

  @override
  State<PostOpenPage> createState() => _PostOpenPageState();
}

class _PostOpenPageState extends State<PostOpenPage> {
  late ApiStatus _apiStatus;
  late Post post;
  String errorMessage = '';

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    setState(() {
      _apiStatus = ApiStatus.isBusy;
    });
    print("Notification Id : ${widget.notification.id}");
    final res =
        await NotificationService.notificationClick(widget.notification.id);
    res.when(success: (Post _post) {
      print("Post Id : ${_post.id}");
      setState(() {
        _apiStatus = ApiStatus.isIdle;
        errorMessage = '';
        post = _post;
        post.isShare = true;
        post.sharePersonId = widget.notification.shareBy.id;
        post.sharePersonFirstName = widget.notification.shareBy.firstName;
        post.sharePersonLastName = widget.notification.shareBy.lastName;
        post.sharePersonCode = widget.notification.shareBy.code;
        post.sharePersonCountyName = CountyUtil.getCountyNameById(
            counties:
                Provider.of<CountyProvider>(context, listen: false).counties,
            countyId: widget.notification.shareBy.countyId);
        post.sharePersonImage = widget.notification.shareBy.imageLocation;
      });
    }, failure: (NetworkExceptions error) {
      setState(() {
        _apiStatus = ApiStatus.isError;
        errorMessage = NetworkExceptions.getErrorMessage(error);
      });
    }, responseError: (ResponseError error) {
      setState(() {
        _apiStatus = ApiStatus.isError;
        errorMessage = error.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: DefaultAppbar(
            title: "${widget.notification.postOwner.code}'s Post"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(child: Builder(
        builder: (context) {
          if (_apiStatus == ApiStatus.isBusy) {
            return ViewModels.buildLoader();
          }
          if (_apiStatus == ApiStatus.isError) {
            return ViewModels.buildErrorWidget(errorMessage, () => _init);
          }
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: PostView(post: post),
          );
        },
      )),
    );
  }
}
