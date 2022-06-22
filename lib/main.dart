import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/providers/county_post_provider.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/wrr_post_provider.dart';
import 'package:wisconsin_app/providers/register_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/providers/weather_provider.dart';
import 'package:wisconsin_app/ui/landing/auth_main_page/auth_main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/utils/custom_http.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 2), () {});
  FlutterNativeSplash.remove();
  CustomHttp.setInterceptor();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterProvider>(
            create: (_) => RegisterProvider()),
        ChangeNotifierProvider<CountyProvider>(create: (_) => CountyProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<WeatherProvider>(
            create: (_) => WeatherProvider()),
        ChangeNotifierProvider<WRRPostProvider>(
            create: (_) => WRRPostProvider()),
        ChangeNotifierProvider<CountyPostProvider>(
            create: (_) => CountyPostProvider()),
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
              primarySwatch: const MaterialColor(0xFFF23A02, <int, Color>{
                50: Color(0xFFF23A02),
                100: Color(0xFFF23A02),
                200: Color(0xFFF23A02),
                300: Color(0xFFF23A02),
                400: Color(0xFFF23A02),
                500: Color(0xFFF23A02),
                600: Color(0xFFF23A02),
                700: Color(0xFFF23A02),
                800: Color(0xFFF23A02),
                900: Color(0xFFF23A02),
              }),
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
        child: const AuthMainPage(),
      ),
    );
  }
}
