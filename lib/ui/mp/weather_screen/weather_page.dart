import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/forecast_weather.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/weather_appbar.dart';
import 'package:wisconsin_app/ui/mp/weather_screen/widget/current_weather_details.dart';
import 'package:wisconsin_app/widgets/tab_title.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class WeatherPage extends StatefulWidget {
  final County county;
  const WeatherPage({Key? key, required this.county}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    Provider.of<WeatherProvider>(context, listen: false)
        .getWeatherDetails(isInit: true);
  }

  @override
  void didUpdateWidget(WeatherPage oldWidget) {
    if (oldWidget.county != widget.county) {
      setState(() {
        keepAlive = false;
      });
      updateKeepAlive();
    } else {
      setState(() {
        keepAlive = true;
      });
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                } else {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .onPagechange(0);
                }
              },
              tabs: const [
                Tab(
                  child: TabTitle(title: "Current"),
                ),
                Tab(
                  child: TabTitle(title: "Forecast"),
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
                currentWeather: weatherProvider.weather.current,
                astro: weatherProvider.weather.forecast.forecastday[0].astro,
              ),
              ForecastWeather(
                  forecastDays: weatherProvider.weather.forecast.forecastday)
            ],
          );
        }),
      ),
    );
  }
}
