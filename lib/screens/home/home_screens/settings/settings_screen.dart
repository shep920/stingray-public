import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/admin%20bloc/admin_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/models/models.dart' as myUser;
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/admin_number_pad.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../models/models.dart';
import '../../../onboarding/widgets/gradient_text.dart';
import '../views/waves/widget/video/wave_video_preview.dart';
import 'banned_handles_screen.dart';

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static const String routeName = '/settings';
  SettingsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => SettingsScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          myUser.User? user = state.user;
          return BlocBuilder<StingrayBloc, StingrayState>(
            builder: (context, stingrayState) {
              if (stingrayState is StingrayLoaded) {
                return Scaffold(
                  body: Center(
                    child: ListView(
                      children: [
                        // LogoutTile(firebaseAuth: _firebaseAuth),
                        
                          
                        
                        
                      ],
                    ),
                  ),
                );
              }
              Provider.of<StingrayBloc>(context, listen: false)
                  .add(LoadStingray(sortOrder: 'Recent', user: state.user));
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _firebaseAuth.signOut();
                  Navigator.popAndPushNamed(context, '/wrapper/');
                },
                child: Text('logout'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _firebaseAuth.currentUser!.delete();
                  } catch (e) {
                    print('error deleting user: $e');
                  }
                  Navigator.popAndPushNamed(context, '/wrapper/');
                },
                child: Text('delete urself'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // await FirestoreRepository(
                    //         id: '56yV48CFcKMR5QAToo6Aiphrv8E3')
                    //     .updateUserData(
                    //         '',
                    //         '',
                    //         0,
                    //         '',
                    //         [],
                    //         [],
                    //         '',
                    //         false,
                    //         null,
                    //         '',
                    //         0,
                    //         0,
                    //         2,
                    //         false,
                    //         [],
                    //         false,
                    //         '',
                    //         [],
                    //         '',
                    //         false,
                    //         [],
                    //         DateTime.now(),
                    //         await FirebaseMessaging.instance.getToken(),
                    //         false,
                    //         false,
                    //         false,
                    //         15,
                    //         '56yV48CFcKMR5QAToo6Aiphrv8E3',
                    //         0);
                  },
                  child: Text('save me'))
            ],
          ),
        );
      },
    );
  }
}



















class SwagText extends StatefulWidget {
  const SwagText({
    Key? key,
  }) : super(key: key);

  @override
  State<SwagText> createState() => _SwagTextState();
}

class _SwagTextState extends State<SwagText> {
  List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];
  late Timer _timer;

  @override
  void initState() {
    //make the timer shift the colors every 100 milliseconds
    _timer = Timer.periodic(
        Duration(
            milliseconds: //half a second
                75), (timer) {
      setState(() {
        colors.insert(0, colors.removeLast());
      });
    });
    super.initState();
  }

  @override
  dispose() {
    print('done');
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientText(
      'My Swag Page',
      style: TextStyle(fontSize: 40),
      gradient: LinearGradient(colors: colors),
    );
  }
}
