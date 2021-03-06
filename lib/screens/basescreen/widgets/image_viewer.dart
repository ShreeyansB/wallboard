import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallboard/controllers/palette_controller.dart';
import 'package:wallboard/controllers/slide_controller.dart';
import 'package:wallboard/dev_settings.dart';
import 'package:wallboard/models/wallpaper_model.dart';
import 'package:wallboard/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wallboard/screens/basescreen/widgets/like_button.dart';
import 'package:wallboard/utils/size_config.dart';

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

  var paletteCtrlr = Get.find<PaletteController>();
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
    paletteCtrlr.currentScreenUrl = widget.wall.url;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _animation.value;
      });
    bool isCached = false;
    for (var i = 0; i < paletteCtrlr.cachedColors.length; i++) {
      if (paletteCtrlr.cachedColors[i]["url"] == widget.wall.url) {
        paletteCtrlr.getFromCache(widget.wall);
        isCached = true;
        break;
      }
    }
    if (!isCached) updatePalette();
  }

  void updatePalette() async {
    while (paletteCtrlr.isIsolateComputing == true) {
      await Future.delayed(Duration(milliseconds: 1500));
      print("polling...");
    }
    paletteCtrlr.isIsolateComputing = true;
    paletteCtrlr.getPalette(widget.wall);
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
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: context.textTheme.headline6!.color),
            iconSize: SizeConfig.safeBlockHorizontal * 7.4,
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
                      color: context.textTheme.headline6!.color,
                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none),
                ),
                if (kShowAuthor)
                  Text(
                    "by ${widget.wall.author}",
                    maxLines: 1,
                    style: context.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: context.textTheme.headline5!.color,
                        fontSize: SizeConfig.safeBlockHorizontal * 3),
                  ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: context.textTheme.headline1!.color,
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
            child: Obx(() {
              return AnimatedCrossFade(
                sizeCurve: Curves.easeOutQuad,
                firstCurve: Curves.easeOutCubic,
                secondCurve: Curves.easeOutCubic,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 300),
                crossFadeState: slideController.show.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: MyBottomSheet(wall: widget.wall),
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
    return Obx(
      () {
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
  const MyBottomSheet({Key? key, required this.wall}) : super(key: key);

  final WallpaperModel wall;
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  SlideController slideController = Get.find<SlideController>();

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
        color: context.textTheme.headline1!.color,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: SizeConfig.safeBlockHorizontal * 10,
            right: SizeConfig.safeBlockHorizontal * 10,
            top: SizeConfig.safeBlockVertical * 3,
            bottom: SizeConfig.safeBlockVertical * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.wall.name,
              maxLines: 1,
              style: context.textTheme.headline6!.copyWith(
                color: context.textTheme.headline6!.color,
                fontSize: SizeConfig.safeBlockHorizontal * 7.6,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (kShowAuthor)
              Text(
                "by ${widget.wall.author}",
                style: context.textTheme.headline6!.copyWith(
                  color: context.textTheme.headline5!.color,
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
                            color: context.textTheme.headline5!.color)),
                    TextSpan(
                        text: widget.wall.dimensions,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: context.textTheme.headline6!.color)),
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
                            color: context.textTheme.headline5!.color)),
                    TextSpan(
                        text: widget.wall.size,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: context.textTheme.headline6!.color)),
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
                            color: context.textTheme.headline5!.color)),
                    TextSpan(
                        text: widget.wall.license,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                            color: context.textTheme.headline6!.color)),
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
            Obx(() => AnimatedCrossFade(
                  sizeCurve: Curves.easeInToLinear,
                  firstCurve: Curves.easeOutCubic,
                  secondCurve: Curves.easeOutCubic,
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  crossFadeState: slideController.showInfo.value
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: PaletteGrid(
                    wall: widget.wall,
                  ),
                  secondChild: Container(),
                ))
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
    if (!Platform.isIOS && (wall.downloadable ?? true)) {
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
    if (!Platform.isIOS) {
      var cache = DefaultCacheManager();
      File file = await cache.getSingleFile(wall.url);
      platform.invokeMethod(
          "setWallpaper", {"uri": file.path}).then((value) => print(value));
    } else {
      Get.showSnackbar(GetBar(
        message: "Wallpaper cannot be set on iOS",
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 300),
        icon: Icon(Icons.report_outlined),
      ));
    }
  }

  void togglePalette() {
    Get.find<SlideController>().showInfo.value =
        !Get.find<SlideController>().showInfo.value;
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
        icon: kFavoriteIcon,
        caption: "Favorite",
        widget: LikeButtonBG(
            url: wall.url,
            size: SizeConfig.safeBlockHorizontal * 6,
            duration: 500),
      ),
      SheetButton(
          icon: kSetWallpaperIcon,
          caption: "Set",
          onPressed: () => setWallpaper(wall)),
      SheetButton(
        icon: kInfoIcon,
        caption: "Info",
        onPressed: () => togglePalette(),
      ),
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
                    splashColor: context.theme.splashColor,
                    splashFactory: context.theme.splashFactory,
                    child: Container(
                      decoration: BoxDecoration(
                          color: context.textTheme.headline2!.color,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.safeBlockHorizontal * kBorderRadius)),
                      padding:
                          EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                      child: Text(
                        icon,
                        style: context.theme.textTheme.headline6!.copyWith(
                            fontFamily: "RemixIcons",
                            color: context.textTheme.headline6!.color,
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
              color: context.textTheme.headline6!.color,
              fontSize: SizeConfig.safeBlockHorizontal * 2.7),
        ),
      ],
    );
  }
}

class PaletteGrid extends StatefulWidget {
  const PaletteGrid({Key? key, required this.wall}) : super(key: key);

  final WallpaperModel wall;

  @override
  _PaletteGridState createState() => _PaletteGridState();
}

class _PaletteGridState extends State<PaletteGrid> {
  var paletteCtrlr = Get.find<PaletteController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaletteController>(builder: (ctrlr) {
      var data = ctrlr.colors.toList();
      // for (var i = 0; i < 7; i++) data.add(Colors.white);
      if (data.isNotEmpty)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data.length > 0) ColorPaletteButton(color: data[0]),
                if (data.length > 1) ColorPaletteButton(color: data[1]),
                if (data.length > 2) ColorPaletteButton(color: data[2]),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data.length > 3) ColorPaletteButton(color: data[3]),
                if (data.length > 4) ColorPaletteButton(color: data[4]),
                if (data.length > 5) ColorPaletteButton(color: data[5]),
              ],
            ),
          ],
        );
      else
        return LinearProgressIndicator(
          backgroundColor: Colors.transparent,
        );
    });
  }
}

class ColorPaletteButton extends StatelessWidget {
  ColorPaletteButton({Key? key, required this.color}) : super(key: key);

  final Color color;

  String colorToString(Color? c) {
    Color color = c ?? Colors.grey;
    String colorString = color.toString();
    String valueString = colorString.split('(0xff')[1].split(')')[0];
    return "#${valueString.toUpperCase()}";
  }

  Color getTextColor(Color color) {
    double darkness =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue);
    if (darkness > 160)
      return Colors.black87;
    else
      return Colors.white70;
  }

  final GlobalKey _toolTipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _toolTipKey,
      message: "Copied to clipboard",
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.white24),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockHorizontal * kBorderRadius))),
          foregroundColor: MaterialStateProperty.all(
              context.theme.textTheme.headline6!.color),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: () {
          final dynamic _toolTip = _toolTipKey.currentState;
          _toolTip.ensureTooltipVisible();
          Timer(Duration(milliseconds: 2000), () => _toolTip?.deactivate());
          Clipboard.setData(ClipboardData(text: colorToString(color)));
        },
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
          child: Text(
            colorToString(color),
            style: TextStyle(
                color: getTextColor(color), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
