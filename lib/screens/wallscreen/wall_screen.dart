import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/screens/wallscreen/widgets/wallpaper_grid.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({Key? key}) : super(key: key);

  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  var dbController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      color: Theme.of(context).accentColor,
      onRefresh: dbController.initWalls,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Obx(() {
        if (dbController.isLoaded.value)
          return WallGrid();
        else
          return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
