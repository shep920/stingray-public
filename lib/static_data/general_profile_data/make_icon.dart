import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MakeIcon {
  static Container makeIcon(IconData icon) {
    return Container(
      // if you want to use icon, you have to declare key as 'icon'
      key: UniqueKey(), // you have to use UniqueKey()
      height: 20,
      width: 20,
      child: FaIcon(
        icon,
        size: 20,
      ),
    );
  }
}
