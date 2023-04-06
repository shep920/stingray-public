import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/general_containers/general_container.dart';
import 'package:hero/screens/home/home_screens/tutorial_containers_text.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../../blocs/profile/profile_bloc.dart';

class TutorialScreen extends StatefulWidget {
  TutorialScreen({Key? key}) : super(key: key);

  //add a static routeName
  static const String routeName = '/tutorial';
  //add a static route method
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => TutorialScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopAppBar(
          implyLeading: false,
        ),
        body:
            //an animated container of color EE2677 that when clicked will change its height
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Welcome to Stingray WV!',
                  style: Theme.of(context).textTheme.headline1,
                  //center
                  textAlign: TextAlign.center,
                ),
              ),
              const GeneralContainer(
                collapsedColor: Color(0xFFFFD9DA),
                expandedColor: Color(0xFFEA638C),
                textColor: Colors.black,
                iconColor: Color(0xFF1B2021),
                headers: TutorialContainersText.generalHeaders,
                bodies: TutorialContainersText.generalBodies,
                images: TutorialContainersText.generalImages,
                relevantIcons: [],
              ),
              const GeneralContainer(
                collapsedColor: Color(0xFFB9FFB7),
                expandedColor: Color(0xFF98D9C2),
                textColor: Colors.black,
                iconColor: Color(0xFFF19A3E),
                headers: TutorialContainersText.voteHeaders,
                bodies: TutorialContainersText.voteBodies,
                images: TutorialContainersText.voteImages,
                relevantIcons: [
                  [],
                  [Icons.person_search_outlined],
                  [
                    FontAwesomeIcons.anchor,
                    Icons.beach_access,
                  ],
                  [
                    Icons.person_search_outlined,
                    Icons.camera_alt,
                  ],
                  [FontAwesomeIcons.fish],
                  [Icons.movie_outlined]
                ],
              ),
              const GeneralContainer(
                collapsedColor: Color(0xFFEFB0A1),
                expandedColor: Color(0xFFF4AFB4),
                textColor: Colors.black,
                iconColor: Color(0xFF94A89A),
                headers: TutorialContainersText.stingrayHeaders,
                bodies: TutorialContainersText.stingrayBodies,
                images: TutorialContainersText.stingrayImages,
                relevantIcons: [
                  [Icons.home_outlined],
                  [
                    Icons.home_outlined,
                  ],
                  [Icons.home_outlined],
                  [FontAwesomeIcons.trophy],
                  [
                    Icons.home_outlined,
                    Icons.edit,
                  ],
                  [
                    Icons.home_outlined,
                    Icons.star,
                  ],
                  [
                    Icons.home_outlined,
                    Icons.photo_library,
                  ],
                  [
                    Icons.home_outlined,
                    Icons.photo_library,
                  ],
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              //an elevated button that triggers a navigation pop mack to /mainPage and the blocProvider of profileBloc Close Tutorial
              ElevatedButton(
                //primary color
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  //add a blocProvider of profileBloc Close Tutorial
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const CloseTutorial());

                  Navigator.pushReplacementNamed(context, MainPage.routeName);
                },
                child: Text(
                  'All done!',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).dividerColor),
                ),
              )
            ],
          ),
        ));

    ;
  }
}
