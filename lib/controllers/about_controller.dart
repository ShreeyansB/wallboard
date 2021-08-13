import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AboutController extends GetxController {
  List<AboutModel> about = [];
  List<String> groups = [];
  static const Map<String, dynamic> myInfo = {
    "group": "Dashboard",
    "photo": "https://avatars.githubusercontent.com/u/37953798",
    "name": "Shreeyans Bahadkar",
    "description": "UI/UX Designer and Full Stack Flutter Developer",
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

class AboutModel {
  String group;
  String photo;
  String name;
  String? description;
  List<String?>? buttons;
  List<String?>? links;

  AboutModel({
    required this.group,
    required this.photo,
    required this.name,
    this.description,
    this.buttons,
    this.links,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    var tGroup = json["group"] ?? "Credits";
    var tPhoto = json["photo"] ??
        "https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png";
    var tName = json["name"] ?? "Developer";
    var tDescription = json["description"]?.toString();
    var tButtons = json["buttons"];
    var tLinks = json["links"];
    tButtons = List<String>.from(tButtons);
    tLinks = List<String>.from(tLinks);

    return AboutModel(
        group: tGroup,
        photo: tPhoto,
        name: tName,
        description: tDescription,
        buttons: tButtons,
        links: tLinks);
  }
}
