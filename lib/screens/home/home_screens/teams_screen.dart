import 'package:flutter/material.dart';
import 'package:hero/models/models.dart';
import 'package:hero/widgets/widgets.dart';

class TeamScreen extends StatelessWidget {
  static const String routeName = '/teams';
  TeamScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => TeamScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: TopAppBar(title: 'Teams'));
  }
}
