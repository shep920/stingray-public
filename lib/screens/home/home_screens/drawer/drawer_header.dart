import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/onboarding/onboarding_screen.dart';
import 'package:hero/screens/profile/profile_screen.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: DrawerHeader(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!user.finishedOnboarding)
              Expanded(
                child: Center(
                    child: ElevatedButton(
                  onPressed: () => Navigator.popAndPushNamed(
                      context, OnboardingScreen.routeName,
                      arguments: user),
                  child: Text('Make your profile',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).dividerColor,
                          )),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline5),
                )),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (user.finishedOnboarding)
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProfileScreen.routeName);
                          },
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                  user.imageUrls[0])),
                        ),
                        //an iconbutton of an bell, and if user.hasNewNotification, then show a red dot
                        IconButton(
                          icon: (user.newNotifications)
                              ? Stack(
                                  children: [
                                    Icon(
                                      Icons.notifications_outlined,
                                      size: 50,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle),
                                      ),
                                    )
                                  ],
                                )
                              : Icon(Icons.notifications_outlined,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            if (user.newNotifications) {
                              FirestoreRepository()
                                  .setNewNotifications(user.id!, false);
                            }
                            Navigator.pushNamed(context, '/notifications');
                          },
                        ),
                      ],
                    )
                  : Container(),
            ),
            //text to show the user's name
            if (user.finishedOnboarding)
              Text(user.name, style: Theme.of(context).textTheme.headline3),
            if (user.finishedOnboarding)
              Text(user.handle, style: Theme.of(context).textTheme.headline4),

            //richtext that says 'votes' and the number of votes
            if (user.finishedOnboarding)
              RichText(
                text: TextSpan(
                  text: 'Votes: ',
                  style: Theme.of(context).textTheme.headline5,
                  children: <TextSpan>[
                    TextSpan(
                        text: user.votes.toString(),
                        style: Theme.of(context).textTheme.headline5!),
                  ],
                ),
              ),

            Row(
              children: [
                InkWell(
                  onTap: () {
                    GenericAwesomeDialog.showDialog(
                            context: context,
                            title: 'Voting',
                            description:
                                'Votes help pick minnows to become weekly Stingrays! You get two daily votes for cool minnows. On Sundays at 10:05 pm, top minnows turn into Stingrays. Join the fun and vote for your favorites!')
                        .show();
                  },
                  child: Icon(
                    Icons.info_outline,
                    size: 25,
                    color: Theme.of(context).textTheme.headline5!.color,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Votes left today: ',
                    style: Theme.of(context).textTheme.headline5,
                    children: <TextSpan>[
                      TextSpan(
                          text: user.votesUsable.toString(),
                          style: Theme.of(context).textTheme.headline5!),
                    ],
                  ),
                ),
                //inkwell with an info icon
              ],
            ),
          ],
        ),
      ),
    );
  }
}
