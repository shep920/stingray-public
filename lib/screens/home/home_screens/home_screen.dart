import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/screens/banned/banned_screen.dart';
import 'package:hero/screens/home/home_screens/notifications_screen.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/tutorial_screen.dart';
import 'package:hero/screens/home/home_screens/views/generic_view.dart';
import 'package:hero/screens/home/home_screens/views/make_story/new_story_screen.dart';
import 'package:hero/screens/home/home_screens/views/stingray_view.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/swipe/swipe_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/models/models.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/choice_button.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:hero/widgets/user_card.dart';
import 'package:hero/widgets/user_image_small.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../blocs/stingrays/stingray_bloc.dart';
import '../../../models/posts/wave_model.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/expandable_fab.dart';
import '../main_page.dart';
import 'discovery/discovery_messages_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => HomeScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      //if the message data contains notificationSreen
      _onOpen(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          _onOpen(message);
        }
      },
    );

    super.initState();
  }

  void _onOpen(RemoteMessage message) {
    if (message.data.containsKey('notificationsScreen')) {
      Navigator.popUntil(context, ModalRoute.withName(MainPage.routeName));
      Navigator.pushNamed(context, NotificationsScreen.routeName);
    }

    if (message.data.containsKey('chatId')) {
      Map<String, dynamic> map = {
        'chatId': message.data['chatId'],
        'userId': message.data['userId']
      };

      Navigator.pushReplacementNamed(context, MainPage.routeName);
      Navigator.pushNamed(context, DiscoveryMessagesScreen.routeName,
          arguments: map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          if (!state.user.seenTutorial &&
              (state.isViewingTutorial == null ||
                  state.isViewingTutorial == false)) {
            //add the ProfileBloc event ViewingTutorial
            tutorialHandler(context);
          }

          return BlocBuilder<StingrayBloc, StingrayState>(
            builder: (context, stingrayState) {
              if (stingrayState is StingrayLoading) {
                Provider.of<StingrayBloc>(context, listen: false)
                    .add(LoadStingray(sortOrder: 'Recent', user: state.user));
                //return circular progress indicator
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (stingrayState is StingrayLoaded) {
                return Scaffold(
                  body: SafeArea(child: GenericView()),
                );
              }
              return (Container());
            },
          );
        } else {
          //return circular progress indicator
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void tutorialHandler(BuildContext context) {
    {
      //add the ProfileBloc event ViewingTutorial
      context.read<ProfileBloc>().add(ViewingTutorial());
      //show a custom dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(TutorialScreen.routeName);
      });
    }
  }
}
