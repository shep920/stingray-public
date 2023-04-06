import 'package:flutter/material.dart';
import 'package:hero/screens/home/home_screens/settings/banned_handles_screen.dart';

class BlockedUsersTile extends StatelessWidget {
  const BlockedUsersTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.block),
      title: Text('Blocked users',
          style: Theme.of(context).textTheme.headline4!),
      
      
      onTap: () {
        Navigator.pushNamed(
            context, BannedHandlesScreen.routeName);
      },
    );
  }
}