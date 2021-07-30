import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wall/utils/size_config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.overlay,
            gradient: RadialGradient(
              colors: [Colors.white, Colors.transparent],
              center: Alignment.bottomRight,
              radius: SizeConfig.safeBlockVertical * 0.75,
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    toolbarHeight:
                        kToolbarHeight + SizeConfig.safeBlockVertical * 1.4,
                    textTheme: Theme.of(context).textTheme,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      "Wallpapers",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, letterSpacing: 0.8),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        height: 150,
                        color: Colors.deepPurple,
                        margin: EdgeInsets.all(20),
                      ),
                      childCount: 10,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 12),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      color: Colors.black54,
                      child: SalomonBottomBar(
                        currentIndex: _currentIndex,
                        onTap: (i) => setState(() => _currentIndex = i),
                        items: [
                          SalomonBottomBarItem(
                            icon: Icon(Icons.home),
                            title: Text("Home"),
                            selectedColor: Colors.deepPurpleAccent.shade400,
                          ),
                          SalomonBottomBarItem(
                            icon: Icon(Icons.favorite_border),
                            title: Text("Likes"),
                            selectedColor: Colors.deepPurpleAccent.shade400,
                          ),
                          SalomonBottomBarItem(
                            icon: Icon(Icons.search),
                            title: Text("Search"),
                            selectedColor: Colors.deepPurpleAccent.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
