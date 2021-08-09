import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/models/wallpaper_model.dart';

class PaletteController extends GetxController {
  List<Color> colors = [];
  List<Map<dynamic, dynamic>> cachedColors = [];
  String? currentScreenUrl;

  void addColors(List<Object> data, WallpaperModel wall) {
    var listInts = data[0] as List<int>;
    var url = data[1] as String;
    colors = [];
    if (url == currentScreenUrl) {
      listInts.forEach((element) => colors.add(Color(element)));
      cachedColors.add({"url": wall.url, "colors": colors});
      update();
    }
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
