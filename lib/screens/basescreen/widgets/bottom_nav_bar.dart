import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/navigation_controller.dart';
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
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.amp_stories_outlined), label: "Wallpapers"),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox_outlined), label: "Collections"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded), label: "Favorites"),
          ],
          currentIndex: navController.navIndex.value,
          onTap: (value) {
            navController.navIndex.value = value;
          },
        ));
  }
}
