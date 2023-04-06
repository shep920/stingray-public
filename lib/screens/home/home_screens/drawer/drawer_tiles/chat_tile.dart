import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'package:hero/blocs/discovery_chat_pending/discovery_chat_pending_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //set the color of the backgrond of the listtile to scaffoldBackgroundColor

      leading: //if user.newMessages is true, then show a red dot
          (user.newMessages)
              ? Stack(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        color: Theme.of(context).colorScheme.primary),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                    )
                  ],
                )
              : Icon(Icons.chat_bubble_outline,
                  color: Theme.of(context).colorScheme.primary),
      title: Text('Chats', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        if (user.newMessages) {
          FirestoreRepository().setNewMessages(user.id!, false);

          if (BlocProvider.of<DiscoveryChatBloc>(context, listen: false).state
              is DiscoveryChatLoaded) {
            BlocProvider.of<DiscoveryChatBloc>(context)
                .add(RefreshLoads(user: user, context: context));
          }
          if (BlocProvider.of<DiscoveryChatPendingBloc>(context, listen: false)
              .state is DiscoveryChatPendingLoaded) {
            BlocProvider.of<DiscoveryChatPendingBloc>(context)
                .add(RefreshPendingLoads(user: user, context: context));
          }
          if (BlocProvider.of<DiscoveryChatJudgeableBloc>(context,
                  listen: false)
              .state is DiscoveryChatJudgeableLoaded) {
            BlocProvider.of<DiscoveryChatJudgeableBloc>(context)
                .add(RefreshJudgeableLoads(user: user, context: context));
          }
        }
        Navigator.pushNamed(context, '/discoveryChats');
      },
    );
  }
}
