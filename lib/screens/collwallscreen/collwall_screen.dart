import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/screens/basescreen/base_screen.dart';
import 'package:wall/screens/basescreen/widgets/conditional_parent.dart';
import 'package:wall/screens/collwallscreen/widgets/collwall_grid.dart';
import 'package:wall/utils/size_config.dart';

class CollWallScreen extends StatefulWidget {
  const CollWallScreen({Key? key, required this.collectionName})
      : super(key: key);

  final String collectionName;

  @override
  _CollWallScreenState createState() => _CollWallScreenState();
}

class _CollWallScreenState extends State<CollWallScreen> {
  var dbController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
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
            appBar: MySearchAppBar(title: widget.collectionName, showBackButton: true,),
            body: CollWallGrid(collectionName: widget.collectionName)),
      ),
    );
  }
}
