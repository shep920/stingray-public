import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/my_waves_screen.dart';

class MyWavesTile extends StatelessWidget {
  const MyWavesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //set the color of the backgrond of the listtile to scaffoldBackgroundColor

      leading: FaIcon(FontAwesomeIcons.water,
          ),
      title: Text('My Waves', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        Navigator.pushNamed(context, MyWavesScreen.routeName);
      },
    );
  }
}
