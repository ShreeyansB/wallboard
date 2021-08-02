import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/utils/size_config.dart';

class WallGrid extends StatefulWidget {
  const WallGrid({Key? key}) : super(key: key);

  @override
  _WallGridState createState() => _WallGridState();
}

class _WallGridState extends State<WallGrid> {
  double kBorderRadius = 4;
  double kBlurAmount = 0;

  double kGridViewPadding = 5;
  double kGridSpacing = 4.3;
  double kGridAspectRatio = 0.7;
  int kGridCount = 2;

  double kBannerHeight = 8;
  Color kBannerColor = Colors.black26;
  Color kBannerTitleColor = Colors.white;
  Color kBannerAuthorColor = Colors.white60;
  double kBannerTitleSize = 3.2;
  double kBannerAuthorSize = 2.5;
  double kBannerPadding = 3.2;

  bool kShowAuthor = true;
  String kNullAuthorName = "Unnamed";

  ScrollController _scrollController = ScrollController();
  var dbController = Get.find<DatabaseController>();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        dbController.addWalls();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatabaseController>(builder: (ctrl) {
      return Scrollbar(
        controller: _scrollController,
        interactive: true,
        thickness: SizeConfig.safeBlockHorizontal * 2,
        radius: Radius.circular(SizeConfig.safeBlockHorizontal * 4),
        child: GridView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: ctrl.wallpapers.length,
          shrinkWrap: true,
          padding:
              EdgeInsets.all(SizeConfig.safeBlockHorizontal * kGridViewPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: kGridAspectRatio,
              crossAxisCount: 2,
              crossAxisSpacing: SizeConfig.safeBlockHorizontal * kGridSpacing,
              mainAxisSpacing: SizeConfig.safeBlockHorizontal * kGridSpacing),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                // String path =
                //     await _findPath(ctrl.wallpapers[index].url);
                // platform.invokeMethod("setWallpaper", {"uri": path});
              },
              child: CachedNetworkImage(
                imageUrl: ctrl.wallpapers[index].url,
                imageBuilder: (context, imageProvider) {
                  return WallImage(
                    imageProvider: imageProvider,
                    index: index,
                    ctrl: ctrl,
                    kBorderRadius: kBorderRadius,
                    kBannerHeight: kBannerHeight,
                    kBlurAmount: kBlurAmount,
                    kBannerColor: kBannerColor,
                    kBannerPadding: kBannerPadding,
                    kBannerTitleColor: kBannerTitleColor,
                    kBannerTitleSize: kBannerTitleSize,
                    kShowAuthor: kShowAuthor,
                    kNullAuthorName: kNullAuthorName,
                    kBannerAuthorColor: kBannerAuthorColor,
                    kBannerAuthorSize: kBannerAuthorSize,
                  );
                },
                placeholder: (context, url) => Center(
                    child: Container(
                  height: SizeConfig.safeBlockHorizontal * 8,
                  width: SizeConfig.safeBlockHorizontal * 8,
                  child: CircularProgressIndicator(),
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          },
        ),
      );
    });
  }
}

class WallImage extends StatefulWidget {
  const WallImage({
    Key? key,
    required this.kBorderRadius,
    required this.kBannerHeight,
    required this.kBlurAmount,
    required this.kBannerColor,
    required this.kBannerPadding,
    required this.kBannerTitleColor,
    required this.kBannerTitleSize,
    required this.kShowAuthor,
    required this.kNullAuthorName,
    required this.kBannerAuthorColor,
    required this.kBannerAuthorSize,
    required this.imageProvider,
    required this.ctrl,
    required this.index,
  }) : super(key: key);

  final double kBorderRadius;
  final double kBannerHeight;
  final double kBlurAmount;
  final Color kBannerColor;
  final double kBannerPadding;
  final Color kBannerTitleColor;
  final double kBannerTitleSize;
  final bool kShowAuthor;
  final String kNullAuthorName;
  final Color kBannerAuthorColor;
  final double kBannerAuthorSize;
  final ImageProvider imageProvider;
  final DatabaseController ctrl;
  final int index;

  @override
  _WallImageState createState() => _WallImageState();
}

class _WallImageState extends State<WallImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockHorizontal * widget.kBorderRadius),
          child: Container(
            decoration: BoxDecoration(),
            child: Image(
              filterQuality: FilterQuality.low,
              image: widget.imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: SizeConfig.safeBlockVertical * widget.kBannerHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        SizeConfig.safeBlockHorizontal * widget.kBorderRadius),
                    bottomRight: Radius.circular(
                        SizeConfig.safeBlockHorizontal * widget.kBorderRadius)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: widget.kBlurAmount, sigmaY: widget.kBlurAmount),
                  child: Container(
                    color: widget.kBannerColor,
                    child: DefaultTextStyle(
                      style: GoogleFonts.inter(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal *
                            widget.kBannerPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    widget.ctrl.wallpapers[widget.index].name,
                                    style: TextStyle(
                                        color: widget.kBannerTitleColor,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                widget.kBannerTitleSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (widget.kShowAuthor)
                                    Text(
                                      "by ${widget.ctrl.wallpapers[widget.index].author ?? widget.kNullAuthorName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: widget.kBannerAuthorColor,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  widget.kBannerAuthorSize),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.favorite_border_rounded,
                                size: SizeConfig.safeBlockHorizontal * 7,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
