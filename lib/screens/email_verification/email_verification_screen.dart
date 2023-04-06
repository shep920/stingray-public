import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/leaderboad/leaderboard_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/tutorial_screen.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:provider/src/provider.dart';
import 'package:hero/models/models.dart' as myUser;

import '../../blocs/stingrays/stingray_bloc.dart';
import '../../helpers/initialize_loads.dart';
import '../../repository/messaging_repository.dart';

class VerifyScreen extends StatefulWidget {
  static const String routeName = '/verify';
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => VerifyScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser!;

    if (user!.emailVerified == false) {
      user!.sendEmailVerification();
    }
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Verification email sent. Go check the link.',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Center(
                child: Text('Make sure to check your inbox.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.popAndPushNamed(context, '/start');
                  },
                  child: Text('Signout'),
                ),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();

      initializeLoads(context, user!.uid);

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
      Navigator.of(context).pushNamed(TutorialScreen.routeName);
    }
  }
}
