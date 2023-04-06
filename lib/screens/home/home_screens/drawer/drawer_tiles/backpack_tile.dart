import 'package:flutter/material.dart';
import 'package:hero/screens/home/home_screens/views/backpack/backpack_screen.dart';

class BackpackTile extends StatelessWidget {
  const BackpackTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(Icons.backpack,),
      title: Text('Backpack', style: Theme.of(context).textTheme.headline4!),
      onTap: () {
        Navigator.pushNamed(context, BackpackScreen.routeName);
      },
    );
  }
}
