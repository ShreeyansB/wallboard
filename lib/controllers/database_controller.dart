import 'package:get/get.dart';
import 'package:wall/models/wallpaper_model.dart';

class DatabaseProvider extends GetConnect {
  static String jsonURL = "https://api.jsonbin.io/b/61052fea046287097ea3f7c6";

  Future<Response> getWalls() => get(jsonURL);
}

class DatabaseController extends GetxController {
  DatabaseProvider dbProvider = DatabaseProvider();
  List<WallpaperModel> wallpapers = [];

  Future<bool> initWalls() async {
    Response response = await dbProvider.getWalls();
    if (response.statusCode != 200)
      return false;
    else {
      response.body.forEach((map) {
        WallpaperModel? object = WallpaperModel.fromJson(map);
        if (object != null) wallpapers.add(object);
      });
      return true;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    initWalls()
        .then((value) => wallpapers.forEach((element) => print(element.name)));
  }
}
