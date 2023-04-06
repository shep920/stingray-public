import 'package:flutter/material.dart';
import 'package:hero/config/extra_colors.dart';

ThemeData darkTheme() {
  return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: ExtraColors.highlightColor,
      scaffoldBackgroundColor: const Color(0xFF000000),
      dividerColor: Colors.black,
      backgroundColor: 
          const Color(0xFF272727),
      accentColor: const Color(0xFFFFFFFF),

      //set a depreciated color

      textTheme: const TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 38),
        headline2: TextStyle(
            fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 26),
        headline3: TextStyle(
            fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 22),
        headline4: TextStyle(fontFamily: 'Roboto', fontSize: 18),
        headline5: TextStyle(
          fontSize: 14,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        bodyText1:
            TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Roboto'),
        bodyText2: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        subtitle1: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
        //this is just the WaveTile body text
        subtitle2: TextStyle(
          fontSize: 16,
          fontFamily: 'Roboto',
        ),
      ));
}
