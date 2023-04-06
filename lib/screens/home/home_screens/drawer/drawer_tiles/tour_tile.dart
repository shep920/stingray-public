import 'package:flutter/material.dart';

class TourTile extends StatelessWidget {
  const TourTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //set the color of the backgrond of the listtile to scaffoldBackgroundColor

      leading: Icon(
        Icons.help_outline,
      ),
      title: Text('Tutorial', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        Navigator.pushNamed(context, '/tutorial');
      },
    );
  }
}
