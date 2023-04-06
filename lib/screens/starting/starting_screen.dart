import 'package:hero/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../onboarding/widgets/custom_opening_button.dart';
import 'starting_screens/start_screens.dart';

class StartingScreen extends StatelessWidget {
  static const String routeName = '/start';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => StartingScreen(),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Login'),
    Tab(text: 'Signup'),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: TopAppBar(
              implyLeading: false,
              title: 'Welcome!',
              hasActions: false,
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child:
                          Image(image: AssetImage('assets/stingray_logo.png')),
                    ),
                    SizedBox(height: 50),
                    Text('Welcome to Stingray!',
                        style: Theme.of(context).textTheme.headline2),
                    SizedBox(height: 20),
                    Text(
                      'Move on to sign up!',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(height: 1.8),
                      textAlign: TextAlign.center,
                    ),
                    //create two buttons aligned to the bottom of the screen
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomOpeningButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/signIn'),
                              text: 'SIGN IN',
                            ),
                            SizedBox(height: 20),
                            CustomOpeningButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/signup'),
                              text: 'SIGN UP',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
