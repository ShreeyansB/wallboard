import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/screens/basescreen/widgets/bottom_nav_bar.dart';
import 'package:wall/utils/size_config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var navController = Get.find<NavController>();
  final PageStorageBucket bucket = PageStorageBucket();

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.softLight,
            gradient: RadialGradient(
              colors: [Colors.white54, Colors.transparent],
              center: Alignment.bottomRight,
              radius: SizeConfig.safeBlockVertical * 0.4,
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: kToolbarHeight + SizeConfig.safeBlockVertical * 1,
            textTheme: Theme.of(context).textTheme,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Wallpapers",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  fontSize: SizeConfig.safeBlockHorizontal * 5.8),
            ),
          ),
          body: PageStorage(
            bucket: bucket,
            child: Obx(
              () => AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                reverseDuration: Duration(milliseconds: 400),
                switchInCurve: Curves.easeInQuint,
                switchOutCurve: Curves.easeOutQuint,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: navController.screens[navController.navIndex.value],
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavBar(),
        ),
      ),
    );
  }
}
