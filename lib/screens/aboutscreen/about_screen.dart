import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallboard/models/about_model.dart';
import 'package:wallboard/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

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
        widgets.add(Divider(
          color: context.textTheme.headline6!.color!.withOpacity(0.07),
          thickness: 1,
        ));
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: context.textTheme.headline6!.copyWith(
                    fontSize: SizeConfig.safeBlockVertical * 1.7,
                    fontWeight: FontWeight.bold,
                    color: context.theme.accentColor),
              ),
              SizedBox(
                height: 25,
              ),
              GroupTile(name: name, about: about[0]),
            ],
          )
        ],
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile({Key? key, required this.name, required this.about})
      : super(key: key);
  final String name;
  final AboutModel about;

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundImage: Image.network(about.photo).image,
            radius: SizeConfig.safeBlockVertical * 3.2,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                about.name,
                style: context.textTheme.headline6!.copyWith(
                    fontSize: SizeConfig.safeBlockVertical * 2,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              if (about.description != null)
                Text(
                  about.description.toString(),
                  maxLines: 3,
                  style: context.textTheme.headline6!.copyWith(
                      fontSize: SizeConfig.safeBlockVertical * 1.5,
                      fontWeight: FontWeight.w500),
                ),
              if (about.buttons != null)
                SizedBox(
                  height: 5,
                ),
              if (about.buttons != null)
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    for (var i = 0; i < about.buttons!.length; i++)
                      TextButton(
                        onPressed: () {
                          _launchInWebViewOrVC(about.links![i].toString());
                        },
                        child: Text(
                          about.buttons![i].toString().toUpperCase(),
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 1.8,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                  ],
                )
            ],
          ),
        )
      ],
    );
  }
}
