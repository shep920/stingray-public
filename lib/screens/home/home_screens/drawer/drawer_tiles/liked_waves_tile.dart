import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/liked_waves_screen.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/my_waves_screen.dart';

class LikedWavesTile extends StatelessWidget {
  const LikedWavesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //set the color of the backgrond of the listtile to scaffoldBackgroundColor

      leading: FaIcon(FontAwesomeIcons.arrowUp,
          ),
      title: Text('Liked Waves', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        Navigator.pushNamed(context, LikedWavesScreen.routeName);
      },
    );
  }
}
