import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MatoiTile extends StatelessWidget {
  const MatoiTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.tv),
      title: Text('Matoi Technology',
          style: Theme.of(context).textTheme.headline4),
      onTap: () async {
        final Uri url = Uri.parse('https://matoiTechnology.com/');
        if (!await launchUrl(url)) {
          throw 'Could not launch $url';
        }
      },
    );
  }
}
