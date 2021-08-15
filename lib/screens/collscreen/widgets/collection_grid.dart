import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallboard/controllers/database_controller.dart';
import 'package:wallboard/controllers/navigation_controller.dart';
import 'package:wallboard/controllers/search_controller.dart';
import 'package:wallboard/dev_settings.dart';
import 'package:wallboard/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wallboard/screens/basescreen/widgets/no_items.dart';
import 'package:wallboard/screens/collwallscreen/collwall_screen.dart';
import 'package:wallboard/utils/size_config.dart';

class CollGrid extends StatefulWidget {
  const CollGrid({Key? key}) : super(key: key);

  @override
  _CollGridState createState() => _CollGridState();
}

class _CollGridState extends State<CollGrid> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  var dbController = Get.find<DatabaseController>();
  var searchController = Get.find<SearchController>();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

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
                  _controller.value = 0;
                  _controller.forward();
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
                  return FadeTransition(
                    opacity: _animation,
                    child: CachedNetworkImage(
                      maxHeightDiskCache: MediaQuery.of(context).size.height ~/
                          (1.9 * kCollectionTileImageQuality),
                      memCacheHeight: MediaQuery.of(context).size.height ~/
                          (1.9 * kCollectionTileImageQuality),
                      imageUrl: ctrl.dbWallpapers
                              .firstWhere((wall) =>
                                  wall.collection == listCollections[index])
                              .thumbnail ??
                          ctrl.dbWallpapers
                              .firstWhere((wall) =>
                                  wall.collection == listCollections[index])
                              .url,
                      imageBuilder: (context, imageProvider) {
                        return CollImage(
                          imageProvider: imageProvider,
                          collectionName: listCollections[index],
                          ctrl: ctrl,
                        );
                      },
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.safeBlockHorizontal * kBorderRadius,
                            ),
                            color: context.textTheme.headline6!.color!
                                .withOpacity(0.01)),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
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
                    color: context.textTheme.headline1!.color,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline6!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.safeBlockHorizontal * kBannerPadding),
                        child: Row(
                          mainAxisAlignment: kIsCollectionNameCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
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
                                    color: context.textTheme.headline6!.color,
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
                                        color:
                                            context.textTheme.headline6!.color,
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
                        ))!
                    .then((value) =>
                        Get.find<SearchController>().string.value = "");
              },
            ),
          ),
        )
      ],
    );
  }
}
