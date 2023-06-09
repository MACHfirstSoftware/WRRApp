import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/forecast_body.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/weather_appbar.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/current_weather_details.dart';
import 'package:wisconsin_app/utils/hero_dialog_route.dart';
import 'package:wisconsin_app/widgets/confirmation_popup.dart';
import 'package:wisconsin_app/widgets/subscription_model_sheet.dart';
import 'package:wisconsin_app/widgets/tab_title.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    Key? key,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    _init();
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    _tabController.addListener(() {
      _onTabChange(_tabController.index);
    });
    super.initState();
  }

  _init() {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider.isPremium =
        Provider.of<RevenueCatProvider>(context, listen: false)
                .subscriptionStatus ==
            SubscriptionStatus.premium;
    weatherProvider.getWeatherDetails(isInit: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _onTabChange(int? tabIndex) {
    if (tabIndex! == 0) {
      Provider.of<WeatherProvider>(context, listen: false).onPagechange(-1);
      _index = 0;
      _pageController.jumpToPage(_index);
    } else {
      Provider.of<WeatherProvider>(context, listen: false).onPagechange(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 50.h,
        title: const WeatherAppBar(),
        bottom: TabBar(
            controller: _tabController,
            onTap: (int? tabIndex) {
              _onTabChange(tabIndex);
            },
            tabs: [
              const Tab(
                child: TabTitle(title: "Current"),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (weatherProvider.pageNum != -1)
                      GestureDetector(
                        onTap: () {
                          if (_index > 0) {
                            _pageController.jumpToPage(--_index);
                          }
                        },
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 25.h,
                          color: Colors.white,
                        ),
                      ),
                    const TabTitle(title: "Forecast"),
                    if (weatherProvider.pageNum != -1)
                      GestureDetector(
                        onTap: () {
                          if (_index <
                              weatherProvider
                                      .weather.forecast.forecastday.length -
                                  2) {
                            _pageController.jumpToPage(++_index);
                          } else {
                            if (!weatherProvider.isPremium) {
                              Navigator.push(
                                  context,
                                  HeroDialogRoute(
                                      builder: (_) => ConfirmationPopup(
                                            title: "Want to upgrade?",
                                            message:
                                                "Upgrade to premium membership to get more daily weather details.",
                                            leftBtnText: "Upgrade",
                                            rightBtnText: "Cancel",
                                            onTap: () {
                                              SubscriptionUtil.getPlans(
                                                  context: context,
                                                  userId:
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .id);
                                            },
                                          )));
                            }
                          }
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25.h,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              )
            ]),
      ),
      body: Consumer<WeatherProvider>(builder: (context, weatherProvider, _) {
        if (weatherProvider.apiStatus == ApiStatus.isBusy) {
          return ViewModels.buildLoader();
        }
        if (weatherProvider.apiStatus == ApiStatus.isError) {
          return ViewModels.buildErrorWidget(
              weatherProvider.errorMessage, _init);
        }
        return TabBarView(
          // physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            CurrentWeatherDetails(
              forecastDay: weatherProvider.weather.forecast.forecastday[0],
              currentWeather: weatherProvider.weather.current,
              astro: weatherProvider.weather.forecast.forecastday[0].astro,
            ),
            PageView.builder(
                controller: _pageController,
                itemCount:
                    weatherProvider.weather.forecast.forecastday.length - 1,
                onPageChanged: (int index) {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .onPagechange(index);
                  _index = index;
                },
                itemBuilder: (_, index) {
                  return ForecastBody(
                      forecastDay: (weatherProvider.weather.forecast.forecastday
                          .sublist(1))[index]);
                })
          ],
        );
      }),
    );
  }
}
