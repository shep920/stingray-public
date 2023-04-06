import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EULATile extends StatelessWidget {
  const EULATile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.lock),
      title: Text('End Users License Agreement',
          style: Theme.of(context).textTheme.headline4),
      onTap: () async {
        final Uri url = Uri.parse('https://eula-c6300.web.app/');
        if (!await launchUrl(url)) {
          throw 'Could not launch $url';
        }
      },
    );
  }
}
