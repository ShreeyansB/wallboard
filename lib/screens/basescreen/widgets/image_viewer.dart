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
            child: Text(
              widget.wall.name,
              style: context.textTheme.headline6!.copyWith(
                  color: kBannerTitleColor,
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none),
            ),
          ),
          elevation: 0,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
        ),
      ),
      body: InteractiveViewer(
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
    );
  }
}

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 70.0;
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
        return AnimatedOpacity(
          curve: Curves.easeOutCubic,
          duration: Duration(milliseconds: 300),
          opacity: slideController.show.value ? 1 : 0,
          child: ConditionalParentWidget(
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
        );
      },
    );
  }
}
