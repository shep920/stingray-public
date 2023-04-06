import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_popup.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_textfield.dart';
import 'package:hero/screens/home/home_screens/views/story/report_story_modal.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/widgets/dismiss_keyboard.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
//import timeago package
import 'package:timeago/timeago.dart' as timeago;

class StoryView extends StatefulWidget {
  //add a route and a route name
  static const routeName = '/story-view';

  //make the route method
  static Route route({required List<Story> stories}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => StoryView(stories: stories),
    );
  }

  final List<Story> stories;

  StoryView({required this.stories});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  int _currentIndex = 0;
  late Story _currentStory;

  initState() {
    _currentStory = widget.stories[_currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User _user = profileState.user;
          return BlocBuilder<StingrayBloc, StingrayState>(
            builder: (context, stingrayState) {
              if (stingrayState is StingrayLoaded) {
                List<Stingray?> stingrays = stingrayState.stingrays;
                User _stingrayUser = User.fromStingray(stingrays.firstWhere(
                    (stingray) => stingray!.id == _currentStory.posterId)!);

                Stingray _stingray = stingrays.firstWhere(
                    (stingray) => stingray!.id == _currentStory.posterId)!;
                List<Story> _stories = stingrayState.storiesMap[_stingray.id]!;
                return Scaffold(
                  body: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: <Widget>[
                        DismissKeyboard(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .9,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      _currentStory.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //a progress bar at the top of the image
                        Positioned(
                          top: 0,
                          child: Container(
                            margin: //left and right margin
                                EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width,
                            child: StepProgressIndicator(
                              totalSteps: widget.stories.length,
                              currentStep: _currentIndex + 1,
                              size: 2,
                              padding: 1,
                              selectedColor: Colors.white,
                              unselectedColor: Colors.grey,
                            ),
                          ),
                        ),
                        //a black box to cover the bottom of the image
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                          ),
                        ),

                        //an invisible gesture detector on the right side of the screen
                        Positioned(
                          right: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            height: MediaQuery.of(context).size.height,
                            child: GestureDetector(
                              onTap: () {
                                if (_currentIndex < widget.stories.length - 1) {
                                  BlocProvider.of<StingrayBloc>(context).add(
                                      ViewStory(
                                          story: widget
                                              .stories[_currentIndex + 1]));
                                  setState(() {
                                    _currentIndex++;
                                    _currentStory =
                                        widget.stories[_currentIndex];
                                  });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ),

                        //an invisible gesture detector on the left side of the screen
                        Positioned(
                          left: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            height: MediaQuery.of(context).size.height,
                            child: GestureDetector(
                              onTap: () {
                                if (_currentIndex > 0) {
                                  setState(() {
                                    _currentIndex--;
                                    _currentStory =
                                        widget.stories[_currentIndex];
                                  });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ),

                        //DirectMessagePopupTextField over the black box
                        if (_user.finishedOnboarding)
                          Positioned(
                            bottom: 0,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DirectMessagePopupTextField(
                                voteTarget: _stingrayUser,
                                user: _user,
                                imageurl: _currentStory.imageUrl,
                              ),
                            ),
                          ),

                        //make a positioned x button to go back in the top left
                        Positioned(
                          top: 50,
                          right: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //a circle avatar of the stingray
                                Padding(
                                  //only left and right padding
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    child: Hero(
                                      tag: _stingrayUser.id!,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                _stingrayUser.imageUrls[0]),
                                      ),
                                    ),
                                    onTap: () {
                                      BlocProvider.of<VoteBloc>(context).add(
                                          LoadUserFromFirestore(
                                              _stingrayUser.id));
                                      Navigator.pushNamed(
                                        context,
                                        VoteScreen.routeName,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    _stingrayUser.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    timeago.format(_currentStory.postedAt,
                                        locale: 'en_short'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),

                                Spacer(),

                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //have a popup menu with a report button
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ReportStoryModal(
                                            user: _user,
                                            stingrayUser: _stingrayUser,
                                            currentStory: _currentStory);
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}
