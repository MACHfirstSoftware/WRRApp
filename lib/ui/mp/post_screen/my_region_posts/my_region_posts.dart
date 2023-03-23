import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class MyRegionPosts extends StatefulWidget {
  const MyRegionPosts({Key? key}) : super(key: key);

  @override
  State<MyRegionPosts> createState() => _MyRegionPostsState();
}

class _MyRegionPostsState extends State<MyRegionPosts>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool keepAlive = true;
  late ScrollController scrollController;
  late RefreshController _refreshController;
  late RefreshController _refreshController2;
  bool onLoading = false;
  late User _user;
  bool showHideAnchor = false;
  bool keyboardIsOpen = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    _user = Provider.of<UserProvider>(context, listen: false).user;
    scrollController = ScrollController();
    _refreshController = RefreshController(initialRefresh: false);
    _refreshController2 = RefreshController(initialRefresh: false);
    _init(isInit: true);
    scrollController.addListener(() async {
      final postProvider =
          Provider.of<RegionPostProvider>(context, listen: false);
      if (scrollController.offset !=
              scrollController.position.minScrollExtent &&
          !keyboardIsOpen) {
        // print("show Anchor");
        setState(() {
          showHideAnchor = true;
        });
      } else {
        setState(() {
          showHideAnchor = false;
        });
      }
      if (scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          scrollController.position.atEdge &&
          // scrollController.position.outOfRange &&
          !postProvider.allPostLoaded) {
        // print("data loading");
        setState(() {
          onLoading = true;
        });
        final postResponse = await PostService.getMyRegionPosts(
            _user.id, postProvider.regionId,
            lastRecordTime: postProvider.lastRecordTime);
        postResponse.when(success: (List<Post> postsList) async {
          // print(postsList.length);
          postProvider.postsOfRegion.addAll(postsList);
          if (postsList.isNotEmpty) {
            postProvider.lastRecordTime = postsList.last.createdOn;
          }

          if (postsList.length < 10) {
            postProvider.allPostLoaded = true;
          }
          setState(() {
            onLoading = false;
          });
        }, failure: (NetworkExceptions error) {
          // print(NetworkExceptions.getErrorMessage(error));
          setState(() {
            onLoading = false;
          });
        }, responseError: (ResponseError responseError) {
          // print(responseError.error);
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
    WidgetsBinding.instance?.removeObserver(this);

    scrollController.dispose();
    _refreshController.dispose();
    _refreshController2.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != keyboardIsOpen) {
      setState(() {
        keyboardIsOpen = newValue;
        showHideAnchor = !newValue;
      });
    }
  }

  @override
  bool get wantKeepAlive => keepAlive;

  _init({bool isInit = false}) async {
    await Provider.of<RegionPostProvider>(context, listen: false)
        .getMyRegionPosts(_user.id, isInit: isInit);
  }

  Future<void> _onRefresh() async {
    Provider.of<RegionPostProvider>(context, listen: false).allPostLoaded =
        false;
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
        // title: const MyWRRPostAppBar(),
        elevation: 0,
        toolbarHeight: 5.h,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<RegionPostProvider>(builder: (context, model, _) {
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
                backgroundColor: AppColors.popBGColor,
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
              backgroundColor: AppColors.popBGColor,
              color: AppColors.btnColor,
            ),
            child: model.postsOfRegion.isEmpty
                ? ViewModels.postEmply()
                : ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(0),
                    children: [
                      ...model.postsOfRegion
                          .map((post) => PostView(post: post))
                          .toList(),
                      Container(
                        color: Colors.transparent,
                        height: 5.h,
                        width: 428.w,
                        child:
                            onLoading ? const LinearProgressIndicator() : null,
                      ),
                      if (model.allPostLoaded)
                        Padding(
                          padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
                          child: Text(
                            "No more data",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  ));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showHideAnchor
          ? FloatingActionButton(
              mini: true,
              heroTag: "go_top_myregion",
              backgroundColor: AppColors.btnColor,
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 30.h,
              ),
              onPressed: () {
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn);
                });
              })
          : null,
    );
  }
}
