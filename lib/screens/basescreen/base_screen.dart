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
          appBar: AppBar(
            toolbarHeight: kToolbarHeight + SizeConfig.safeBlockVertical * 1,
            textTheme: Theme.of(context).textTheme,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Wallpapers",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  fontSize: SizeConfig.safeBlockHorizontal * 5.8),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 10; i++)
                      Container(
                        height: 100,
                        color: Colors.deepPurple,
                        margin: EdgeInsets.all(10),
                      )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.6),
                      child: SalomonBottomBar(
                        currentIndex: _currentIndex,
                        onTap: (i) => setState(() => _currentIndex = i),
                        items: [
                          SalomonBottomBarItem(
                            icon: Icon(Icons.home),
                            title: Text("Home"),
                          ),
                          SalomonBottomBarItem(
                            icon: Icon(Icons.favorite_border),
                            title: Text("Likes"),
                          ),
                          SalomonBottomBarItem(
                            icon: Icon(Icons.search),
                            title: Text("Search"),
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
