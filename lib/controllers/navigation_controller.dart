import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wall/screens/collscreen/coll_screen.dart';
import 'package:wall/screens/favscreen/fav_screen.dart';
import 'package:wall/screens/wallscreen/wall_screen.dart';

class NavController extends GetxController {
  var navIndex = 0.obs;

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
