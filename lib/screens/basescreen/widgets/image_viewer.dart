import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/slide_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/models/wallpaper_model.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/utils/size_config.dart';

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
                firstChild: MyBottomSheet(
                  wall: widget.wall,
                ),
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
                filter: ImageFilter.blur(
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
  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: kBlurAmount != 0,
      conditionalBuilder: (child) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
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
            SheetButtonGrid(),
          ],
        ),
      ),
    );
  }
}

class SheetButtonGrid extends StatelessWidget {
  SheetButtonGrid({Key? key}) : super(key: key);

  final List<Widget> widgets = [
    SheetButton(icon: kDownloadIcon, caption: "Download"),
    SheetButton(icon: kFavoriteIcon, caption: "Favorite"),
    SheetButton(icon: kSetWallpaperIcon, caption: "Set"),
    SheetButton(icon: kInfoIcon, caption: "Info"),
  ];

  @override
  Widget build(BuildContext context) {
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
            child: InkWell(
              onTap: onPressed ?? () => print("Boo"),
              splashFactory: context.theme.splashFactory,
              child: Container(
                decoration: BoxDecoration(
                    color: kBannerTitleColor.withOpacity(0.27),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.safeBlockHorizontal * kBorderRadius)),
                padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                child: Text(
                  icon,
                  style: context.theme.textTheme.headline6!.copyWith(
                      fontFamily: "RemixIcons",
                      color: kBannerTitleColor,
                      fontSize: SizeConfig.safeBlockHorizontal * 6),
                ),
              ),
            ),
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
