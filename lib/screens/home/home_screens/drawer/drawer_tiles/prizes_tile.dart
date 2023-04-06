import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/screens/home/home_screens/views/backpack/backpack_screen.dart';
import 'package:hero/screens/home/home_screens/views/prizes_screen/prize_shelf_screen.dart';

class PrizesTile extends StatelessWidget {
  const PrizesTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.trophy,
          color: Theme.of(context).colorScheme.primary),
      title: Text('Prizes', style: Theme.of(context).textTheme.headline4!),
      onTap: () {
        Navigator.pushNamed(context, PrizeShelfScreen.routeName);
      },
    );
  }
}
