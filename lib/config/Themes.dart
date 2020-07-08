import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Palette.dart';

class Themes{
  static final ThemeData normal =  ThemeData(
    accentColor: Palette.orangeColor,
    primaryColor: Palette.darkBlueColor,
    disabledColor: Colors.grey,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor:Colors.white,
    buttonColor: Palette.orangeColor,
    appBarTheme: AppBarTheme(elevation: 0.0, centerTitle: true, color: Palette.darkBlueColor, textTheme: TextTheme(
        headline6: GoogleFonts.titilliumWeb(textStyle: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w400)),
      )
    ),
    fontFamily: 'Lato',
  );

}