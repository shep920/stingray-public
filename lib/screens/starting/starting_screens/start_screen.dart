import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hero/widgets/top_appBar.dart';

import '../../onboarding/widgets/custom_opening_button.dart';

class Start extends StatelessWidget {
  final TabController tabController;

  const Start({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: 'Welcome to Stingray!',
        hasActions: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Image(image: AssetImage('assets/stingray_logo.png')),
            ),
            SizedBox(height: 50),
            Text('Welcome to Stingray!',
                style: Theme.of(context).textTheme.headline2),
            SizedBox(height: 20),
            Text(
              'Move on to sign up!',
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(height: 1.8),
              textAlign: TextAlign.center,
            ),
            CustomOpeningButton(
              onPressed: () => Navigator.pushNamed(context, '/signIn'),
              text: 'SIGN IN',
            ),
            CustomOpeningButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              text: 'SIGN UP',
            ),
          ],
        ),
      ),
    );
  }
}
