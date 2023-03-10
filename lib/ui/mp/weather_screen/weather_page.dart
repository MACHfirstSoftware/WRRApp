import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/forecast_body.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/forecast_weather.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/weather_appbar.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/current_weather_details.dart';
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
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  int _index = 0;

  @override
  void initState() {
    _init();
    _pageController = PageController(initialPage: 0);

    super.initState();
  }

  _init() {
    Provider.of<WeatherProvider>(context, listen: false)
        .getWeatherDetails(isInit: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: 50.h,
          title: const WeatherAppBar(),
          bottom: TabBar(
              onTap: (int? tabIndex) {
                if (tabIndex! == 0) {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .onPagechange(-1);
                  _index = 0;
                  _pageController.jumpToPage(_index);
                } else {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .onPagechange(0);
                }
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
                                    1) {
                              _pageController.jumpToPage(++_index);
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
            children: [
              CurrentWeatherDetails(
                forecastDay: weatherProvider.weather.forecast.forecastday[0],
                currentWeather: weatherProvider.weather.current,
                astro: weatherProvider.weather.forecast.forecastday[0].astro,
              ),
              PageView.builder(
                  controller: _pageController,
                  itemCount:
                      weatherProvider.weather.forecast.forecastday.length,
                  onPageChanged: (int index) {
                    Provider.of<WeatherProvider>(context, listen: false)
                        .onPagechange(index);
                    _index = index;
                  },
                  itemBuilder: (_, index) {
                    return ForecastBody(
                        forecastDay: weatherProvider
                            .weather.forecast.forecastday[index]);
                  })
            ],
          );
        }),
      ),
    );
  }
}
