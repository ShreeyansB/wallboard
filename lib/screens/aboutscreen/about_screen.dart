import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/about_controller.dart';
import 'package:wall/utils/size_config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key, required this.about, required this.groups})
      : super(key: key);
  final List<AboutModel> about;
  final List<String> groups;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var i = 0; i < groups.length; i++) {
      widgets.add(GroupList(
          name: groups[i],
          about: about.where((a) => a.group == groups[i]).toList()));
      if (i != groups.length - 1) {
        widgets.add(Divider());
      }
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + SizeConfig.safeBlockVertical * 1,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: context.textTheme.headline6!.color),
          iconSize: SizeConfig.safeBlockHorizontal * 7.4,
        ),
        title: Text(
          "About",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontSize: SizeConfig.safeBlockHorizontal * 5.5),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class GroupList extends StatelessWidget {
  const GroupList({Key? key, required this.name, required this.about})
      : super(key: key);
  final String name;
  final List<AboutModel> about;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: context.textTheme.headline6!.copyWith(
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              color: context.theme.accentColor),
        )
      ],
    );
  }
}
