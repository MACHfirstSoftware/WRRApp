import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/post.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
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
  late User _user;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
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
            _user.id, postProvider.countyId,
            lastRecordTime: postProvider.lastRecordTime);
        postResponse.when(success: (List<Post> postsList) async {
          print(postsList.length);
          if (postsList.length < 10) {
            postProvider.allCountyPostLoaded = true;
          } else {
            postProvider.postsOfCounty.addAll(postsList);
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
    super.dispose();
  }

  @override
  bool get wantKeepAlive => keepAlive;

  _init({bool isInit = false}) async {
    await Provider.of<CountyPostProvider>(context, listen: false)
        .getMyCountyPosts(_user.id, isInit: isInit);
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

          if (model.postsOfCounty.isEmpty) {
            return ViewModels.postEmply();
          }

          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(0),
            children: [
              ...model.postsOfCounty
                  .map((post) => PostView(post: post))
                  .toList(),
              Container(
                color: Colors.transparent,
                height: 5.h,
                width: 428.w,
                child: onLoading ? const LinearProgressIndicator() : null,
              ),
              if (model.allCountyPostLoaded)
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
          );
        }));
  }
}
