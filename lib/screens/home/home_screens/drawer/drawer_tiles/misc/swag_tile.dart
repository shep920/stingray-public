import 'package:flutter/material.dart';
import 'package:hero/screens/home/home_screens/settings/settings_screen.dart';

class SwagTile extends StatelessWidget {
  const SwagTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.tv),
        title: SwagText(),
        onTap: () {
          Navigator.pushNamed(context, '/swag');
        });
  }
}
