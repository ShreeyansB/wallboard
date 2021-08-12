import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/controllers/search_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/screens/basescreen/widgets/no_items.dart';
import 'package:wall/screens/collwallscreen/collwall_screen.dart';
import 'package:wall/utils/size_config.dart';

class CollGrid extends StatefulWidget {
  const CollGrid({Key? key}) : super(key: key);

  @override
  _CollGridState createState() => _CollGridState();
}

class _CollGridState extends State<CollGrid> {
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
    return GetBuilder<DatabaseController>(
      builder: (ctrl) {
        var listCollections = ctrl.collections;
        return Scrollbar(
            controller: _scrollController,
            interactive: true,
            thickness: SizeConfig.safeBlockHorizontal * 2,
            radius: Radius.circular(SizeConfig.safeBlockHorizontal * 4),
            child: Obx(() {
              if (Get.find<NavController>().navIndex.value == 1) {
                if (searchController.string.value != "") {
                  listCollections = [];
                }
                if (searchController.string.value != "") {
                  ctrl.collections.forEach((coll) {
                    if (coll
                        .toLowerCase()
                        .contains(searchController.string.value.toLowerCase()))
                      listCollections.add(coll);
                  });
                }

                if (searchController.string.value == "") {
                  listCollections = ctrl.collections;
                }
                if (listCollections.isEmpty) {
                  return NoItems();
                }
              }
              return GridView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemCount: listCollections.length,
                shrinkWrap: true,
                cacheExtent: MediaQuery.of(context).size.height * 3,
                padding: EdgeInsets.all(
                    SizeConfig.safeBlockHorizontal * kGridViewPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: kCollectionGridAspectRatio,
                    crossAxisCount: kCollectionGridCount,
                    crossAxisSpacing:
                        SizeConfig.safeBlockHorizontal * kGridSpacing,
                    mainAxisSpacing:
                        SizeConfig.safeBlockHorizontal * kGridSpacing),
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    maxHeightDiskCache: MediaQuery.of(context).size.height ~/
                        (1.9 * kCollectionTileImageQuality),
                    memCacheHeight: MediaQuery.of(context).size.height ~/
                        (1.9 * kCollectionTileImageQuality),
                    imageUrl: ctrl.dbWallpapers
                        .firstWhere(
                            (wall) => wall.collection == listCollections[index])
                        .url,
                    imageBuilder: (context, imageProvider) {
                      return CollImage(
                        imageProvider: imageProvider,
                        collectionName: listCollections[index],
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
            }));
      },
    );
  }
}

class CollImage extends StatelessWidget {
  const CollImage(
      {Key? key,
      required this.imageProvider,
      required this.ctrl,
      required this.collectionName})
      : super(key: key);

  final ImageProvider imageProvider;
  final DatabaseController ctrl;
  final String collectionName;

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
                        sigmaX: kBlurAmount,
                        sigmaY: kBlurAmount,
                        tileMode: TileMode.decal),
                    child: child,
                  ),
                  child: Container(
                    color: kBannerColor,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline6!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.safeBlockHorizontal * kBannerPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConditionalParentWidget(
                              condition: kShowCollectionCount,
                              conditionalBuilder: (child) =>
                                  Expanded(flex: 11, child: child),
                              child: Text(
                                kIsTextUppercase
                                    ? collectionName.toUpperCase()
                                    : collectionName,
                                style: TextStyle(
                                    color: kBannerTitleColor,
                                    fontSize: SizeConfig.safeBlockHorizontal *
                                        kBannerFontSize,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            if (kShowCollectionCount)
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    ctrl.dbWallpapers
                                        .where((wall) =>
                                            wall.collection == collectionName)
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        color: kBannerTitleColor,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                kBannerFontSize,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashFactory: Theme.of(context).splashFactory,
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockHorizontal * kBorderRadius),
              onTap: () async {
                Get.to(() => CollWallScreen(
                      collectionName: collectionName,
                    ));
              },
            ),
          ),
        )
      ],
    );
  }
}
