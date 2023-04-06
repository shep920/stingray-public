import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/models/models.dart';
import 'package:hero/repository/auth_repository.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/email_verification/email_verification_screen.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/screens/screens.dart';
import 'package:isar/isar.dart';
import 'package:new_version/new_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../blocs/cloud_messaging/cloud_messaging_bloc.dart';
import '../../blocs/leaderboad/leaderboard_bloc.dart';
import '../../blocs/stingrays/stingray_bloc.dart';
import '../../helpers/initialize_loads.dart';
import '../../repository/messaging_repository.dart';
import '../starting/starting_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  static const String routeName = '/wrapper/';
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => Wrapper(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    //if the app is being opened from a push notification, then we need to navigate to the chat screen
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state != AuthState.unknown()) {
          if (state == AuthState.unauthenticated()) {
            return StartingScreen();
          } else {
            if (state.user!.emailVerified) {
              initializeLoads(context, state.user!.uid);

              //set a timer that returns mainPage after 5 seconds

              return MainPage();
            }
            return VerifyScreen();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

// function isCurrentVersionOutdated returns a boolean value and takes two parameters, the current version and the latest version.

void handleMessageOnBackground() {
  FirebaseMessaging.instance.getInitialMessage().then(
    (remoteMessage) {
      if (remoteMessage != null) {
        print('Message: ${remoteMessage.data}');
        RemoteMessage? message = remoteMessage;
      }
    },
  );
}
