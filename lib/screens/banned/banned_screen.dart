//stateless widget for a screen a user who is banned will see
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/screens/wrapper/wrapper.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../models/user_model.dart';

class BannedScreen extends StatefulWidget {
  BannedScreen({Key? key}) : super(key: key);
  //make a route for this screen
  static const String routeName = '/banned';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BannedScreen(),
    );
  }

  @override
  State<BannedScreen> createState() => _BannedScreenState();
}

class _BannedScreenState extends State<BannedScreen> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        //if the user is not banned
        if ((BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
            .user
            .isBanned) {
          Navigator.pushReplacementNamed(context, MainPage.routeName);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        //a blocconsumer for profile bloc
        BlocConsumer<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        //if the profileState is profile loaded
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          //return a scaffold
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'You have been banned for the following reason: ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    const SizedBox(height: 26.0),
                    Flexible(
                      child: Text(
                        user.banReason,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    //text of headline 4 saying your ban expires at the date and time of the ban
                    Text(
                      'Your ban expires at ${user.banExpiration}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'If you believe this is a mistake, please contact support',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '304-867-5309',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
        //if the profileState is profile loading
      },
      listener: (context, profileState) {
        //if the profileState is profile error
        if (profileState is ProfileLoaded) {
          //if the user is banned
          if (!profileState.user.isBanned ||
              profileState.user.banExpiration.isBefore(DateTime.now())) {
            //push the banned screen
            FirestoreRepository().unban(profileState.user);
            Navigator.popAndPushNamed(context, Wrapper.routeName);
          }
        }
      },
    );
  }
}
