import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
//import timeago package
import 'package:timeago/timeago.dart' as timeago;

class ChatTile extends StatelessWidget {
  final User user;
  final DiscoveryChat chat;
  final bool seen;

  ChatTile({
    required this.user,
    required this.chat,
    required this.seen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: InkWell(
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.imageUrls[0]),
                radius: 30.0,
              ),
              onTap: () {
                BlocProvider.of<VoteBloc>(context)
                    .add(LoadUserEvent(user: user));
                Navigator.pushNamed(
                  context,
                  VoteScreen.routeName,
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          chat.lastMessageSent!,
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.grey,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10),
                        child: Text(
                          '• ${timeago.format(chat.lastMessageSentDateTime!, locale: 'en_short')}',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //flexible timeago text

          if (seen)
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: ExtraColors.highlightColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
