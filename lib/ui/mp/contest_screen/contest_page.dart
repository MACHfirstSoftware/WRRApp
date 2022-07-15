import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/ui/mp/contest_screen/widget/contest_appbar.dart';
import 'package:wisconsin_app/ui/mp/post_screen/post_view/post_view.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({Key? key}) : super(key: key);

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage>
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
    await Provider.of<ContestProvider>(context, listen: false)
        .getContestPosts(_user.id, isInit: isInit);
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
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .8],
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const ContestAppBar(),
              elevation: 0,
              toolbarHeight: 70.h,
              automaticallyImplyLeading: false,
            ),
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
                      backgroundColor: AppColors.secondaryColor,
                      color: AppColors.btnColor,
                    ),
                    child:
                        ViewModels.buildErrorWidget(model.errorMessage, _init));
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
                child: model.contestPosts.isEmpty
                    ? ViewModels.postEmply()
                    : ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          ...model.contestPosts
                              .map((post) => PostView(post: post))
                              .toList(),
                        ],
                      ),
              );
            })));
  }
}
