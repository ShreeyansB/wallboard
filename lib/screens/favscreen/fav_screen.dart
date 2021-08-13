import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallboard/controllers/database_controller.dart';
import 'package:wallboard/screens/favscreen/widgets/favorites_grid.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  var dbController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dbController.isLoaded.value)
        return FavGrid();
      else
        return Center(child: CircularProgressIndicator());
    });
  }
}
