import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/controllers/slide_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/screens/basescreen/base_screen.dart';

void main() async {
  Paint.enableDithering = true;
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));

    Get.put(DatabaseController());
    Get.put(NavController());
    Get.put(SlideController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurpleAccent.shade400,
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.light,
            accentColor: Colors.deepPurpleAccent.shade400,
            backgroundColor: kBgColorLight),
        textTheme: kBaseTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: kBgColorLight,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurpleAccent.shade400,
          splashColor: Colors.white10,
          splashFactory: InkRipple.splashFactory,
          accentColor: Colors.deepPurpleAccent.shade100,
          colorScheme: ColorScheme.dark(
              primary: Colors.deepPurple,
              brightness: Brightness.dark,
              primaryVariant: Colors.deepPurpleAccent.shade400,
              background: kBgColorDark,
              onBackground: Colors.white,
              secondary: Color(0xff372e61)),
          textTheme: kBaseTextTheme(ThemeData.dark().textTheme),
          accentTextTheme: kBaseTextTheme(ThemeData.dark().accentTextTheme),
          primaryTextTheme: kBaseTextTheme(ThemeData.dark().primaryTextTheme),
          scaffoldBackgroundColor: kBgColorDark,
          tooltipTheme: TooltipThemeData(
              textStyle: kBaseTextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              )),
          appBarTheme: ThemeData.dark()
              .appBarTheme
              .copyWith(textTheme: kBaseTextTheme(ThemeData.dark().textTheme)),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: kAppbarColorDark,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: kBaseTextStyle(fontWeight: FontWeight.w500),
            unselectedLabelStyle: kBaseTextStyle(fontWeight: FontWeight.w500),
            selectedItemColor: Colors.deepPurpleAccent.shade100,
            unselectedItemColor: Colors.white,
          ),
          scrollbarTheme: ThemeData.dark().scrollbarTheme.copyWith(
                thumbColor: MaterialStateProperty.all(Colors.white12),
                trackColor: MaterialStateProperty.all(Colors.white54),
              )),
      customTransition: MyScaleTransition(),
      transitionDuration: Duration(milliseconds: 300),
      home: HomePage(),
    );
  }
}

class MyScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      ),
    );
  }
}
