import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wall/controllers/slide_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/models/wallpaper_model.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/screens/basescreen/widgets/like_button.dart';
import 'package:wall/utils/size_config.dart';
import 'package:palette_generator/palette_generator.dart';

void computePalette(List<Object> args) async {
  var image = args[0] as Uint8List;
  var port = args[1] as SendPort;
  var img = Image.memory(image);
  var palette = await PaletteGenerator.fromImageProvider(
    img.image,
    maximumColorCount: 7,
  );
  List<int> colors = [];
  palette.colors.forEach((element) => colors.add(element.value));
  port.send(colors);
}

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key, required this.wall}) : super(key: key);
  final WallpaperModel wall;

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with TickerProviderStateMixin {
  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  PaletteGenerator? palette;

  SlideController slideController = Get.find<SlideController>();

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    Matrix4 _endMatrix;
    Offset _position = _doubleTapDetails.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      _endMatrix = Matrix4.identity();
    } else {
      _endMatrix = Matrix4.identity()
        ..translate(-_position.dx, -_position.dy)
        ..scale(2.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: _endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _animation.value;
      });
  }

  Future<PaletteGenerator?> updatePalette() async {
    var cache = DefaultCacheManager();
    File file = await cache.getSingleFile(widget.wall.url);
    // Image img = Image.file(file);
    // ui.Image image = await load(file);
    List<int> data;
    var port = ReceivePort();
    port.listen((msg) {
      data = msg;
      data.forEach((element) => print(Color(element)));
    });
    var isolate = await FlutterIsolate.spawn(
      computePalette,
      [file.readAsBytesSync(), port.sendPort],
    );
    print("poo");
    // isolate.kill();
    return null;
  }

  Future<ui.Image> load(File file) async {
    var data = await file.readAsBytes();
    ui.Codec codec = await ui.instantiateImageCodec(data);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_rounded),
            iconSize: SizeConfig.safeBlockHorizontal * 7,
          ),
          title: Hero(
            tag: widget.wall.url,
            flightShuttleBuilder: (flightContext, animation, flightDirection,
                    fromHeroContext, toHeroContext) =>
                DefaultTextStyle(
                    style: kBaseTextStyle(),
                    child: SingleChildScrollView(child: toHeroContext.widget)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.wall.name,
                  maxLines: 1,
                  style: TextStyle(
                      color: kBannerTitleColor,
                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none),
                ),
                if (kShowAuthor)
                  Text(
                    "by ${widget.wall.author ?? kNullAuthorName}",
                    maxLines: 1,
                    style: context.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: kBannerAuthorColor,
                        fontSize: SizeConfig.safeBlockHorizontal * 3),
                  ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: kBannerColor,
        ),
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            clipBehavior: Clip.none,
            maxScale: 4.0,
            constrained: false,
            child: GestureDetector(
              onTap: () {
                slideController.show.value = !slideController.show.value;
                slideController.update();
              },
              onDoubleTap: _handleDoubleTap,
              onDoubleTapDown: _handleDoubleTapDown,
              child: CachedNetworkImage(
                imageUrl: widget.wall.url,
                maxHeightDiskCache: MediaQuery.of(context).size.height ~/ 0.8,
                memCacheHeight: MediaQuery.of(context).size.height ~/ 0.8,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: Get.height,
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                fadeOutCurve: Curves.easeOutQuint,
                fadeOutDuration: Duration(milliseconds: 100),
                placeholder: (context, url) => Container(
                  width: Get.width,
                  child: LinearProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(),
                    child: Center(
                        child: Icon(
                      Icons.error,
                    ))),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<SlideController>(builder: (controller) {
              return AnimatedCrossFade(
                sizeCurve: Curves.easeOutQuad,
                firstCurve: Curves.easeOutCubic,
                secondCurve: Curves.easeOutCubic,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 300),
                crossFadeState: slideController.show.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: FutureBuilder<PaletteGenerator?>(
                    future: updatePalette(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return MyBottomSheet(
                            wall: widget.wall, palette: snapshot.data);

                      return LinearProgressIndicator();
                    }),
                secondChild: SizedBox(
                  width: double.infinity,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 75.0;
  final Widget child;

  const MyAppBar({Key? key, required this.child}) : super(key: key);
  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  SlideController slideController = Get.find<SlideController>();
  @override
  void initState() {
    super.initState();
    slideController.show.value = true;
    slideController.update();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlideController>(
      builder: (controller) {
        return AnimatedCrossFade(
          sizeCurve: Curves.easeOutQuad,
          firstCurve: Curves.easeOutCubic,
          secondCurve: Curves.easeOutCubic,
          duration: Duration(milliseconds: 300),
          reverseDuration: Duration(milliseconds: 300),
          crossFadeState: slideController.show.value
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: ConditionalParentWidget(
            condition: kBlurAmount != 0,
            conditionalBuilder: (child) => ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                    sigmaX: kBlurAmount,
                    sigmaY: kBlurAmount,
                    tileMode: TileMode.decal),
                child: child,
              ),
            ),
            child: widget.child,
          ),
          secondChild: SizedBox(
            width: double.infinity,
          ),
        );
      },
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({Key? key, required this.wall, required this.palette})
      : super(key: key);

  final WallpaperModel wall;
  final PaletteGenerator? palette;
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: kBlurAmount != 0,
      conditionalBuilder: (child) => ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
              sigmaX: kBlurAmount,
              sigmaY: kBlurAmount,
              tileMode: TileMode.decal),
          child: child,
        ),
      ),
      child: Container(
        color: kBannerColor,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: SizeConfig.safeBlockHorizontal * 10,
            right: SizeConfig.safeBlockHorizontal * 10,
            top: SizeConfig.safeBlockVertical * 3,
            bottom: SizeConfig.safeBlockVertical * 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.wall.name,
              maxLines: 1,
              style: context.textTheme.headline6!.copyWith(
                color: kBannerTitleColor,
                fontSize: SizeConfig.safeBlockHorizontal * 7.6,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (kShowAuthor)
              Text(
                "by ${widget.wall.author ?? kNullAuthorName}",
                style: context.textTheme.headline6!.copyWith(
                  color: kBannerAuthorColor,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            if (widget.wall.dimensions != null)
              RichText(
                text: TextSpan(
                  style: context.textTheme.headline6!,
                  children: [
                    TextSpan(
                        text: "Dimensions: ",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: kBannerAuthorColor)),
                    TextSpan(
                        text: widget.wall.dimensions,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: kBannerTitleColor)),
                  ],
                ),
              ),
            if (widget.wall.size != null)
              RichText(
                text: TextSpan(
                  style: context.textTheme.headline6!,
                  children: [
                    TextSpan(
                        text: "Size: ",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: kBannerAuthorColor)),
                    TextSpan(
                        text: widget.wall.size,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: kBannerTitleColor)),
                  ],
                ),
              ),
            if (widget.wall.license != null)
              RichText(
                text: TextSpan(
                  style: context.textTheme.headline6!,
                  children: [
                    TextSpan(
                        text: "License: ",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: kBannerAuthorColor)),
                    TextSpan(
                        text: widget.wall.license,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: kBannerTitleColor)),
                  ],
                ),
              ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 4,
            ),
            SheetButtonGrid(
              wall: widget.wall,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 4,
            ),
            PaletteGrid(
              wall: widget.wall,
              palette: widget.palette,
            )
          ],
        ),
      ),
    );
  }
}

class SheetButtonGrid extends StatelessWidget {
  SheetButtonGrid({
    Key? key,
    required this.wall,
  }) : super(key: key);

  final WallpaperModel wall;
  static const platform = MethodChannel('com.ballistic/wallpaper');

  void saveWallpaper(WallpaperModel wall) async {
    if (wall.downloadable ?? true) {
      final cache = DefaultCacheManager();
      final file = await cache.getSingleFile(wall.url);
      Directory appDocumentsDirectory = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory(); // TODO: Implement IOS File Visibility
      String appDocumentsPath = appDocumentsDirectory.path;
      File savedFile = File(appDocumentsPath +
          "/${wall.name}-${wall.author}${p.extension(file.path)}");
      savedFile.writeAsBytesSync(file.readAsBytesSync());
      Get.showSnackbar(GetBar(
        message: "Saved to $appDocumentsPath",
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 300),
        icon: Icon(Icons.download_done_rounded),
      ));
    } else {
      Get.showSnackbar(GetBar(
        message: "Wallpaper is not Downloadable",
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 300),
        icon: Icon(Icons.report_outlined),
      ));
    }
  }

  void setWallpaper(WallpaperModel wall) async {
    var cache = DefaultCacheManager();
    File file = await cache.getSingleFile(wall.url);
    platform.invokeMethod(
        "setWallpaper", {"uri": file.path}).then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      SheetButton(
        icon: kDownloadIcon,
        caption: "Download",
        onPressed: () => saveWallpaper(wall),
      ),
      SheetButton(
        icon: kSetWallpaperIcon,
        caption: "Favorite",
        widget: LikeButtonBG(
            url: wall.url,
            size: SizeConfig.safeBlockVertical * 3.4,
            duration: 500),
      ),
      SheetButton(
          icon: kSetWallpaperIcon,
          caption: "Set",
          onPressed: () => setWallpaper(wall)),
      SheetButton(icon: kInfoIcon, caption: "Info"),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
}

class SheetButton extends StatelessWidget {
  const SheetButton(
      {Key? key,
      required this.icon,
      required this.caption,
      this.widget,
      this.onPressed})
      : super(key: key);
  final String icon;
  final String caption;
  final Widget? widget;
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockHorizontal * kBorderRadius),
          child: Material(
            type: MaterialType.transparency,
            child: widget == null
                ? InkWell(
                    onTap: onPressed ?? () => print("Boo"),
                    splashFactory: context.theme.splashFactory,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kBannerTitleColor.withOpacity(0.27),
                          borderRadius: BorderRadius.circular(
                              SizeConfig.safeBlockHorizontal * kBorderRadius)),
                      padding:
                          EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                      child: Text(
                        icon,
                        style: context.theme.textTheme.headline6!.copyWith(
                            fontFamily: "RemixIcons",
                            color: kBannerTitleColor,
                            fontSize: SizeConfig.safeBlockHorizontal * 6),
                      ),
                    ),
                  )
                : widget,
          ),
        ),
        SizedBox(
          height: SizeConfig.safeBlockHorizontal * 1,
        ),
        Text(
          caption,
          style: context.theme.textTheme.headline6!.copyWith(
              color: kBannerTitleColor,
              fontSize: SizeConfig.safeBlockHorizontal * 2.7),
        ),
      ],
    );
  }
}

class PaletteGrid extends StatefulWidget {
  const PaletteGrid({Key? key, required this.wall, required this.palette})
      : super(key: key);

  final WallpaperModel wall;
  final PaletteGenerator? palette;

  @override
  _PaletteGridState createState() => _PaletteGridState();
}

class _PaletteGridState extends State<PaletteGrid> {
  @override
  Widget build(BuildContext context) {
    var data = widget.palette?.colors.toList() ?? [];
    for (var i = 0; i < 7; i++) data.add(Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColorPaletteButton(color: data[0]),
            ColorPaletteButton(color: data[1]),
            ColorPaletteButton(color: data[2]),
          ],
        ),
        SizedBox(
          height: SizeConfig.safeBlockVertical * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColorPaletteButton(color: data[3]),
            ColorPaletteButton(color: data[4]),
            ColorPaletteButton(color: data[5]),
          ],
        ),
      ],
    );
  }
}

class ColorPaletteButton extends StatelessWidget {
  const ColorPaletteButton({Key? key, required this.color}) : super(key: key);

  final Color? color;

  String colorToString(Color? c) {
    Color color = c ?? Colors.grey;
    String colorString = color.toString();
    String valueString = colorString.split('(0xff')[1].split(')')[0];
    return "#$valueString";
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.white24),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                SizeConfig.safeBlockHorizontal * kBorderRadius))),
        foregroundColor:
            MaterialStateProperty.all(context.theme.textTheme.headline6!.color),
        backgroundColor: MaterialStateProperty.all(color),
      ),
      onPressed: () {
        print("poo");
        Clipboard.setData(ClipboardData(text: colorToString(color)));
      },
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
        child: Text(
          colorToString(color),
          style: TextStyle(shadows: []),
        ),
      ),
    );
  }
}
