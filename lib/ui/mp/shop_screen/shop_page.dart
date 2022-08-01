import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/sponsor.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/shop_service.dart';
import 'package:wisconsin_app/ui/mp/shop_screen/sponsor_card.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // late bool isPremium;

  @override
  void initState() {
    // isPremium = Provider.of<UserProvider>(context, listen: false)
    //     .user
    //     .subscriptionPerson![0]
    //     .subscriptionApiModel
    //     .isPremium;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _subscriptionStatus =
        Provider.of<RevenueCatProvider>(context).subscriptionStatus;
    // print("IN SHOP PAGE : $_subscriptionStatus");
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 80.h,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DefaultAppbar(title: "Shop"),
            if (_subscriptionStatus == SubscriptionStatus.premium)
              Text(
                "Enjoy the great deals from our sponsors. Also, don't forget to check out our new store for WRR merch.",
                style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
                maxLines: 2,
              )
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _subscriptionStatus == SubscriptionStatus.premium
          ? const ShopContent()
          : ViewModels.freeSubscription(
              isShopPage: true,
              context: context,
              userId:
                  Provider.of<UserProvider>(context, listen: false).user.id),
    );
  }
}

class ShopContent extends StatefulWidget {
  const ShopContent({Key? key}) : super(key: key);

  @override
  State<ShopContent> createState() => _ShopContentState();
}

class _ShopContentState extends State<ShopContent>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late RefreshController _refreshController2;
  late ApiStatus _apiStatus;
  List<Sponsor> sponsors = [];
  String errorMessage = '';

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _refreshController2 = RefreshController(initialRefresh: false);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _refreshController2.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _init();
    _refreshController.refreshCompleted();
    _refreshController2.refreshCompleted();
  }

  _init() async {
    setState(() {
      _apiStatus = ApiStatus.isBusy;
    });
    final res = await ShopService.getSponsors();
    res.when(success: (List<Sponsor> sponsorsList) {
      setState(() {
        _apiStatus = ApiStatus.isIdle;
        errorMessage = '';
        sponsors = sponsorsList;
      });
    }, failure: (NetworkExceptions error) {
      setState(() {
        _apiStatus = ApiStatus.isError;
        errorMessage = NetworkExceptions.getErrorMessage(error);
        sponsors = [];
      });
    }, responseError: (ResponseError error) {
      setState(() {
        _apiStatus = ApiStatus.isError;
        errorMessage = error.error;
        sponsors = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_apiStatus == ApiStatus.isBusy) {
      return ViewModels.buildLoader();
    }
    if (_apiStatus == ApiStatus.isError) {
      return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _onRefresh,
          header: const WaterDropMaterialHeader(
            backgroundColor: AppColors.popBGColor,
            color: AppColors.btnColor,
          ),
          child: ViewModels.buildErrorWidget(errorMessage, () => _init));
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
        child: sponsors.isEmpty
            ? ViewModels.postEmply()
            : ListView.separated(
                padding: EdgeInsets.only(top: 5.h),
                itemBuilder: (_, index) {
                  return SponsorCard(sponsor: sponsors[index]);
                },
                separatorBuilder: (_, index) {
                  return SizedBox(
                    height: 5.h,
                  );
                },
                itemCount: sponsors.length));
  }

  @override
  bool get wantKeepAlive => true;
}
