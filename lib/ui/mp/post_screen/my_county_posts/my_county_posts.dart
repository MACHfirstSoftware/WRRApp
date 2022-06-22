import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/services/post_service.dart';
import 'package:wisconsin_app/ui/mp/post_screen/my_county_posts/widgets/my_county_post_appbar.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class MyCountyPosts extends StatefulWidget {
  const MyCountyPosts({Key? key}) : super(key: key);

  @override
  State<MyCountyPosts> createState() => _MyCountyPostsState();
}

class _MyCountyPostsState extends State<MyCountyPosts>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  late ScrollController scrollController;
  bool onLoading = false;

  @override
  void initState() {
    scrollController = ScrollController();
    _init(isInit: true);
    scrollController.addListener(() async {
      final postProvider =
          Provider.of<CountyPostProvider>(context, listen: false);
      if (scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          !postProvider.allCountyPostLoaded) {
        print("data loading");
        setState(() {
          onLoading = true;
        });
        final postResponse = await PostService.getMyCountyPosts(
            postProvider.lastPostId, postProvider.countyId);
        postResponse.when(success: (List<Post> postsList) async {
          print(postsList.length);
          if (postsList.isEmpty) {
            postProvider.allCountyPostLoaded = true;
          } else {
            postProvider.postsOfCounty.addAll(postsList);
            postProvider.lastPostId = postsList.last.id;
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
    await Provider.of<CountyPostProvider>(context, listen: false)
        .getMyCountyPosts(isInit: isInit);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const MyCountyPostAppBar(),
          elevation: 0,
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<CountyPostProvider>(builder: (context, model, _) {
          if (model.apiStatus == ApiStatus.isBusy) {
            return ViewModels.buildLoader();
          }
          if (model.apiStatus == ApiStatus.isError) {
            return ViewModels.buildErrorWidget(model.errorMessage, _init);
          }

          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(0),
            children: [
              ...model.postsOfCounty
                  .map((post) => PostView(post: post))
                  .toList(),
              if (onLoading)
                Center(
                  child: SizedBox(
                    height: 5.h,
                    width: 428.w,
                    child: const LinearProgressIndicator(),
                  ),
                ),
              if (model.allCountyPostLoaded)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      "No more data",
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          );
        }));
  }
}
