import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Palette.dart';

class Themes {
  static final SystemUiOverlayStyle systemUiOverlayStyleLight =
      SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Palette.darkGray,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  );

  static final SystemUiOverlayStyle systemUiOverlayStyleDark =
      SystemUiOverlayStyle(
    systemNavigationBarColor: Palette.darkGray,
    systemNavigationBarDividerColor: Palette.darkGray,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Palette.darkGray,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  );

  static final ThemeData normal = ThemeData(
    colorScheme: ColorScheme(
        primary: Palette.darkGray,
        primaryContainer: Palette.darkGray,
        secondary: Palette.orange,
        secondaryContainer: Palette.orange,
        surface: Palette.lightGray,
        background: Colors.white,
        error: Colors.red,
        onPrimary: Palette.orange,
        onSecondary: Palette.lightGray,
        onSurface: Palette.darkGray,
        onBackground: Palette.darkGray,
        onError: Palette.lightGray,
        brightness: Brightness.light),
    primaryColor: Palette.darkGray,
    disabledColor: Colors.grey,
    scaffoldBackgroundColor: Palette.lightGray,
    backgroundColor: Colors.white,
    cardTheme: CardTheme(
      elevation: 0,
      margin: EdgeInsets.all(8),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: Palette.orange,
      activeTrackColor: Palette.orange,
      inactiveTrackColor: Colors.black.withAlpha(20),
      trackHeight: 18.0,
      thumbShape: RoundSliderThumbShape(elevation: 0),
      overlayColor: Colors.transparent,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Palette.darkGray),
      titleTextStyle: GoogleFonts.titilliumWebTextTheme().headline6.copyWith(
          fontSize: 40, fontWeight: FontWeight.w700, color: Palette.darkGray),
    ),
    textTheme: GoogleFonts.titilliumWebTextTheme(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Palette.blue,
        unselectedItemColor: Palette.darkGray,
        backgroundColor: Colors.transparent,
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        )),
    buttonBarTheme: ButtonBarThemeData(buttonTextTheme: ButtonTextTheme.accent),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: Palette.orange,
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: Palette.orange,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      primary: Palette.orange,
    )),
  );
}
