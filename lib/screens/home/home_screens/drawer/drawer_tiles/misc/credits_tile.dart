import 'package:flutter/material.dart';

class CreditsTile extends StatelessWidget {
  const CreditsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.emoji_events),
      title: Text('Credits', style: Theme.of(context).textTheme.headline4!),

      //when tapped send them to the navigator of /credits
      onTap: () {
        Navigator.pushNamed(context, '/credits');
      },
    );
  }
}
