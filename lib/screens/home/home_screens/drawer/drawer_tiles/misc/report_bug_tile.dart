import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportBugTile extends StatelessWidget {
  const ReportBugTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.bug_report),
      title: Text('Report a bug',
          style: Theme.of(context).textTheme.headline4!),
      
      
      //when tapped send them to https://github.com/shep920/stingrayWvIssues/issues
      onTap: () async {
        const url =
            'https://github.com/shep920/stingrayWvIssues/issues';
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }
}