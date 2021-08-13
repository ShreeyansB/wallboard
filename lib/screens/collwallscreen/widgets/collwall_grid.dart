import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/controllers/palette_controller.dart';
import 'package:wall/controllers/search_controller.dart';
import 'package:wall/controllers/slide_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/screens/basescreen/widgets/image_viewer.dart';
import 'package:wall/screens/basescreen/widgets/like_button.dart';
import 'package:wall/utils/size_config.dart';

class CollWallGrid extends StatefulWidget {
  const CollWallGrid({Key? key, required this.collectionName})
      : super(key: key);
  final String collectionName;

  @override
  _CollWallGridState createState() => _CollWallGridState();
}

class _CollWallGridState extends State<CollWallGrid> {
  ScrollController _scrollController = ScrollController();
  var dbController = Get.find<DatabaseController>();
  var searchController = Get.find<SearchController>();

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
        child: Obx(() {
          if (searchController.string.value != "") {
            dbController.wallpapers = [];
          }
          if (searchController.string.value != "") {
            dbController.dbWallpapers.forEach((wall) {
              if (wall.collection == widget.collectionName &&
                      wall.name.toLowerCase().contains(
                          searchController.string.value.toLowerCase()) ||
                  (wall.author
                      .toLowerCase()
                      .contains(searchController.string.value.toLowerCase()))) {
                dbController.wallpapers.add(wall);
              }
            });
          }

          if (searchController.string.value == "") {
            dbController.wallpapers = dbController.dbWallpapers
                .where((wall) => wall.collection == widget.collectionName)
                .toList();
          }

          return GridView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemCount: ctrl.wallpapers.length,
            shrinkWrap: true,
            cacheExtent: MediaQuery.of(context).size.height * 3,
            padding: EdgeInsets.all(
                SizeConfig.safeBlockHorizontal * kGridViewPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: kGridAspectRatio,
                crossAxisCount: kGridCount,
                crossAxisSpacing: SizeConfig.safeBlockHorizontal * kGridSpacing,
                mainAxisSpacing: SizeConfig.safeBlockHorizontal * kGridSpacing),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                maxHeightDiskCache: MediaQuery.of(context).size.height ~/
                    (1.7 * kWallpaperTileImageQuality),
                memCacheHeight: MediaQuery.of(context).size.height ~/
                    (1.7 * kWallpaperTileImageQuality),
                imageUrl: ctrl.wallpapers[index].url,
                imageBuilder: (context, imageProvider) {
                  return CollWallImage(
                    imageProvider: imageProvider,
                    index: index,
                    ctrl: ctrl,
                  );
                },
                placeholder: (context, url) => Center(
                    child: Container(
                  height: SizeConfig.safeBlockHorizontal * 8,
                  width: SizeConfig.safeBlockHorizontal * 8,
                  child: CircularProgressIndicator(),
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
          );
        }),
      );
    });
  }
}

class CollWallImage extends StatelessWidget {
  const CollWallImage({
    Key? key,
    required this.imageProvider,
    required this.ctrl,
    required this.index,
  }) : super(key: key);

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
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashFactory: Theme.of(context).splashFactory,
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockHorizontal * kBorderRadius),
              onTap: () async {
                Get.to(() => ImageViewer(wall: ctrl.wallpapers[index]))!
                    .then((value) {
                  Get.find<DatabaseController>().update(["like"]);
                  Get.find<PaletteController>().colors = [];
                  Get.find<PaletteController>().currentScreenUrl = null;
                  Get.find<SlideController>().showInfo.value = false;
                });
              },
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
                        sigmaX: kBlurAmount,
                        sigmaY: kBlurAmount,
                        tileMode: TileMode.decal),
                    child: child,
                  ),
                  child: Container(
                    color: context.textTheme.headline1!.color,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline6!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.safeBlockHorizontal * kBannerPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 11,
                              child: Hero(
                                tag: ctrl.wallpapers[index].url,
                                flightShuttleBuilder: (flightContext,
                                        animation,
                                        flightDirection,
                                        fromHeroContext,
                                        toHeroContext) =>
                                    DefaultTextStyle(
                                        style: kBaseTextStyle().copyWith(),
                                        maxLines: 1,
                                        child: toHeroContext.widget),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      kIsTitleUppercase
                                          ? ctrl.wallpapers[index].name
                                              .toUpperCase()
                                          : ctrl.wallpapers[index].name,
                                      style: TextStyle(
                                          color: context.textTheme.headline6!.color,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  kBannerTitleSize,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.none),
                                    ),
                                    if (kShowAuthor)
                                      Text(
                                        kIsAuthorUppercase
                                            ? "by ${ctrl.wallpapers[index].author}"
                                                .toUpperCase()
                                            : "by ${ctrl.wallpapers[index].author}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: context.textTheme.headline5!.color,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    kBannerAuthorSize),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: LikeButton(
                                    url: ctrl.wallpapers[index].url,
                                    size: kGridCount < 3
                                        ? SizeConfig.safeBlockVertical * 3.4
                                        : SizeConfig.safeBlockVertical * 2,
                                    duration: 500),
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
