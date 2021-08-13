import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wallboard/screens/collscreen/coll_screen.dart';
import 'package:wallboard/screens/favscreen/fav_screen.dart';
import 'package:wallboard/screens/wallscreen/wall_screen.dart';

class NavController extends GetxController {
  var navIndex = 0.obs;
  var pageNames = ["Wallpapers", "Collections", "Favorites"];

  List screens = [
    WallScreen(
      key: PageStorageKey("WallPage"),
    ),
    CollScreen(
      key: PageStorageKey("CollPage"),
    ),
    FavScreen(
      key: PageStorageKey("FavPage"),
    )
  ];
}
