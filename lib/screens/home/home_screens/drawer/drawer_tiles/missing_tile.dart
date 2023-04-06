import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/whats_missing_screen.dart';
import 'package:hero/screens/home/home_screens/views/backpack/backpack_screen.dart';
import 'package:hero/screens/home/home_screens/views/prizes_screen/prize_shelf_screen.dart';

class MissingTile extends StatelessWidget {
  const MissingTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.red),
      title: Text('What\'s Missing',
          style: Theme.of(context).textTheme.headline4!),
      onTap: () {
        Navigator.pushNamed(context, WhatsMissingScreen.routeName);
      },
    );
  }
}
