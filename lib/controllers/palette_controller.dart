import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/models/wallpaper_model.dart';

class PaletteController extends GetxController {
  List<Color> colors = [];
  List<Map<dynamic, dynamic>> cachedColors = [];

  void addColors(List<int> listInts, WallpaperModel wall) {
    colors = [];
    listInts.forEach((element) => colors.add(Color(element)));
    cachedColors.add({"url": wall.url, "colors": colors});
    update();
  }

  void getFromCache(WallpaperModel wall) {
    for (var i = 0; i < cachedColors.length; i++) {
      if (cachedColors[i]["url"] == wall.url) {
        colors = cachedColors[i]["colors"] as List<Color>;
        break;
      }
    }
    update();
  }
}
