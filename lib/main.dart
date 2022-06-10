import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wisconsin_app/ui/landing/sign_in_page/sign_in_page.dart';
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
    return ScreenUtilInit(
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
      child: const SignInPage(),
    );
  }
}
