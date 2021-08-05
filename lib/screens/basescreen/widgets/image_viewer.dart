import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/models/wallpaper_model.dart';
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_rounded),
          iconSize: 30,
        ),
        title: Hero(
          tag: widget.wall.url,
          child: Text(
            widget.wall.name,
            style: context.textTheme.headline6!.copyWith(fontSize: SizeConfig.safeBlockHorizontal*5, fontWeight: FontWeight.w600,),
          ),
        ),
        elevation: 0,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
      ),
      body: InteractiveViewer(
        transformationController: _transformationController,
        // minScale: 0.1,
        // maxScale: 4.0,
        clipBehavior: Clip.none,
        constrained: false,
        child: GestureDetector(
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
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(),
                child: Center(child: CircularProgressIndicator())),
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
