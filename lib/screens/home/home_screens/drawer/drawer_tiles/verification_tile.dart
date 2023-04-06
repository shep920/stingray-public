import 'package:flutter/material.dart';
import 'package:hero/screens/home/home_screens/user-verification/user_verification_screen.dart';

class VerificationTile extends StatelessWidget {
  const VerificationTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: //if user.newMessages is true, then show a red dot

          Icon(Icons.verified),
      title: Text('Verification', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        Navigator.pushNamed(context, UserVerificationScreen.routeName);
      },
    );
  }
}
