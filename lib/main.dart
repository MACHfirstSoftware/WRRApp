import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/enum/subscription_status.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/all_post_provider.dart';
import 'package:wisconsin_app/providers/contest_provider.dart';
import 'package:wisconsin_app/providers/notification_provider.dart';
import 'package:wisconsin_app/providers/region_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/region_provider.dart';
import 'package:wisconsin_app/providers/report_post_provider.dart';
import 'package:wisconsin_app/providers/revenuecat_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/providers/register_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/services/purchases_service.dart';
import 'package:wisconsin_app/services/questionnaire_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/ui/mp/bottom_navbar/bottom_navbar.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/custom_http.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  CustomHttp.setInterceptor();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await PurchasesService.init();
  List<County> _counties = await QuestionnaireService.getCounties(-1);
  User? _user;
  SubscriptionStatus _subscriptionStatus = SubscriptionStatus.free;
  Map<String, dynamic>? userData = await StoreUtils.getUser();
  if (userData != null) {
    final res =
        await UserService.signIn(userData["email"], userData["password"]);
    res.when(success: (User user) async {
      _user = user;
    }, failure: (NetworkExceptions err) {
      if (kDebugMode) {
        print("failed to get user");
      }
    }, responseError: (ResponseError err) {
      if (kDebugMode) {
        print("failed to get user");
      }
    });
  }

  if (_user != null) {
    final res = await PurchasesService.login(userId: _user!.id);
    // print("RES : $res");
    if (res) {
      // print("LOGIN MAIN");
      _subscriptionStatus = SubscriptionStatus.premium;
    }
  }

  if (_counties.isNotEmpty) {
    FlutterNativeSplash.remove();
  }
  runApp(MyApp(
      counties: _counties,
      user: _user,
      subscriptionStatus: _subscriptionStatus));
}

class MyApp extends StatefulWidget {
  final List<County> counties;
  final User? user;
  final SubscriptionStatus subscriptionStatus;
  const MyApp(
      {Key? key,
      required this.counties,
      this.user,
      required this.subscriptionStatus})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // print("${widget.subscriptionStatus}  ${widget.user?.appUserId}");
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterProvider>(
            create: (_) => RegisterProvider()),
        ChangeNotifierProvider<CountyProvider>(
            create: (_) => CountyProvider(widget.counties)),
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(widget.user)),
        ChangeNotifierProvider<WeatherProvider>(
            create: (_) => WeatherProvider()),
        ChangeNotifierProvider<WRRPostProvider>(
            create: (_) => WRRPostProvider()),
        ChangeNotifierProvider<RegionPostProvider>(
            create: (_) => RegionPostProvider()),
        ChangeNotifierProvider<RegionProvider>(create: (_) => RegionProvider()),
        ChangeNotifierProvider<ReportPostProvider>(
            create: (_) => ReportPostProvider()),
        ChangeNotifierProvider<AllPostProvider>(
            create: (_) => AllPostProvider()),
        ChangeNotifierProvider<ContestProvider>(
            create: (_) => ContestProvider()),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider()),
        ChangeNotifierProvider<RevenueCatProvider>(
            create: (_) => RevenueCatProvider(widget.subscriptionStatus)),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wisconsin Rut Resort App',
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: AppColors.btnColor,
              // brightness: Brightness.dark,
              primarySwatch: const MaterialColor(0xFFF23A02, <int, Color>{
                50: Color(0x0DF23A02),
                100: Color(0x1AF23A02),
                200: Color(0x33F23A02),
                300: Color(0x4DF23A02),
                400: Color(0x66F23A02),
                500: Color(0x80F23A02),
                600: Color(0x99F23A02),
                700: Color(0xB3F23A02),
                800: Color(0xCCF23A02),
                900: Color(0xE6F23A02),
              }),
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
        child:
            widget.user != null ? const BottomNavBar() : const AuthMainPage(),
      ),
    );
  }
}
