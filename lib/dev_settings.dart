import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// BASE SETTINGS

const String kAppName = "Wallpapers";

// THEME SETTINGS - Common

const bool kIsBgGradient = false;

var kBaseTextTheme = GoogleFonts.robotoMonoTextTheme;
var kBaseTextStyle = GoogleFonts.robotoMono;
Color kLikeButtonColor = Colors.red.shade600;

// THEME SETTINGS - Dark

MaterialColor dPrimarySwatch = Colors.deepPurple;
Color dAccentColor = Colors.deepPurpleAccent.shade100;
Color dSplashColor = Colors.white10;

Color dGradientColor = Colors.white54;

Color dBgColor = Color(0xff0e0d1f);
Color dBgColorAlt = Color(0xff19173b);

Color dAppbarColor = Color(0xff0e0d1f);
Color dBottombarColor = Color(0xff0e0d1f);

Color dBannerColor = Colors.black38;
Color dBannerTitleColor = Colors.white;
Color dBannerAuthorColor = Colors.white60;

Color dButtonBgColor = Colors.white30;

// THEME SETTINGS - Light

MaterialColor lPrimarySwatch = Colors.deepPurple;
Color lAccentColor = Colors.deepPurpleAccent;
Color lSplashColor = Colors.black12;

Color lGradientColor = Colors.black26;

Color lBgColor = Color(0xfffbf5ff);
Color lBgColorAlt = Color(0xfff8edff);

Color lAppbarColor = Color(0xfffbf5ff);
Color lBottombarColor = Color(0xfffbf5ff);

Color lBannerColor = Colors.white54;
Color lBannerTitleColor = Colors.black;
Color lBannerAuthorColor = Colors.black87;

Color lButtonBgColor = Colors.black26;

// DATABASE SETTINGS

const String kAuthorNameIfNull = "Anon";
const String kCollectionNameIfNull = "Others";

// WALLPAPER SCREEN SETTINGS

const double kBorderRadius = 4;
const double kBlurAmount = 12;

const double kGridViewPadding = 5;
const double kGridSpacing = 5;
const double kGridAspectRatio = 0.65;
const int kGridCount = 2;

const double kBannerHeight = 8;
const double kBorderRadiusTop = 0;
const double kBorderRadiusBottom = 4;
const Alignment kBannerAlignment = Alignment.bottomCenter;
const double kBannerTitleSize = 3.2;
const double kBannerAuthorSize = 2.5;
const double kBannerPadding = 3.2;

const bool kShowAuthor = true;

const bool kIsTitleUppercase = false;
const bool kIsAuthorUppercase = false;

const double kWallpaperTileImageQuality = 2;

// COLLECTION SCREEN SETTINGS

const double kBannerFontSize = 4;
const bool kShowCollectionCount = true;
const bool kIsTextUppercase = true;

const int kCollectionGridCount = 1;
const double kCollectionGridAspectRatio = 1.4;

const double kCollectionTileImageQuality = 1;

// ICON FONTS
const String kWallpapersNavIcon = "\uEC14";
const String kCollectionsNavIcon = "\uED58";
const String kFavoritesNavIcon = "\uEE09";
const String kFavoriteIcon = "\uEE0E";
const String kNonFavoriteIcon = "\uEE0F";
const String kNoFavoritesBGIcon = "\uEC3C";
const String kSetWallpaperIcon = "\uEE4B";
const String kDownloadIcon = "\uEC54";
const String kInfoIcon = "\uEE59";
const String kSearchIcon = "\uF0CD";
