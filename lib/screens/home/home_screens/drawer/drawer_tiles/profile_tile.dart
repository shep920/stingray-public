import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //set the color of the backgrond of the listtile to scaffoldBackgroundColor

      leading: Icon(Icons.person_outline,
          color: Theme.of(context).colorScheme.primary),
      title: Text('Profile', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        Navigator.pushNamed(context, '/profile');
      },
    );
  }
}
