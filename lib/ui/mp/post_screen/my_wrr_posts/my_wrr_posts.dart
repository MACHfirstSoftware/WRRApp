import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWRRPosts extends StatefulWidget {
  const MyWRRPosts({Key? key}) : super(key: key);

  @override
  State<MyWRRPosts> createState() => _MyWRRPostsState();
}

class _MyWRRPostsState extends State<MyWRRPosts>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  late ScrollController scrollController;
  late RefreshController _refreshController;
  late RefreshController _refreshController2;
  DateTime? _lastRecordTime;
  bool allLoaded = false;
  bool onLoading = false;
  late User _user;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    scrollController = ScrollController();
    _refreshController = RefreshController(initialRefresh: false);
    _refreshController2 = RefreshController(initialRefresh: false);
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
    _refreshController.dispose();
    _refreshController2.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => keepAlive;

  _init({bool isInit = false}) async {
    await Provider.of<WRRPostProvider>(context, listen: false)
        .getMyWRRPosts(_user.id, isInit: isInit);
  }

  Future<void> _onRefresh() async {
    allLoaded = false;
    onLoading = false;
    await _init(isInit: true);
    _refreshController.refreshCompleted();
    _refreshController2.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          toolbarHeight: 5.h,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<WRRPostProvider>(builder: (context, model, _) {
          if (model.apiStatus == ApiStatus.isBusy) {
            return ViewModels.buildLoader();
          }
          if (model.apiStatus == ApiStatus.isError) {
            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: _onRefresh,
                header: const WaterDropMaterialHeader(
                  backgroundColor: AppColors.secondaryColor,
                  color: AppColors.btnColor,
                ),
                child: ViewModels.buildErrorWidget(model.errorMessage, _init));
          }

          return SmartRefresher(
            controller: _refreshController2,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: _onRefresh,
            header: const WaterDropMaterialHeader(
              backgroundColor: AppColors.secondaryColor,
              color: AppColors.btnColor,
            ),
            child: model.postsOfWRR.isEmpty
                ? ViewModels.postEmply()
                : ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(vertical: 0.h),
                    children: [
                      ...model.postsOfWRR
                          .map((post) => PostView(post: post))
                          .toList(),
                      Container(
                        color: Colors.transparent,
                        height: 5.h,
                        width: 428.w,
                        child:
                            onLoading ? const LinearProgressIndicator() : null,
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
                  ),
          );
        }));
  }
}
