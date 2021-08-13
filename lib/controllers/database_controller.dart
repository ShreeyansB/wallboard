import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/models/wallpaper_model.dart';

class DatabaseProvider extends GetConnect {
  static String jsonURL =
      "https://api.jsonbin.io/b/61052fea046287097ea3f7c6/latest";

  Future<Response> getWalls() => get(jsonURL);
}

class DatabaseController extends GetxController {
  DatabaseProvider dbProvider = DatabaseProvider();
  List<WallpaperModel> dbWallpapers = [];
  List<WallpaperModel> wallpapers = [];
  List<String> collections = [];

  // List<WallpaperModel> favorites = dbController.dbWallpapers
  //         .where((wall) => dbController.favorites.contains(wall.url))
  //         .toList();
  List<WallpaperModel> listFavorites = [];
  List<WallpaperModel> dbFavorites = [];

  GetStorage storage = GetStorage();
  var isLoaded = false.obs;
  var isPaginationLoaded = false.obs;

  Future<bool> initWalls() async {
    int count = dbWallpapers.length;
    dbWallpapers = [];
    Response response = await dbProvider.getWalls();
    if (response.statusCode != 200) {
      update();
      isLoaded.value = true;
      return false;
    } else {
      response.body.forEach((map) {
        WallpaperModel? object = WallpaperModel.fromJson(map);
        if (object != null) dbWallpapers.add(object);
        // dbWallpapers.forEach(
        //     (element) => element.url = "http://via.placeholder.com/100x200");
      });
      if (dbWallpapers.length == count && count != 0)
        isPaginationLoaded.value = false;
      if (wallpapers.isEmpty) {
        wallpapers.addAll(dbWallpapers.sublist(
            0, dbWallpapers.length < 12 ? dbWallpapers.length : 12));
        if (wallpapers.length == dbWallpapers.length)
          isPaginationLoaded.value = true;
        isLoaded.value = true;
      }
      dbWallpapers.forEach((wall) {
        if (!collections.contains(wall.collection))
          collections.add(wall.collection);
      });
      collections.add(kCollectionNameIfNull);
      collections.remove(kCollectionNameIfNull);

      var tempFav = List<String>.from(storage.read('fav') ?? []);
      dbFavorites =
          dbWallpapers.where((wall) => tempFav.contains(wall.url)).toList();
      listFavorites = dbFavorites.toList();
      update();
      return true;
    }
  }

  void addWalls() {
    if (!isPaginationLoaded.value) {
      wallpapers.addAll(dbWallpapers.sublist(
          wallpapers.length,
          wallpapers.length + 6 > dbWallpapers.length
              ? dbWallpapers.length
              : wallpapers.length + 6));
      if (wallpapers.length == dbWallpapers.length)
        isPaginationLoaded.value = true;

      update();
    }
  }

  void addFavorite(String url) {
    dbFavorites.add(dbWallpapers.firstWhere((wall) => wall.url == url));
    var tempFav = [];
    dbFavorites.forEach((wall) => tempFav.add(wall.url));
    storage.write('fav', tempFav);
    update(["fav"]);
  }

  void removeFavorite(String url) {
    dbFavorites.remove(dbWallpapers.firstWhere((wall) => wall.url == url));
    var tempFav = [];
    dbFavorites.forEach((wall) => tempFav.add(wall.url));
    storage.write('fav', tempFav);
    update(["fav"]);
  }

  void setThemeType(ThemeMode mode) {
    storage.write('theme', mode.toString());
  }

  ThemeMode getThemeType() {
    ThemeMode result = stringToTheme(storage.read('theme'));
    return result;
  }

  ThemeMode stringToTheme(dynamic val) {
    if (val == "ThemeMode.dark")
      return ThemeMode.dark;
    else if (val == "ThemeMode.light")
      return ThemeMode.light;
    else
      return ThemeMode.system;
  }

  @override
  void onInit() async {
    super.onInit();
    initWalls();
  }
}
