import 'package:flutter/material.dart';

import 'Palette.dart';

class Themes{
  static final ThemeData normal =  ThemeData(
    accentColor: Palette.orangeColor,
    primaryColor: Palette.darkBlueColor,
    disabledColor: Colors.grey,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor:Colors.white,
    buttonColor: Palette.orangeColor,
    appBarTheme: AppBarTheme(elevation: 0.0, color: Palette.darkBlueColor),
    fontFamily: 'Lato',
  );

}