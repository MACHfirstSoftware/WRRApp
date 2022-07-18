import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/all_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_wrr_posts/widgets/my_wrr_post_appbar.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class AllPostsPage extends StatefulWidget {
  const AllPostsPage({Key? key}) : super(key: key);

  @override
  State<AllPostsPage> createState() => _AllPostsPageState();
}

class _AllPostsPageState extends State<AllPostsPage>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  late ScrollController scrollController;
  late RefreshController _refreshController;
  late RefreshController _refreshController2;
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
      final postProvider =
          Provider.of<AllPostProvider>(context, listen: false);
      if (scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          !postProvider.allPostLoaded) {
        print("data loading");
        setState(() {
          onLoading = true;
        });
        final postResponse = await PostService.getAllPosts(
            _user.id, postProvider.regionId,
            lastRecordTime: postProvider.lastRecordTime);
        postResponse.when(success: (List<Post> postsList) async {
          print(postsList.length);
          if (postsList.length < 10) {
            postProvider.allPostLoaded = true;
          } else {
            postProvider.allPosts.addAll(postsList);
            postProvider.lastRecordTime = postsList.last.createdOn;
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
    await Provider.of<AllPostProvider>(context, listen: false)
        .getAllPosts(_user.id, isInit: isInit);
  }

  Future<void> _onRefresh() async {
    Provider.of<AllPostProvider>(context, listen: false).allPostLoaded =
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const MyWRRPostAppBar(),
          elevation: 0,
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<AllPostProvider>(builder: (context, model, _) {
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
              child: model.allPosts.isEmpty
                  ? ViewModels.postEmply()
                  : ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(0),
                      children: [
                        ...model.allPosts
                            .map((post) => PostView(post: post))
                            .toList(),
                        Container(
                          color: Colors.transparent,
                          height: 5.h,
                          width: 428.w,
                          child: onLoading
                              ? const LinearProgressIndicator()
                              : null,
                        ),
                        if (model.allPostLoaded)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
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
                    ));
        }));
  }
}
