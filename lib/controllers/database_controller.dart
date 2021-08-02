import 'package:get/get.dart';
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
  var isLoaded = false.obs;
  var isPaginationLoaded = false.obs;

  Future<bool> initWalls() async {
    wallpapers = [];
    Response response = await dbProvider.getWalls();
    if (response.statusCode != 200) {
      update();
      isLoaded.value = true;
      return false;
    } else {
      response.body.forEach((map) {
        WallpaperModel? object = WallpaperModel.fromJson(map);
        if (object != null) dbWallpapers.add(object);
      });
      wallpapers.addAll(dbWallpapers.sublist(
          0, dbWallpapers.length < 6 ? dbWallpapers.length : 6));
      if (wallpapers.length == dbWallpapers.length)
        isPaginationLoaded.value = true;
      isLoaded.value = true;
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

  @override
  void onInit() async {
    super.onInit();
    initWalls();
  }
}
