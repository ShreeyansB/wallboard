import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// BASE SETTINGS

const String kDatabaseURL = "https://api.jsonbin.io/b/61052fea046287097ea3f7c6/latest"; // URL Where the wallpaper database is stored.
const String kAppName = "Wallboard"; // This is the name which appears as the AppBar Title.
const String? kOneSignalApiKey = null; // Replace null with your OneSignal API Key in quotation marks.

// THEME SETTINGS - Common

const bool kIsBgGradient = false; // If you want the background to be a gradient (impacts app performance).

var kBaseTextTheme = GoogleFonts.robotoMonoTextTheme; // Set the text theme for the app. Choose any font from Google Fonts. Both theme and style must belong to the same font. Use ctrl + space to see suggested fonts,
var kBaseTextStyle = GoogleFonts.robotoMono; // Same font as above but should not contain TextTheme in the property.

Color kLikeButtonColor = Colors.red.shade600; // Set the color for the like/favorite button when wallpaper is liked.

// THEME SETTINGS - Dark

MaterialColor dPrimarySwatch = Colors.deepPurple; // This is used to set the base primary color for the app. Data Type should only be predefined MaterialColor
Color dAccentColor = Colors.deepPurpleAccent.shade100;  // This color is used for widgets like TextButtons, Progress Indicators, etc. Should be similar to primary swatch
Color dSplashColor = Colors.white10; // Set the color of the splash. Splash color is the color of the ripple effect seen when long pressing buttons, etc.

Color dGradientColor = Colors.white54; // Set the 2nd color of the gradient if kIsBgGradient is true. BlendMode is SoftLight.

Color dBgColor = Color(0xff0e0d1f); // Set the background color of the App..
Color dBgColorAlt = Color(0xff19173b); // An alternative background color for the app. Used to differentiate between Widgets on top of each other. Eg: Menu on top of background

Color dAppbarColor = Color(0xff0e0d1f); // Set the color of the AppBar 
Color dBottombarColor = Color(0xff0e0d1f); // Set the color of Bottom Navigation Bar.

Color dBannerColor = Colors.black45; // Set the color of the banner of the Wallpaper Card.
Color dBannerTitleColor = Colors.white; // Set the text color of the title on the banner.
Color dBannerAuthorColor = Colors.white60; // Set the text color of the author on the banner.

Color dButtonBgColor = Colors.white30; // Set the color of the action buttons on the Wallpaper Viewer Screen.

// THEME SETTINGS - Light (follow same tips as Dark Theme)

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

const String kAuthorNameIfNull = "Anon"; // What name to show if a Wallpaper has no author.
const String kCollectionNameIfNull = "Others"; // Name of the collection which contains all the Wallpapers with no Collection specified.

// COMMON SCREEN SETTINGS (settings common to all screens)

const double kBorderRadius = 4; // Border radius of various widgets used throughout the app. Eg: Wallpaper Card, Buttons, etc.
const double kBlurAmount = 0; // Sets the blur amount of the banner on Wallpaper Card and Overlay on Wallpaper Viewer Screen (impacts performance if value not 0)

const double kGridViewPadding = 5; // Padding between the screen and the Grid Widgets on all screens.
const double kGridSpacing = 5; // Space between each Widget of a Grid.

const double kBorderRadiusTop = 0; // Border Radius of the top 2 corners of the Banner (should be same as kBorderRadius).
const double kBorderRadiusBottom = 4; // Border Radius of the bottom 2 corners of the Banner (should be same as kBorderRadius).
// WALLPAPER SCREEN SETTINGS (same settings used for Favorites Screen).

const double kGridAspectRatio = 0.65; // Aspect Ratio of the Wallpaper Widget (1 = Square Shape).
const int kGridCount = 2; // Number of wallpapers to show per Row on the Wallpaper Screen (Recommended values 1-3).

const double kBannerHeight = 8; // Height of the banner on the Wallpaper Widget.
const Alignment kBannerAlignment = Alignment.bottomCenter; // Alignment of the banner on the Wallpaper Widget.
const double kBannerTitleSize = 3.2; // Font size of the Title on the banner.
const double kBannerAuthorSize = 2.5; // Font size of the Author on the banner.
const double kBannerPadding = 3.2; // Padding between the Text and the banner.

const bool kShowAuthor = true; // If the banner should show the Author or not.

const bool kIsTitleUppercase = false; // Sets title to uppercase.
const bool kIsAuthorUppercase = false; // Sets author to uppercase.

const double kWallpaperTileImageQuality = 2; // Quality of the Image rendered in the widget (dont touch if not known).

// COLLECTION SCREEN SETTINGS

const double kBannerFontSize = 4; // Font size of the Collection Name on the banner.
const bool kShowCollectionCount = true; // If the banner should show number of wallpapers in the collection or not.
const bool kIsTextUppercase = true; // Sets Collection Name to uppercase.
const bool kIsCollectionNameCentered = false; // Centers the Collection Name (Only works if kShowCollectionCount = false).

const int kCollectionGridCount = 1; // Number of collections to show per Row on the Collections Screen (Recommended values 1-3).
const double kCollectionGridAspectRatio = 1.4; // Aspect Ratio of the Collection Widget (1 = Square Shape).

const double kCollectionTileImageQuality = 1; // Quality of the Image rendered in the widget (dont touch if not known).

// ICON FONTS - unicode value of what each icon represents in the app (change only if using custom IconFonts)

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
