import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Intramurals {
  static List intramurals() {
    List _intramurals = [
      {
        'label': 'Volleyball',
        'value': 'Volleyball',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.volleyball,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Soccer',
        'value': 'Soccer',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.futbol,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Raquetball',
        'value': 'Raquetball',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.tableTennisPaddleBall,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Pickleball',
        'value': 'Pickleball',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.tableTennisPaddleBall,
            size: 20,
          ),
        ),
      },
      {
        'label': 'BasketBall',
        'value': 'BasketBall',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.basketball,
            size: 20,
          ),
        ),
      },
    ];

    _intramurals.shuffle();
    return _intramurals;
  }
}
