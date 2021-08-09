import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/controllers/search_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/screens/basescreen/widgets/bottom_nav_bar.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/utils/size_config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var navController = Get.find<NavController>();
  final PageStorageBucket bucket = PageStorageBucket();

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ConditionalParentWidget(
        condition: kIsBgGradient,
        conditionalBuilder: (child) {
          return Container(
            decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.softLight,
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).brightness == Brightness.light
                        ? kGradientColorLight
                        : kGradientColorDark,
                    Colors.transparent
                  ],
                  center: Alignment.bottomRight,
                  radius: SizeConfig.safeBlockVertical * 0.4,
                )),
            child: child,
          );
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MySearchAppBar(),
          body: PageStorage(
            bucket: bucket,
            child: Obx(
              () => AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                reverseDuration: Duration(milliseconds: 400),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: navController.screens[navController.navIndex.value],
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavBar(),
        ),
      ),
    );
  }
}

class MySearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 60.0;

  const MySearchAppBar({Key? key}) : super(key: key);
  @override
  _MySearchAppBarState createState() => _MySearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _MySearchAppBarState extends State<MySearchAppBar>
    with SingleTickerProviderStateMixin {
  TextEditingController textCtrlr = TextEditingController();
  var navController = Get.find<NavController>();
  var searchController = Get.find<SearchController>();

  RxBool showSearch = RxBool(false);

  Widget titleWidget = Text(
    "Wallpapers",
    style: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        fontSize: SizeConfig.safeBlockHorizontal * 5.8),
  );

  @override
  void initState() {
    super.initState();
    textCtrlr.addListener(() {
      searchController.string.value = textCtrlr.text;
    });
  }

  @override
  void dispose() {
    textCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget searchIcon = Text(
      kSearchIcon,
      style: TextStyle(
        fontFamily: "RemixIcons",
        color: context.theme.textTheme.headline6!.color,
        fontSize: SizeConfig.safeBlockHorizontal * 7,
      ),
    );

    Widget closeIcon = Icon(
      Icons.close,
      color: context.theme.textTheme.headline6!.color,
      size: SizeConfig.safeBlockHorizontal * 7,
    );

    return AppBar(
      toolbarHeight: kToolbarHeight + SizeConfig.safeBlockVertical * 1,
      textTheme: Theme.of(context).textTheme,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Obx(() {
        if (showSearch.value) {
          return Obx(() => TextField(
                controller: textCtrlr,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  hintText:
                      "Search ${navController.pageNames[navController.navIndex.value]}",
                  border: InputBorder.none,
                ),
                style: context.textTheme.headline6,
                cursorHeight: SizeConfig.safeBlockVertical * 3.5,
                cursorWidth: SizeConfig.safeBlockHorizontal * 0.7,
                cursorColor: context.theme.accentColor,
              ));
        } else {
          return titleWidget;
        }
      }),
      actions: [
        TextButton(
          onPressed: () {
            showSearch.value = !showSearch.value;
            textCtrlr.text = "";
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
          ),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1),
            child: Obx(() {
              if (showSearch.value) {
                return closeIcon;
              } else {
                return searchIcon;
              }
            }),
          ),
        ),
        PopupMenuButton(
          iconSize: SizeConfig.safeBlockHorizontal*8,
          color: context.theme.textTheme.headline6!.color,
          itemBuilder: (context) {
            return [
              PopupMenuItem(child: Text("Settings")),
              PopupMenuItem(child: Text("About")),
            ];
          },
        ),
      ],
    );
  }
}
