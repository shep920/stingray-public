import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/models/models.dart' as myUser;
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/models.dart';
import '../../../onboarding/widgets/gradient_text.dart';

class SwagScreen extends StatelessWidget {
  static const String routeName = '/swag';
  SwagScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => SwagScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Scaffold(
              body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What is this screen?',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                        'This screen exists for me to explain all this garbage.',
                        style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 20),
                    Text(
                      'What is this app?',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                        'Last summer, I was trying to date a girl, but let\'s just say it was a tragic failure. In my moment of desperation, I turned to Tinder and Bumble, but quickly realized they were not the solutions to my love problems. So, I had a brilliant idea: why not create a dating app where I\'m the only guy available to swipe right on. Unfortunately, my genius plan never came to fruition, but it did give me the foundation for a new app idea. Right now, my plan of attack is to take inspiration from other apps and cherry-pick my favorite features to include in my app.',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start),
                    SizedBox(height: 20),
                    Text(
                      'Who am I?',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                        'I\'m Wilson, better known as the "rude buster." I\'m not too keen on revealing my true identity at the moment, but I\'ll give you a hint: I may or may not be connected to the third year med school at WVU. To all the new folks joining the app, welcome aboard! Feel free to shoot me a message anytime, anywhere. I built this app from the ground up and I\'ll do my best to respond promptly.',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (!state.user.receivedSecretVote) {
                          FirestoreRepository().addSecretDailyVote(state.user);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Daily vote added.'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('U already got yours, fool.'),
                          ));
                        }
                      },
                      child: Text(
                          'Looks like you were kind enough to read to this paragraph, thank you. If you tap this text, you\'ll get an extra vote. Be sure not to press the button below, it will do the opposite.',
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (!state.user.receivedSecretVote) {
                            FirestoreRepository()
                                .removeSecretDailyVote(state.user);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Daily vote removed. Read the fine print :]'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('U already got yours, fool.'),
                            ));
                          }
                        },
                        child: Text('Get extra daily vote!')),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Colors.black,
                    ],
                  ),
                ),
              ),
              Image.asset('assets/skyrim.webp'),
            ],
          ));
        }

        return Container();
      },
    );
  }
}
