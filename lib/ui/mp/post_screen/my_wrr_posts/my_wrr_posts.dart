import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_wrr_posts/widgets/my_wrr_post_appbar.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class MyWRRPosts extends StatefulWidget {
  const MyWRRPosts({Key? key}) : super(key: key);

  @override
  State<MyWRRPosts> createState() => _MyWRRPostsState();
}

class _MyWRRPostsState extends State<MyWRRPosts>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  late ScrollController scrollController;
  String? _lastRecordTime;
  bool allLoaded = false;
  bool onLoading = false;
  late User _user;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    scrollController = ScrollController();
    _init(isInit: true);
    scrollController.addListener(() async {
      final postProvider = Provider.of<WRRPostProvider>(context, listen: false);
      if (scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          !allLoaded) {
        print("----------DATA LOADING----------------");
        _lastRecordTime = postProvider.postsOfWRR.last.createdOn;
        print("Last Record Time : $_lastRecordTime");
        print("Total Post : ${postProvider.postsOfWRR.length}");
        setState(() {
          onLoading = true;
        });
        final postResponse = await PostService.getMyWRRPosts(_user.id,
            lastRecordTime: _lastRecordTime);
        postResponse.when(success: (List<Post> postsList) async {
          print("Incomming posts : ${postsList.length}");
          postProvider.postsOfWRR.addAll(postsList);
          if (postsList.length < 10) {
            allLoaded = true;
          }
          setState(() {
            onLoading = false;
          });
        }, failure: (NetworkExceptions error) {
          print(NetworkExceptions.getErrorMessage(error));
          setState(() {
            onLoading = false;
          });
        }, responseError: (ResponseError responseError) {
          print(responseError.error);
          setState(() {
            onLoading = false;
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => keepAlive;

  _init({bool isInit = false}) async {
    await Provider.of<WRRPostProvider>(context, listen: false)
        .getMyWRRPosts(_user.id, isInit: isInit);
  }

  // _scrollListner() async {
  //   final postProvider = Provider.of<PostProvider>(context, listen: false);
  //   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
  //       scrollController.position.outOfRange) {
  //     print("loading");
  //     _lastId = postProvider.posts.last.id;
  //     setState(() {
  //       onLoading = true;
  //     });
  //     final postResponse = await PostService.getMyPost(_lastId);
  //     postResponse.when(success: (List<Post> postsList) async {
  //       postProvider.posts.addAll(postsList);
  //       if (postsList.isEmpty) {
  //         allLoaded = true;
  //       }
  //       setState(() {
  //         onLoading = false;
  //       });
  //     }, failure: (NetworkExceptions error) {
  //       print(NetworkExceptions.getErrorMessage(error));
  //     }, responseError: (ResponseError responseError) {
  //       print(responseError.error);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const MyWRRPostAppBar(),
          elevation: 0,
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<WRRPostProvider>(builder: (context, model, _) {
          if (model.apiStatus == ApiStatus.isBusy) {
            return ViewModels.buildLoader();
          }
          if (model.apiStatus == ApiStatus.isError) {
            return ViewModels.buildErrorWidget(model.errorMessage, _init);
          }

          if (model.postsOfWRR.isEmpty) {
            return ViewModels.postEmply();
          }

          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(0),
            children: [
              ...model.postsOfWRR.map((post) => PostView(post: post)).toList(),
              Container(
                color: Colors.transparent,
                height: 5.h,
                width: 428.w,
                child: onLoading ? const LinearProgressIndicator() : null,
              ),
              if (allLoaded)
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    "No more data",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                )
            ],
          );
        }));
  }
}
