import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallboard/controllers/about_controller.dart';
import 'package:wallboard/controllers/database_controller.dart';
import 'package:wallboard/controllers/navigation_controller.dart';
import 'package:wallboard/controllers/search_controller.dart';
import 'package:wallboard/dev_settings.dart';
import 'package:wallboard/screens/aboutscreen/about_screen.dart';
import 'package:wallboard/screens/basescreen/widgets/bottom_nav_bar.dart';
import 'package:wallboard/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wallboard/screens/basescreen/widgets/theme_dialog.dart';
import 'package:wallboard/utils/size_config.dart';

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
                        ? lGradientColor
                        : dGradientColor,
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
          resizeToAvoidBottomInset: false,
          appBar: MySearchAppBar(),
          body: PageStorage(
            bucket: bucket,
            child: Obx(
              () => AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                reverseDuration: Duration(milliseconds: 600),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                layoutBuilder: (currentChild, previousChildren) {
                  List<Widget> children = previousChildren;
                  if (currentChild != null)
                    children = children.toList()..add(currentChild);
                  return Stack(
                    children: children,
                    alignment: Alignment.topCenter,
                  );
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

enum MenuOption { theme, about }

class MySearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 60.0;
  final String? title;
  final bool showBackButton;

  const MySearchAppBar({Key? key, this.title, this.showBackButton = false})
      : super(key: key);
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
    Widget titleWidget = Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.safeBlockHorizontal * kGridViewPadding / 4),
        child: Text(
          widget.title ?? kAppName,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontSize: SizeConfig.safeBlockHorizontal * 5.5),
        ));

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
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: widget.showBackButton
          ? IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: context.textTheme.headline6!.color),
              iconSize: SizeConfig.safeBlockHorizontal * 7.4,
            )
          : null,
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
        Tooltip(
          message: "Search",
          child: TextButton(
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
        ),
        PopupMenuButton<MenuOption>(
          iconSize: SizeConfig.safeBlockHorizontal * 8,
          icon: Icon(
            Icons.more_vert_rounded,
            color: context.textTheme.headline6!.color,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockHorizontal * kBorderRadius)),
          onSelected: (value) async {
            if (value == MenuOption.theme) {
              ThemeMode? result = await showDialog(
                context: context,
                builder: (context) => ThemeDialog(),
              );
              if (result != null) {
                Get.changeThemeMode(result);
                Get.find<DatabaseController>().setThemeType(result);
              }
            } else if (value == MenuOption.about) {
              Get.to(() => AboutScreen(
                    about: Get.find<AboutController>().about,
                    groups: Get.find<AboutController>().groups,
                  ));
            } else {
              print("null");
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Theme       "),
                value: MenuOption.theme,
              ),
              PopupMenuItem(
                child: Text("About       "),
                value: MenuOption.about,
              ),
            ];
          },
        ),
      ],
    );
  }
}
