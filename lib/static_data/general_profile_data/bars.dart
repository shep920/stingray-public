import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/static_data/general_profile_data/make_icon.dart';

class Bars {
  static List bars() {
    List _bars = [
      {
        'label': 'Happy\'s',
        'value': 'Happy\'s',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.beerMugEmpty),
        'iconData': FontAwesomeIcons.beerMugEmpty
      },
      {
        'label': 'Annex',
        'value': 'Annex',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.skullCrossbones),
        'iconData': FontAwesomeIcons.skullCrossbones
      },
      {
        'label': 'Vice Versa',
        'value': 'Vice Versa',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.mask),
        'iconData': FontAwesomeIcons.mask
      },
      {
        'label': 'Starport Arcade',
        'value': 'Starport Arcade',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.gamepad),
        'iconData': FontAwesomeIcons.gamepad
      },
      {
        'label': 'Apothecary(Weekends)',
        'value': 'Apothecary(Weekends)',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.book),
        'iconData': FontAwesomeIcons.book
      },
      {
        'label': 'Mutt\'s',
        'value': 'Mutt\'s',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.dog),
        'iconData': FontAwesomeIcons.dog
      },
      {
        'label': '123 Pleasent Street',
        'value': '123 Pleasent Street',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.guitar),
        'iconData': FontAwesomeIcons.guitar
      },
      {
        'label': 'Club Ivy',
        'value': 'Club Ivy',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.bookSkull),
        'iconData': FontAwesomeIcons.bookSkull
      },
      {
        'label': 'Frat Row',
        'value': 'Frat Row',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.dumpsterFire),
        'iconData': FontAwesomeIcons.dumpsterFire
      },
      {
        'label': 'Beverly',
        'value': 'Beverly',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.biohazard),
        'iconData': FontAwesomeIcons.biohazard
      },
      {
        'label': 'House Parties',
        'value': 'House Parties',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.houseChimney),
        'iconData': FontAwesomeIcons.houseChimney
      },
      {
        'label': 'House Parties(South Park)',
        'value': 'House Parties(South Park)',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.beerMugEmpty),
        'iconData': FontAwesomeIcons.beerMugEmpty
      },
      {
        'label': 'My room',
        'value': 'My room',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.bed),
        'iconData': FontAwesomeIcons.bed
      },
      {
        'label': 'Game Night',
        'value': 'Game Night',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.chess),
        'iconData': FontAwesomeIcons.chess
      },
      {
        'label': 'Kegler\'s',
        'value': 'Kegler\'s',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.burger),
        'iconData': FontAwesomeIcons.burger
      },
      {
        'label': 'Gene\'s',
        'value': 'Gene\'s',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.beerMugEmpty),
        'iconData': FontAwesomeIcons.beerMugEmpty
      },
      {
        'label': 'Back Door',
        'value': 'Back Door',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.doorClosed),
        'iconData': FontAwesomeIcons.doorClosed,
      },
      {
        'label': 'Big Times',
        'value': 'Big Times',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.clock),
        'iconData': FontAwesomeIcons.clock
      },
      {
        'label': 'Mario\'s Fishbowl',
        'value': 'Mario\'s Fishbowl',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.fish),
        'iconData': FontAwesomeIcons.fish
      },
      {
        'label': 'Joe\'s',
        'value': 'Joe\'s',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.trafficLight),
        'iconData': FontAwesomeIcons.trafficLight
      },
      {
        'label': 'Wine Bar',
        'value': 'Wine Bar',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.wineGlass),
        'iconData': FontAwesomeIcons.wineGlass
      },
      {
        'label': 'Canteen',
        'value': 'Canteen',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.utensils),
        'iconData': FontAwesomeIcons.utensils
      },
      {
        'label': 'Gibby\'s',
        'value': 'Gibby\'s',
        'icon': MakeIcon.makeIcon(
            FontAwesomeIcons.personWalkingDashedLineArrowRight),
        'iconData': FontAwesomeIcons.personWalkingDashedLineArrowRight
      },
    ];

    _bars.shuffle();
    return _bars;
  }
}
