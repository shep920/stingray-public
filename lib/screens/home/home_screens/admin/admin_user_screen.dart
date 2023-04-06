import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/leaderboad/leaderboard_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';

import 'package:hero/models/models.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/screens/home/home_screens/votes/vote_view.dart';
import 'package:hero/screens/onboarding/widgets/goal_containers.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:provider/provider.dart';

import '../../../../blocs/admin bloc/admin_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../models/leaderboard_model.dart';

class AdminUserScreen extends StatelessWidget {
  static const String routeName = '/adminUser';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => AdminUserScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<AdminBloc>(context, listen: false).add(CloseUser());
        return true;
      },
      child: Scaffold(
          appBar: TopAppBar(title: 'Admin'),
          body: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              if (state is AdminLoaded) {
                User? adminUser = state.user;
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: ((context, profileState) {
                  if (profileState is ProfileLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (profileState is ProfileLoaded) {
                    String votesUsable =
                        profileState.user.votesUsable.toString();

                    User adminUser = state.user!;
                    return ListView(
                      children: [
                        VoteView(
                            voteUser: adminUser,
                            imageUrlIndex: 0,
                            waves: [],
                            user: profileState.user),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  FirestoreRepository().setPup(adminUser);
                                },
                                child: Text('Make a pup')),
                            ElevatedButton(
                                onPressed: () {
                                  FirestoreRepository().disablePup(adminUser);
                                },
                                child: Text('Remove a pup')),
                            ElevatedButton(
                                onPressed: () {
                                  FirestoreRepository().deleteUser(adminUser);
                                  FirestoreRepository()
                                      .deleteWaves(adminUser.id!);
                                  FirestoreRepository()
                                      .deleteDiscoveryChats(adminUser.id!);
                                },
                                child: Text('Delete user')),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BanDialog(user: adminUser);
                                      });
                                },
                                child: Text('Ban')),
                            ElevatedButton(
                                onPressed: () {
                                  FirestoreRepository().unban(adminUser);
                                },
                                child: Text('Unban')),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).backgroundColor,
                                ]),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Colors.transparent,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AdminPopup(
                                        user: profileState.user,
                                        voteTarget: adminUser,
                                        votesUsable: profileState
                                            .user.votesUsable
                                            .toString(),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  child: const Text('Admin!'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Text('bruh');
                }));
              }
              return Text('check');
            },
          )),
    );
  }
}

//create a stateful widget, banDialog, that takes in a user and a context. It has a text editing controller, and a relevant text field for the ban reason. It should have a local variable, bannedUntil, which can be selected by multiple buttons. One for a day, one for a week, one for a month, and one for a year. It should also have a button to ban the user, and a button to cancel. The ban button should call the ban function in the firestore repository, and the cancel button should just pop the dialog.
class BanDialog extends StatefulWidget {
  final User user;
  BanDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<BanDialog> createState() => _BanDialogState();
}

class _BanDialogState extends State<BanDialog> {
  DateTime bannedUntil = DateTime.now();
  TextEditingController banReasonController = TextEditingController();

  dispose() {
    banReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ban User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Ban Reason'),
          TextField(
            controller: banReasonController,
          ),
          Text('Ban Length'),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bannedUntil = DateTime.now().add(Duration(days: 1));
                    });
                  },
                  child: Text('Day')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bannedUntil = DateTime.now().add(Duration(days: 7));
                    });
                  },
                  child: Text('Week')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bannedUntil = DateTime.now().add(Duration(days: 30));
                    });
                  },
                  child: Text('Month')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bannedUntil = DateTime.now().add(Duration(days: 365));
                    });
                  },
                  child: Text('Year')),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  bannedUntil = DateTime.now().add(Duration(days: 9999));
                });
              },
              child: Text('Not until your death')),
          Row(
            children: [
              ElevatedButton(

                  //red color

                  onPressed: () {
                    FirestoreRepository().ban(
                        widget.user, banReasonController.text, bannedUntil);
                    Navigator.pop(context);
                  },
                  child: Text('Ban')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          )
        ],
      ),
    );
  }
}

class AdminPopup extends StatelessWidget {
  const AdminPopup({
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
            ElevatedButton(
                onPressed: () {
                  FirestoreRepository().addStingray(
                      Stingray.generateStingrayFromUser(voteTarget));
                  Navigator.pop(context);
                },
                child: Text('Make a Stingray')),
            ElevatedButton(
                onPressed: () {
                  FirestoreRepository().deleteStingray(voteTarget);
                  Navigator.pop(context);
                },
                child: Text('Delete a stingray')),
            // ElevatedButton(
            //     onPressed: () {
            //       FirestoreRepository()
            //           .deleteViewer('PuCniGiPW1WfSYjyONErU5BVKga2');
            //       Navigator.pop(context);
            //     },
            //     child: Text('Delete a viewer')),
          ],
        ),
      ),
    );
  }
}
