import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/controllers/navigation_controller.dart';
import 'package:wall/screens/basescreen/base_screen.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));

    Get.put(DatabaseController());
    Get.put(NavController());

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurpleAccent.shade400,
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.light,
            accentColor: Colors.deepPurpleAccent.shade400,
            backgroundColor: Color(0xfff6e6ff)),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: Color(0xfff6e6ff),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurpleAccent.shade400,
          splashColor: Colors.white10,
          splashFactory: InkRipple.splashFactory,
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
              brightness: Brightness.dark,
              accentColor: Colors.deepPurpleAccent.shade400,
              backgroundColor: Color(0xff0e0c24)),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          scaffoldBackgroundColor: Color(0xff0e0c24),
          tooltipTheme: TooltipThemeData(
            textStyle: GoogleFonts.inter(
              color: Colors.white
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            )
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color(0xff0e0c24),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
            unselectedLabelStyle:
                GoogleFonts.inter(fontWeight: FontWeight.w500),
            selectedItemColor: Colors.deepPurpleAccent.shade100,
            unselectedItemColor: Colors.white,
          )),
      home: HomePage(),
    );
  }
}
