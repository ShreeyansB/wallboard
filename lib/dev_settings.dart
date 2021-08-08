import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// BASE SETTINGS

const bool kIsBgGradient = false;
const Color kGradientColorLight = Colors.black26;
const Color kGradientColorDark = Colors.white54;

const Color kBgColorLight = Color(0xfff6e6ff);
const Color kBgColorDark = Color(0xff0B0A1F);

const Color kAppbarColorLight = Color(0xfff6e6ff);
const Color kAppbarColorDark = Color(0xff0B0A1F);

const Color kBottombarColorLight = Color(0xfff6e6ff);
const Color kBottombarColorDark = Color(0xff0B0A1F);

var kBaseTextTheme = GoogleFonts.robotoMonoTextTheme;
var kBaseTextStyle = GoogleFonts.robotoMono;
Color kLikeButtonColor = Colors.red.shade600;

// WALLPAPER SCREEN SETTINGS

// Wallpaper Tile Settings
const double kBorderRadius = 2;
const double kBlurAmount = 0;

const double kGridViewPadding = 3;
const double kGridSpacing = 3;
const double kGridAspectRatio = 0.7;
const int kGridCount = 2;

const double kBannerHeight = 8;
const double kBorderRadiusTop = 0;
const double kBorderRadiusBottom = 2;
const Alignment kBannerAlignment = Alignment.bottomCenter;
const Color kBannerColor = Colors.black38;
const Color kBannerTitleColor = Colors.white;
const Color kBannerAuthorColor = Colors.white60;
const double kBannerTitleSize = 3.2;
const double kBannerAuthorSize = 2.5;
const double kBannerPadding = 3.2;

const bool kShowAuthor = true;
const String kNullAuthorName = "Unnamed";

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
