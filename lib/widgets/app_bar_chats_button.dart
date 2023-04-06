import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'package:hero/blocs/discovery_chat_pending/discovery_chat_pending_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';

class AppBarChatsButton extends StatelessWidget {
  const AppBarChatsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: (user.newMessages)
                  ? Stack(
                      children: [
                        _chatIcon(context, user),
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
                  : _chatIcon(context, user));
        }
        return Container();
      },
    );
  }

  IconButton _chatIcon(BuildContext context, User user) {
    return IconButton(
        icon: Icon(Icons.chat_bubble_outline, size: 30),
        onPressed: () {
          if (user.newMessages) {
            FirestoreRepository().setNewMessages(user.id!, false);

            if (BlocProvider.of<DiscoveryChatBloc>(context, listen: false).state
                is DiscoveryChatLoaded) {
              BlocProvider.of<DiscoveryChatBloc>(context)
                  .add(RefreshLoads(user: user, context: context));
            }
            if (BlocProvider.of<DiscoveryChatPendingBloc>(context,
                    listen: false)
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
        color: Theme.of(context).colorScheme.primary);
  }
}
