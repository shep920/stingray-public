import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dorms {
  static List dorms() {
    List _dorms = [
      {
        'label': 'Bennet Tower',
        'value': 'Bennet Tower',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.gamepad,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Boreman',
        'value': 'Boreman',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.hippo,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Braxton Tower',
        'value': 'Braxton Tower',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.ghost,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Brooke Tower',
        'value': 'Brooke Tower',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.docker,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Dadisman',
        'value': 'Dadisman',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.skullCrossbones,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Honors Hall',
        'value': 'Honors Hall',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.star,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Lincoln Hall',
        'value': 'Lincoln Hall',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.hatCowboy,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Lyon Tower',
        'value': 'Lyon Tower',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.wolfPackBattalion,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Oakland',
        'value': 'Oakland',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.tree,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Seneca',
        'value': 'Seneca',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.broomBall,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Stalneker',
        'value': 'Stalneker',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.beerMugEmpty,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Summit',
        'value': 'Summit',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.mountain,
            size: 20,
          ),
        ),
      },
      {
        'label': 'Never did dorms',
        'value': 'Never did dorms',
        'icon': Container(
          // if you want to use icon, you have to declare key as 'icon'
          key: UniqueKey(), // you have to use UniqueKey()
          height: 20,
          width: 20,
          child: FaIcon(
            FontAwesomeIcons.faceSadCry,
            size: 20,
          ),
        ),
      },
    ];

    _dorms.shuffle();
    return _dorms;
  }
}
