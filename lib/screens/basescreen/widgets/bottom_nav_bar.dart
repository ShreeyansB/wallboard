import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/utils/size_config.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  var navController = Get.find<NavController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          selectedFontSize: SizeConfig.safeBlockHorizontal * 3,
          unselectedFontSize: SizeConfig.safeBlockHorizontal * 3,
          iconSize: SizeConfig.safeBlockHorizontal * 7.5,
          selectedLabelStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(fontWeight: FontWeight.w600),
          items: [
            BottomNavigationBarItem(
                icon: Text(
                  kWallpapersNavIcon,
                  style: TextStyle(
                      fontFamily: "RemixIcons",
                      color: navController.navIndex.value == 0
                          ? context
                              .theme.bottomNavigationBarTheme.selectedItemColor
                          : context.theme.bottomNavigationBarTheme
                              .unselectedItemColor,
                      fontSize: SizeConfig.safeBlockHorizontal * 8),
                ),
                label: "Wallpapers"),
            BottomNavigationBarItem(
                icon: Text(
                  kCollectionsNavIcon,
                  style: TextStyle(
                      fontFamily: "RemixIcons",
                      color: navController.navIndex.value == 1
                          ? context
                              .theme.bottomNavigationBarTheme.selectedItemColor
                          : context.theme.bottomNavigationBarTheme
                              .unselectedItemColor,
                      fontSize: SizeConfig.safeBlockHorizontal * 8),
                ),
                label: "Collections"),
            BottomNavigationBarItem(
                icon: Text(
                  kFavoritesNavIcon,
                  style: TextStyle(
                      fontFamily: "RemixIcons",
                      color: navController.navIndex.value == 2
                          ? context
                              .theme.bottomNavigationBarTheme.selectedItemColor
                          : context.theme.bottomNavigationBarTheme
                              .unselectedItemColor,
                      fontSize: SizeConfig.safeBlockHorizontal * 8),
                ),
                label: "Favorites"),
          ],
          currentIndex: navController.navIndex.value,
          onTap: (value) {
            navController.navIndex.value = value;
          },
        ));
  }
}
