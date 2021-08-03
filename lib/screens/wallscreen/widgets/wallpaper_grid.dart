import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/utils/size_config.dart';

class WallGrid extends StatefulWidget {
  const WallGrid({Key? key}) : super(key: key);

  @override
  _WallGridState createState() => _WallGridState();
}

class _WallGridState extends State<WallGrid> {
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
              crossAxisCount: kGridCount,
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
                maxHeightDiskCache: MediaQuery.of(context).size.height ~/ 2.1,
                imageUrl: ctrl.wallpapers[index].url,
                imageBuilder: (context, imageProvider) {
                  return WallImage(
                    imageProvider: imageProvider,
                    index: index,
                    ctrl: ctrl,
                    kBorderRadius: kBorderRadius,
                    kBorderRadiusTop: kBorderRadiusTop,
                    kBorderRadiusBottom: kBorderRadiusBottom,
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
                    kBannerAlignment: kBannerAlignment,
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

class WallImage extends StatelessWidget {
  const WallImage({
    Key? key,
    required this.kBorderRadius,
    required this.kBorderRadiusTop,
    required this.kBorderRadiusBottom,
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
    required this.kBannerAlignment,
    required this.imageProvider,
    required this.ctrl,
    required this.index,
  }) : super(key: key);

  final double kBorderRadius;
  final double kBorderRadiusTop;
  final double kBorderRadiusBottom;
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
  final Alignment kBannerAlignment;
  final ImageProvider imageProvider;
  final DatabaseController ctrl;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockHorizontal * kBorderRadius),
          child: Container(
            decoration: BoxDecoration(),
            child: Image(
              filterQuality: FilterQuality.low,
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
            alignment: kBannerAlignment,
            child: Container(
              height: SizeConfig.safeBlockVertical * kBannerHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        SizeConfig.safeBlockHorizontal * kBorderRadiusTop),
                    topRight: Radius.circular(
                        SizeConfig.safeBlockHorizontal * kBorderRadiusTop),
                    bottomLeft: Radius.circular(
                        SizeConfig.safeBlockHorizontal * kBorderRadiusBottom),
                    bottomRight: Radius.circular(
                        SizeConfig.safeBlockHorizontal * kBorderRadiusBottom)),
                child: ConditionalParentWidget(
                  condition: kBlurAmount != 0,
                  conditionalBuilder: (child) => BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: kBlurAmount, sigmaY: kBlurAmount),
                    child: child,
                  ),
                  child: Container(
                    color: kBannerColor,
                    child: DefaultTextStyle(
                      style: GoogleFonts.inter(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.safeBlockHorizontal * kBannerPadding),
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
                                    ctrl.wallpapers[index].name,
                                    style: TextStyle(
                                        color: kBannerTitleColor,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                kBannerTitleSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (kShowAuthor)
                                    Text(
                                      "by ${ctrl.wallpapers[index].author ?? kNullAuthorName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: kBannerAuthorColor,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  kBannerAuthorSize),
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