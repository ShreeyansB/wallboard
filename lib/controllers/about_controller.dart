import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wallboard/models/about_model.dart';

class AboutController extends GetxController {
  List<AboutModel> about = [];
  List<String> groups = [];
  static const Map<String, dynamic> myInfo = {
    "group": "Dashboard",
    "photo": "https://avatars.githubusercontent.com/u/37953798",
    "name": "Shreeyans Bahadkar",
    "description": "UI/UX Designer and Full Stack Flutter Developer.",
    "buttons": ["Github", "LinkedIn", "Telegram"],
    "links": [
      "https://github.com/ShreeyansB",
      "https://in.linkedin.com/in/shreeyans-bahadkar-2b9946217",
      "https://t.me/ballisticswami"
    ]
  };

  @override
  void onInit() async {
    super.onInit();
    List<dynamic> data =
        jsonDecode(await rootBundle.loadString("assets/credits.json"));
    data.add(myInfo);
    data.forEach((map) => about.add(AboutModel.fromJson(map)));
    about.forEach((obj) {
      if (!groups.contains(obj.group)) groups.add(obj.group);
    });
    groups.remove("Dashboard");
    groups.add("Dashboard");
  }
}
