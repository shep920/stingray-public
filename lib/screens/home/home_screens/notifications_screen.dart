//import timeago
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/screens/home/home_screens/views/generic_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/waves_replies_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/models/user_notifications/user_notification_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/widgets.dart';

import '../../../blocs/notifications/notifications_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/vote/vote_bloc.dart';
import '../../../models/user_model.dart';
import '../../../models/user_notifications/user_notification_type.dart';
import 'views/waves/widget/wave_tile.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';
//make a route
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => NotificationsScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      body:
          //make a blocbuilder for profile bloc
          BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          //if the profileState is loading
          if (profileState is ProfileLoading) {
            //return a loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //if the profileState is loaded
          if (profileState is ProfileLoaded) {
            User user = profileState.user;
            //return a listview of notifications
            return BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, notificationState) {
                if (notificationState is NotificationsLoading) {
                  //add the loadNotifications method to the bloc
                  BlocProvider.of<NotificationsBloc>(context)
                      .add(LoadNotificationsEvent(user: user));
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (notificationState is NotificationsLoaded) {
                  // List<UserNotification?> notifications =
                  //     notificationState.notifications;
                  //set notifications sorted so the earliest are on top
                  List<UserNotification?> notifications = notificationState
                      .notifications
                      .where((notification) => notification != null)
                      .toList()
                    ..sort((a, b) => b!.createdAt.compareTo(a!.createdAt));
                  if (notifications.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<NotificationsBloc>(context)
                            .add(LoadNotificationsEvent(user: user));
                      },
                      child: ListView(
                        children: [
                          Text(
                            'You have no notifications',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          //sad icon
                          const Icon(
                            Icons.sentiment_dissatisfied,
                            size: 100,
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<NotificationsBloc>(context)
                          .add(LoadNotificationsEvent(user: user));
                    },
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotification(
                            notifications[index]!, context);
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('Something went wrong'),
                );
              },
            );
          }
          //if the profileState is error

          //return a text widget with the error message
          return const Text('Something went wrong');
        },
      ),
    );
  }

  Widget _buildNotification(
      UserNotification notification, BuildContext context) {
    //make a switch case for if the notification type is a vote, return a vote notification. if the notification is of type mention, return a mention notification.
    switch (notification.type) {
      case UserNotificationType.vote:
        return _buildVoteNotification(notification, context);
      case UserNotificationType.mention:
        return _buildMentionNotification(notification, context);
      case UserNotificationType.reply:
        return _buildReplyNotification(notification, context);

      default:
        return Container();
    }
  }

  //make a function to build a vote notification
  Widget _buildVoteNotification(
      UserNotification notification, BuildContext context) {
    return ListTile(
      //if notifcatuin.image is not null, return a network image, else return a placeholder image
      leading: InkWell(
        child: notification.imageUrl != null
            ? CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(notification.imageUrl!),
              )
            : const CircleAvatar(
                child: Icon(Icons.person),
              ),
        onTap: () {
          BlocProvider.of<VoteBloc>(context).add(LoadVoteUserFromHandle(
              handle: notification.relevantUserHandle!, context: context));
        },
      ),

      title: Text(
        '${notification.relevantUserHandle} voted for you',
        style: Theme.of(context).textTheme.headline5,
      ),
      //set the subtitle to be timeago
      subtitle: Text(timeago.format(notification.createdAt)),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //scaffold background color
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: //if the notification.trailingimageurl is not null, return a cached image. else return an icon like @
              notification.trailingImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: notification.trailingImageUrl!,
                      width: 50,
                      height: 50,
                    )
                  : Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
        ),
      ),
    );
  }

  //make a function to build a mention notification
  Widget _buildMentionNotification(
      UserNotification notification, BuildContext context) {
    return InkWell(
      onTap: () {
        sendToWaveReplies(notification, context);
      },
      child: ListTile(
        //if notifcatuin.image is not null, return a network image, else return a placeholder image
        leading: InkWell(
          child: notification.imageUrl != null
              ? CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(notification.imageUrl!),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: FaIcon(FontAwesomeIcons.fish),
                ),
          onTap: () {
            BlocProvider.of<VoteBloc>(context).add(LoadVoteUserFromHandle(
                handle: notification.relevantUserHandle!, context: context));
          },
        ),

        title: //textspan showing the relevant handle in bold
            RichText(
          text: TextSpan(
            text: '${notification.relevantUserHandle} ',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: 'mentioned you in a Wave: ${notification.message}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),

        trailing: //return a square with rounded corners
            Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //scaffold background color
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: //if the notification.trailingimageurl is not null, return a cached image. else return an icon like @
                notification.trailingImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: notification.trailingImageUrl!,
                        width: 50,
                        height: 50,
                      )
                    : Icon(
                        Icons.alternate_email, //primary color
                        color: Theme.of(context).colorScheme.primary,
                      ),
          ),
        ),

        //set the subtitle to be timeago
        subtitle: Text(timeago.format(notification.createdAt)),
      ),
    );
  }

  void sendToWaveReplies(UserNotification notification, BuildContext context) {
    FirestoreRepository.getStaticWave(notification.relevantWaveId).then((wave) {
      //if the wave is null, navigate to the error screen
      if (wave == null) {
        Navigator.of(context).pushNamed('error');
      }
      //using that wave, get the user using the wave.userId
      FirestoreRepository.getStaticFutureUser(wave!.senderId).then((user) {
        WaveTile waveTile = WaveTile(
          wave: wave,
          poster: (wave.type == Wave.yip_yap_type) ? User.anon(user.id!) : user,
        );

        BlocProvider.of<TrollingPoliceCubit>(context)
            .upDateTrolling(waveTile.wave.id, context, user);
        Map<String, dynamic> _map = {
          'waveTileList': [waveTile],
          'isThread': (waveTile.wave.threadId != null),
        };
        Navigator.pushNamed(context, WaveRepliesScreen.routeName,
            arguments: _map);
      });
    });
  }

  //make a function to build a reply notification
  Widget _buildReplyNotification(
      UserNotification notification, BuildContext context) {
    return InkWell(
      onTap: () {
        sendToWaveReplies(notification, context);
      },
      child: ListTile(
        //if notifcatuin.image is not null, return a network image, else return a placeholder image
        leading: InkWell(
          child: notification.imageUrl != null
              ? CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(notification.imageUrl!),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: FaIcon(FontAwesomeIcons.fish),
                ),
          onTap: () {
            BlocProvider.of<VoteBloc>(context).add(LoadVoteUserFromHandle(
                handle: notification.relevantUserHandle!, context: context));
          },
        ),

        title:
            //textspan where the handle is in bold
            RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${notification.relevantUserHandle} ',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                text: 'replied to your Wave: ${notification.message}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),

        trailing: //return a square with rounded corners
            Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //scaffold background color
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: //if the notification.trailingimageurl is not null, return a cached image. else return an icon like @
                notification.trailingImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: notification.trailingImageUrl!,
                        width: 50,
                        height: 50,
                      )
                    : Icon(
                        Icons.reply, //primary color
                        color: Theme.of(context).colorScheme.primary,
                      ),
          ),
        ),

        //set the subtitle to be timeago
        subtitle: Text(timeago.format(notification.createdAt)),
      ),
    );
  }
}
