import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
      //enable
      useMaterial3: true,
      colorSchemeSeed: Color(0xfff040441),
      secondaryHeaderColor: const Color(0xFFF3939A4),
      primaryColorLight: const Color(0xFFF0505F2),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      dividerColor: Colors.white,
      backgroundColor: const Color(0xFF272727),
      accentColor: const Color(0xFF000000),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
            fontSize: 38),
        headline2: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
            fontSize: 26),
        headline3: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
            fontSize: 22),
        headline4:
            TextStyle(color: Colors.black, fontFamily: 'Roboto', fontSize: 18),
        headline5: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        headline6: TextStyle(
          color: Color(0xFF2B2E4A),
          fontSize: 14,
        ),
        bodyText1:
            TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Roboto'),
        bodyText2: TextStyle(
          color: Color(0xFF2B2E4A),
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        subtitle1: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontFamily: 'Roboto',
        ),
        //this is just the WaveTile body text
        subtitle2: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontFamily: 'Roboto',
        ),
      ));
}
