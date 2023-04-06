import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/widgets/top_appBar.dart';

class WhatsMissingScreen extends StatelessWidget {
  //add a route and route method

  static const routeName = '/whats-missing';
  //make a route method
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => WhatsMissingScreen(),
    );
  }

  const WhatsMissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoaded) {
              User user = profileState.user;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child:
                        //lock icon
                        Icon(
                      Icons.lock,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "There's more to this app to be unlocked!",
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  if (!user.finishedOnboarding)
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(
                            child: FaIcon(
                              Icons.camera_alt,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Finish making your account to get SeaReal!",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  if (!user.castFirstVote)
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.anchor,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Cast your first vote to get The Bay!",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  if (!user.sentFirstSeaReal)
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.fish,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Send your first SeaReal to get Discovery!",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }

            return Container();
          },
        ));
  }
}
