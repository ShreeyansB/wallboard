import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/screens/collscreen/widgets/collection_grid.dart';

class CollScreen extends StatefulWidget {
  const CollScreen({Key? key}) : super(key: key);

  @override
  _CollScreenState createState() => _CollScreenState();
}

class _CollScreenState extends State<CollScreen> {

  var dbController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        if (dbController.isLoaded.value)
          return CollGrid();
        else
          return Center(child: CircularProgressIndicator());
      });
  }
}
