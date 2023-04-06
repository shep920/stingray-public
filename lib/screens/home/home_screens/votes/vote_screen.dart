import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/leaderboad/leaderboard_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';

import 'package:hero/models/models.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/views/generic_view.dart';
import 'package:hero/screens/home/home_screens/votes/vote_view.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/screens/onboarding/widgets/goal_containers.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';
import 'package:hero/static_data/general_profile_data/student_organitzations.dart';
import 'package:hero/static_data/report_stuff.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:typesense/typesense.dart';

import '../../../../blocs/typesense/bloc/search_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../models/leaderboard_model.dart';
import '../../../../models/user_notifications/user_notification_model.dart';
import '../../../../models/user_notifications/user_notification_type.dart';
import '../../../../models/posts/wave_model.dart';
import '../../../../static_data/profile_data.dart';
import '../../../../static_data/report_reasons.dart';
import '../../../profile/profile_screen.dart';
import '../views/photo_view/photo_view.dart';
import '../views/waves/widget/wave_tile.dart';

class VoteScreen extends StatefulWidget {
  static const String routeName = '/votes';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => VoteScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  List<Wave?> waves = [];
  bool isLoading = false;

  @override
  void initState() {
    _getWaves().then((waves) => setState(() {
          this.waves = waves;
        }));
    //get waves
    super.initState();
  }

  Future<List<Wave?>> _getWaves() async {
    final state = BlocProvider.of<SearchBloc>(context).state as QueryLoaded;
    final voteState = BlocProvider.of<VoteBloc>(context).state;

    if (voteState is VoteLoaded) {
      final User? voteUser = voteState.user;

      if (voteUser == null) {
        return [];
      }

      Client client = state.client;
      final search = {
        'searches': [
          {
            'collection': 'waves',
            'q': '*',
            'query_by': 'message',
            'page': '1',
            'per_page': '5',
            'sort_by': 'likes:desc',
            'filter_by': 'senderId:${voteUser.id} && type:${Wave.default_type}',
          }
        ]
      };
      final doc = await client.multiSearch.perform(search);
      List<Wave?> results =
          (((doc['results'] as List<dynamic>)[0])['hits'] as List)
              .cast<Map>()
              .map((e) => Wave.waveFromTypesenseDoc(e))
              .toList();

      return results;
    }
    return [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<VoteBloc, VoteState>(
      builder: (context, state) {
        if (state is VoteLoaded) {
          User? voteUser = state.user;

          int imageUrlIndex = state.imageUrlIndex;
          return BlocBuilder<ProfileBloc, ProfileState>(
              builder: ((context, profileState) {
            if (profileState is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (profileState is ProfileLoaded) {
              User? user = profileState.user;
              String votesUsable = profileState.user.votesUsable.toString();

              User? voteUser = state.user;
              return (voteUser == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 100,
                        ),
                        Text(
                          "Looks like no one is here",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        //a button to pop the screen
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          //make it black
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          child: Text("Go Back"),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        VoteView(
                            voteUser: voteUser,
                            imageUrlIndex: imageUrlIndex,
                            waves: waves,
                            user: user),
                        if (!voteUser.isStingray && !voteUser.isPup)
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .1,
                            child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child:
                                      //centered text saying vote!
                                      Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //checkbox icon
                                      Icon(
                                        Icons.check_box,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      Text(
                                        'Vote',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return VotePopup(
                                        user: profileState.user,
                                        voteTarget: voteUser,
                                        votesUsable: profileState
                                            .user.votesUsable
                                            .toString(),
                                      );
                                    },
                                  );
                                }),
                            bottom: 0,
                          ),
                        if (voteUser.isPup)
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .1,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                child:
                                    //centered text saying vote!
                                    Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //checkbox icon

                                    Text(
                                      'Featured!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            bottom: 0,
                          ),
                      ],
                    );
            }
            return Text('bruh');
          }));
        }
        return Text('check');
      },
    ));
  }
}

class UserReportPopup extends StatelessWidget {
  final User voteUser;
  const UserReportPopup({Key? key, required this.voteUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> blockedUsers =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
            .user
            .blockedUsers;
    return
        //show a bottom sheet that contains a listview with three list tiles, report, block, and cancel
        Container(
      height: MediaQuery.of(context).size.height * .5,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Report Options",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (blockedUsers.length < 10 &&
                    !blockedUsers.contains(voteUser.handle)) {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(BlockUserHandle(user: voteUser, context: context));
                  //block the user back to the main page
                  Navigator.popUntil(
                      context, ModalRoute.withName(MainPage.routeName));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("You can only block 10 users at a time",
                          style: Theme.of(context).textTheme.headline4)));
                }
              },
              child: Text("Block",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor)),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //make it longer
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                //show a report user dialog
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReportUserDialog(
                        voteUser: voteUser,
                      );
                    });
              },
              child: Text("Report",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  //make it longer
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor)),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //make it longer
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportUserDialog extends StatefulWidget {
  final User voteUser;
  ReportUserDialog({Key? key, required this.voteUser}) : super(key: key);

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  List<String> reasons = ReportReasons.reasons;
  String selectedReason = ReportReasons.empty;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //make the alert dialog
      title: Text("Report ${widget.voteUser.name}"),
      content: Container(
        height: MediaQuery.of(context).size.height * .5,
        child:
            //a dropdown menu to select a reason
            DropdownButtonFormField<String>(
          value: selectedReason,
          decoration: InputDecoration(
            labelText: "Reason",
          ),
          items: reasons.map((String reason) {
            return DropdownMenuItem<String>(
              value: reason,
              child: Text(reason),
            );
          }).toList(),
          onChanged: (String? reason) {
            setState(() {
              selectedReason = reason!;
            });
          },
        ),
      ),
      actions: [
        //two elevated buttons, one to cancel and one to report. if the user has not selected a reason, the report button is disabled
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary,
            //make it longer
          ),
        ),
        //an elevated button to report the user. if the user has not selected a reason, the report button is disabled
        ElevatedButton(
          onPressed: selectedReason == ""
              ? null
              : () {
                  Report userReport = Report.generateUserReport(
                      type: ReportStuff.user_type,
                      reported: widget.voteUser,
                      reason: selectedReason,
                      reporter: (BlocProvider.of<ProfileBloc>(context).state
                              as ProfileLoaded)
                          .user);
                  FirestoreRepository.sendReport(userReport);

                  //report the user
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("User Reported"),
                  ));
                },
          child: Text("Report"),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            //make it longer
          ),
        ),
      ],
    );
  }
}

class VotePopup extends StatelessWidget {
  const VotePopup({
    Key? key,
    required this.votesUsable,
    required this.voteTarget,
    required this.user,
  }) : super(key: key);

  final User user;
  final String votesUsable;
  final User voteTarget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Vote for ${voteTarget.name}?",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: IconButton(
                    onPressed: () {
                      try {
                        if (user.votesUsable < 1) {
                          Navigator.pop(context);
                          throw 'You have no votes!';
                        }
                        FirestoreRepository(id: user.id)
                            .voteEvent(voteTarget.id, user.votesUsable);

                        if (user.id != voteTarget.id) {
                          FirestoreRepository(id: user.id)
                              .updateVoteListener(user, voteTarget);
                          UserNotification _voteNotification =
                              UserNotification.genericUserNotification(
                            type: UserNotificationType.vote,
                            relevantUserHandle: user.handle,
                            imageUrl: user.imageUrls[0],
                          );

                          FirestoreRepository.updateUserNotification(
                              voteTarget.id!, _voteNotification);
                        }

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.check_circle_outline_rounded),
                    iconSize: 150,
                    color: Colors.green,
                  ),
                ),
                InkWell(
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.clear_rounded),
                    color: Colors.red,
                    iconSize: 150,
                  ),
                )
              ],
            ),
            Text('Votes remaining: $votesUsable',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Theme.of(context).colorScheme.primary))
          ],
        ),
      ),
    );
  }
}
