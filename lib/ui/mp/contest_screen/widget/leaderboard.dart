import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/contest_post_view.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  late RefreshController _refreshController;
  late RefreshController _refreshController2;
  late User _user;

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _refreshController = RefreshController(initialRefresh: false);
    _refreshController2 = RefreshController(initialRefresh: false);
    _init(isInit: true);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _refreshController2.dispose();
    super.dispose();
  }

  _init({bool isInit = false}) async {
    // await Provider.of<ContestProvider>(context, listen: false).  //Un comment when deer season is available.
    //     .getContestPosts(_user.id, isInit: isInit);
  }

  Future<void> _onRefresh() async {
    await _init(isInit: true);
    _refreshController.refreshCompleted();
    _refreshController2.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Consumer<ContestProvider>(builder: (context, model, _) {
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
            child: model.contestPosts.isEmpty
                ? ViewModels.postEmply(
                    text:
                        "Leaderboard will be open at the start of deer season.")
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    itemCount: model.contestPosts.length,
                    itemBuilder: (_, index) {
                      return ContestPostView(
                        post: model.contestPosts[index],
                        sortOrder: index + 1,
                      );
                    },
                  ),
          );
        }));
  }
}
