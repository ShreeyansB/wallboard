import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wall/controllers/about_controller.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/controllers/palette_controller.dart';
import 'package:wall/controllers/search_controller.dart';
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
    Get.put(PaletteController());
    Get.put(SearchController());
    Get.put(AboutController());

    Get.changeThemeMode(Get.find<DatabaseController>().getThemeType());

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: lPrimarySwatch,
        primaryColor: lPrimarySwatch,
        splashColor: lSplashColor,
        splashFactory: InkRipple.splashFactory,
        accentColor: lAccentColor,
        colorScheme: ColorScheme.light(
            brightness: Brightness.light,
            background: lBgColor,
            onBackground: Colors.black,
            secondary: lBgColorAlt),
        textTheme: kBaseTextTheme(
          ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(color: lBannerTitleColor),
              headline5: TextStyle(color: lBannerAuthorColor),
              headline2: TextStyle(color: lButtonBgColor),
              headline1: TextStyle(color: lBannerColor)),
        ),
        accentTextTheme: kBaseTextTheme(ThemeData.light().accentTextTheme),
        primaryTextTheme: kBaseTextTheme(ThemeData.light().primaryTextTheme),
        scaffoldBackgroundColor: lBgColor,
        tooltipTheme: TooltipThemeData(
            textStyle: kBaseTextStyle(color: lBannerTitleColor),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(10),
            )),
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              textTheme: kBaseTextTheme(ThemeData.light().textTheme),
              backgroundColor: lAppbarColor,
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lBottombarColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: kBaseTextStyle(fontWeight: FontWeight.w500),
          unselectedLabelStyle: kBaseTextStyle(fontWeight: FontWeight.w500),
          selectedItemColor: lAccentColor,
          unselectedItemColor: lBannerTitleColor,
        ),
        scrollbarTheme: ThemeData.light().scrollbarTheme.copyWith(
              thumbColor: MaterialStateProperty.all(lSplashColor),
            ),
        popupMenuTheme:
            ThemeData.light().popupMenuTheme.copyWith(color: lBgColorAlt),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: dPrimarySwatch,
        primaryColor: dPrimarySwatch,
        splashColor: dSplashColor,
        splashFactory: InkRipple.splashFactory,
        accentColor: dAccentColor,
        colorScheme: ColorScheme.dark(
            brightness: Brightness.dark,
            background: dBgColor,
            onBackground: Colors.white,
            secondary: dBgColorAlt),
        textTheme: kBaseTextTheme(
          ThemeData.dark().textTheme.copyWith(
              headline6: TextStyle(color: dBannerTitleColor),
              headline5: TextStyle(color: dBannerAuthorColor),
              headline2: TextStyle(color: dButtonBgColor),
              headline1: TextStyle(color: dBannerColor)),
        ),
        accentTextTheme: kBaseTextTheme(ThemeData.dark().accentTextTheme),
        primaryTextTheme: kBaseTextTheme(ThemeData.dark().primaryTextTheme),
        scaffoldBackgroundColor: dBgColor,
        tooltipTheme: TooltipThemeData(
            textStyle: kBaseTextStyle(color: dBannerTitleColor),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            )),
        appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              textTheme: kBaseTextTheme(ThemeData.dark().textTheme),
              backgroundColor: dAppbarColor,
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: dBottombarColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: kBaseTextStyle(fontWeight: FontWeight.w500),
          unselectedLabelStyle: kBaseTextStyle(fontWeight: FontWeight.w500),
          selectedItemColor: dAccentColor,
          unselectedItemColor: dBannerTitleColor,
        ),
        scrollbarTheme: ThemeData.dark().scrollbarTheme.copyWith(
              thumbColor: MaterialStateProperty.all(dSplashColor),
            ),
        popupMenuTheme:
            ThemeData.dark().popupMenuTheme.copyWith(color: dBgColorAlt),
      ),
      customTransition: MyScaleTransition(),
      transitionDuration: Duration(milliseconds: 600),
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
