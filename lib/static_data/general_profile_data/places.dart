import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/static_data/general_profile_data/make_icon.dart';

class Places {
  static List places() {
    List _places = [
      //none
      {
        'label': 'None',
        'value': 'None',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.ban),
        'iconData': FontAwesomeIcons.ban
      },
      {
        'label': '',
        'value': '',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.ban),
        'iconData': FontAwesomeIcons.ban
      },
      {
        'label': 'Your mom\s house',
        'value': 'Your mom\s house',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.personDress),
        'iconData': FontAwesomeIcons.personDress
      },
      {
        'label': 'Chick-fil-a',
        'value': 'Chick-fil-a',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.burger),
        'iconData': FontAwesomeIcons.burger
      },
      {
        'label': 'White park waterfall',
        'value': 'White park waterfall',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.water),
        'iconData': FontAwesomeIcons.water
      },
      {
        'label': 'Seth\'s house',
        'value': 'Seth\'s house',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.house),
        'iconData': FontAwesomeIcons.house
      },
      {
        'label': 'Evan\'s apartment',
        'value': 'Evan\'s apartment',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.houseChimney),
        'iconData': FontAwesomeIcons.houseChimney
      },
      {
        'label': 'Cooper\s rock',
        'value': 'Cooper\s rock',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.hillRockslide),
        'iconData': FontAwesomeIcons.hillRockslide
      },
      {
        'label': 'The Lair',
        'value': 'The Lair',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.buildingFlag),
        'iconData': FontAwesomeIcons.buildingFlag
      },
      {
        'label': 'The Rec Center',
        'value': 'The Rec Center',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.basketball),
        'iconData': FontAwesomeIcons.basketball
      },
      {
        'label': 'Rec Center Fields',
        'value': 'Rec Center Fields',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.football),
        'iconData': FontAwesomeIcons.football
      },

      {
        'label': 'Casa de Amici',
        'value': 'Casa de Amici',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.pizzaSlice),
        'iconData': FontAwesomeIcons.pizzaSlice
      },
      {
        'label': 'The Grind',
        'value': 'The Grind',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.mugSaucer),
        'iconData': FontAwesomeIcons.mugSaucer
      },
      {
        'label': 'Blue Moose',
        'value': 'Blue Moose',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.mugHot),
        'iconData': FontAwesomeIcons.mugHot
      },
      {
        'label': 'Terra Cafe',
        'value': 'Terra Cafe',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.earthAmericas),
        'iconData': FontAwesomeIcons.earthAmericas
      },
      {
        'label': 'Quantum Bean',
        'value': 'Quantum Bean',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.atom),
        'iconData': FontAwesomeIcons.atom
      },
      {
        'label': 'Chang Thai',
        'value': 'Chang Thai',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.bowlFood),
        'iconData': FontAwesomeIcons.bowlFood
      },
      {
        'label': 'Yama',
        'value': 'Yama',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.bowlFood),
        'iconData': FontAwesomeIcons.bowlFood
      },
      {
        'label': 'BrewPub',
        'value': 'BrewPub',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.beerMugEmpty),
        'iconData': FontAwesomeIcons.beerMugEmpty
      },
      {
        'label': 'Regal Cinema',
        'value': 'Regal Cinema',
        'icon': MakeIcon.makeIcon(FontAwesomeIcons.film),
        'iconData': FontAwesomeIcons.film
      },
    ];

    _places.shuffle();
    return _places;
  }
}
