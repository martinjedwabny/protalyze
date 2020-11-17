import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Palette.dart';

class Themes{
  static final ThemeData normal =  ThemeData(
    accentColor: Palette.orange,
    primaryColor: Palette.darkGray,
    disabledColor: Colors.grey,
    scaffoldBackgroundColor: Palette.lightGray,
    backgroundColor: Colors.white,
    buttonColor: Palette.orange,
    cardTheme: CardTheme(
      elevation: 0,
      margin: EdgeInsets.all(8),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Palette.darkGray
      ),
      textTheme: TextTheme(
        headline6: GoogleFonts.titilliumWebTextTheme().headline6.copyWith(
          fontSize: 40, 
          fontWeight: FontWeight.w700, 
          color: Palette.darkGray
        )
      ),
    ),
    textTheme: GoogleFonts.titilliumWebTextTheme(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Palette.blue,
      unselectedItemColor: Palette.darkGray,
      backgroundColor: Colors.transparent,
      selectedLabelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      )
    ),
    buttonBarTheme: ButtonBarThemeData(
      buttonTextTheme: ButtonTextTheme.accent
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
    ),
  );

}