import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:wall/models/wallpaper_model.dart';

void computePalette(SendPort isolateToMain) async {
  ReceivePort mainToIsolate = ReceivePort();
  isolateToMain.send(mainToIsolate.sendPort);

  mainToIsolate.listen((data) async {
    if (data is String) {
      print(data);
    } else {
      var image = data[0] as Uint8List;
      var url = data[1] as String;
      var img = Image.memory(image);
      print('[mainToIsolate] calculating $url');
      var palette = await PaletteGenerator.fromImageProvider(
        img.image,
        size: Size(300, 240),
        maximumColorCount: 6,
      );
      List<int> colors = [];
      palette.colors.forEach((element) => colors.add(element.value));
      print('[mainToIsolate] sending $url');
      isolateToMain.send([colors, url]);
    }
  });
}

class PaletteController extends GetxController {
  List<Color> colors = [];
  List<Map<dynamic, dynamic>> cachedColors = [];
  String? currentScreenUrl;

  FlutterIsolate? isolate;
  RxList<Object> args = RxList<Object>([]);
  bool isIsolateComputing = false;

  SendPort? mainToIsolate;
  ReceivePort? isolateToMain;

  @override
  void onInit() {
    super.onInit();
    initPaletteIsolate();
  }

  void addColors(List<Object> data) {
    var listInts = data[0] as List<int>;
    var url = data[1] as String;
    List<Color> tempColors = [];
    listInts.forEach((element) => tempColors.add(Color(element)));
    cachedColors.add({"url": url, "colors": tempColors});
    if (url == currentScreenUrl) {
      colors = tempColors;
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

  void initPaletteIsolate() async {
    mainToIsolate = await initIsolate();
    mainToIsolate!.send('This is from main()');
    args.listen((data) {
      mainToIsolate!.send(data);
    });
  }

  Future<SendPort> initIsolate() async {
    Completer<SendPort> completer = Completer<SendPort>();
    isolateToMain = ReceivePort();

    isolateToMain!.listen((data) {
      if (data is SendPort) {
        SendPort mainToIsolateStream = data;
        completer.complete(mainToIsolateStream);
      } else {
        addColors(data);
        isIsolateComputing = false;
      }
    });

    isolate =
        await FlutterIsolate.spawn(computePalette, isolateToMain!.sendPort);
    return completer.future;
  }

  void getPalette(WallpaperModel wall) async {
    var cache = DefaultCacheManager();
    File file = await cache.getSingleFile(wall.url);
    mainToIsolate!.send([file.readAsBytesSync(), wall.url]);
  }
}
