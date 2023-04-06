import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/discovery_chat_pending/discovery_chat_pending_bloc.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_messages_screen.dart';
import 'package:hero/screens/home/home_screens/discovery/widgets/chat_tile.dart';
//timeago
import 'package:timeago/timeago.dart' as timeago;
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/widgets/receiver_message.dart';
import 'package:hero/widgets/sent_message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'package:hero/blocs/comment/comment_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/cubits/comment/comment_cubit.dart';
import 'package:hero/models/models.dart';
import 'package:hero/screens/home/home_screens/stingray_chats/comments_screen.dart';
import 'package:hero/widgets/widgets.dart';

import '../../../../blocs/chat/chat_bloc.dart';
import '../../../../blocs/discovery_chat/discovery_chat_bloc.dart';
import '../../../../blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import '../../../../blocs/discovery_messages/discovery_message_bloc.dart';

import '../../../../blocs/message/message_bloc.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../models/discovery_message_model.dart';

import '../../../../models/report_model.dart';
import '../../../../repository/firestore_repository.dart';
import '../../../../widgets/receiver_discovery_message.dart';
import '../../../../widgets/sent_discovery_message.dart';

class DiscoveryChatsScreen extends StatefulWidget {
  static const String routeName = '/discoveryChats';

  DiscoveryChatsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => DiscoveryChatsScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<DiscoveryChatsScreen> createState() => _DiscoveryChatsScreenState();
}

class _DiscoveryChatsScreenState extends State<DiscoveryChatsScreen> {
  late ScrollController _chatsScrollController;
  late ScrollController _pendingScrollController;
  late ScrollController _judgeableScrollController;
  @override
  void initState() {
    _chatsScrollController = ScrollController();
    _pendingScrollController = ScrollController();
    _judgeableScrollController = ScrollController();
    _chatsScrollController.addListener(() {
      if (_chatsScrollController.position.pixels >=
          _chatsScrollController.position.maxScrollExtent * .95) {
        final chatLoaded =
            (BlocProvider.of<DiscoveryChatBloc>(context, listen: false).state
                as DiscoveryChatLoaded);

        if (chatLoaded.chatHasMore && !chatLoaded.chatLoading) {
          String userId = (BlocProvider.of<ProfileBloc>(context, listen: false)
                  .state as ProfileLoaded)
              .user
              .id!;

          BlocProvider.of<DiscoveryChatBloc>(context, listen: false)
              .add(PaginateChats(userId: userId, context: context));
        }
      }
    });
    _pendingScrollController.addListener(() {
      if (_pendingScrollController.position.pixels >=
          _pendingScrollController.position.maxScrollExtent * .85) {
        //get the chatloaded state from blocProvider
        final chatLoaded =
            (BlocProvider.of<DiscoveryChatPendingBloc>(context, listen: false)
                .state as DiscoveryChatPendingLoaded);

        //get the user id from blocprovider

        if (chatLoaded.pendingHasMore && !chatLoaded.pendingLoading) {
          User user = (BlocProvider.of<ProfileBloc>(context, listen: false)
                  .state as ProfileLoaded)
              .user;
          //add the pagination event
          BlocProvider.of<DiscoveryChatPendingBloc>(context, listen: false)
              .add(PaginatePending(user: user, context: context));
        }
      }
    });

    _judgeableScrollController.addListener(() {
      if (_judgeableScrollController.position.pixels >=
          _judgeableScrollController.position.maxScrollExtent * .85) {
        //get the chatloaded state from blocProvider
        final judgeableChatLoaded =
            (BlocProvider.of<DiscoveryChatJudgeableBloc>(context, listen: false)
                .state as DiscoveryChatJudgeableLoaded);

        //get the user id from blocprovider

        if (judgeableChatLoaded.judgeableHasMore &&
            !judgeableChatLoaded.judgeableLoading) {
          User user = (BlocProvider.of<ProfileBloc>(context, listen: false)
                  .state as ProfileLoaded)
              .user;
          //add the pagination event
          BlocProvider.of<DiscoveryChatJudgeableBloc>(context, listen: false)
              .add(PaginateJudgeableChats(user: user, context: context));
        }
      }
    });

    User _user = (BlocProvider.of<ProfileBloc>(context, listen: false).state
            as ProfileLoaded)
        .user;

    super.initState();
  }

  void dispose() {
    _chatsScrollController.dispose();
    _pendingScrollController.dispose();
    _judgeableScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryChatBloc, DiscoveryChatState>(
      builder: (context, chatState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
          if (profileState is ProfileLoading)
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          if (profileState is ProfileLoaded) {
            User user = profileState.user;

            if (chatState is DiscoveryChatLoading) {
              BlocProvider.of<DiscoveryChatBloc>(context)
                  .add(LoadDiscoveryChat(user: user, context: context));
              BlocProvider.of<DiscoveryChatPendingBloc>(context)
                  .add(LoadDiscoveryChatPending(user: user, context: context));
              return Scaffold(
                body: Center(
                  child: Text('Loading...'),
                ),
              );
            }
            if (chatState is DiscoveryChatLoaded) {
              List<DiscoveryChat?> chats = chatState.chats;

              List<User?> userPool = chatState.userPool;

              return Scaffold(
                appBar: TopAppBar(
                  showChats: false,
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    refresh(context, user);
                  },
                  child: ListView(
                    physics: //auto scroll physics
                        AlwaysScrollableScrollPhysics(),
                    //make it so the listview is scrollable when the screen is small
                    shrinkWrap: true,
                    controller: _chatsScrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the text to the left
                          children: [
                            //make an elevated button that, when pressed, generates a DiscoveryChat object and sends it through firestore

                            BlocBuilder<DiscoveryChatJudgeableBloc,
                                DiscoveryChatJudgeableState>(
                              builder: (context, judgeableState) {
                                if (judgeableState
                                    is DiscoveryChatJudgeableLoading) {
                                  BlocProvider.of<DiscoveryChatJudgeableBloc>(
                                          context)
                                      .add(LoadDiscoveryChatJudgeable(
                                          user: user, context: context));
                                  return Center(child: Container());
                                }
                                if (judgeableState
                                    is DiscoveryChatJudgeableLoaded) {
                                  List<DiscoveryChat?> judgeableChats =
                                      judgeableState.judgeableChats;
                                  List<User?> judgeableUserPool =
                                      judgeableState.userPool;
                                  return (judgeableChats.isNotEmpty)
                                      ? Text('Waiting for you to judge',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3)
                                      : SizedBox.shrink();
                                }
                                return Center(child: Container());
                              },
                            ),

                            buildJudgeable(user),

                            SizedBox(height: 10),

                            BlocBuilder<DiscoveryChatPendingBloc,
                                DiscoveryChatPendingState>(
                              builder: (context, pendingState) {
                                if (pendingState
                                    is DiscoveryChatPendingLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (pendingState
                                    is DiscoveryChatPendingLoaded) {
                                  List<DiscoveryChat?> pendingChats =
                                      pendingState.pending;

                                  List<User?> pendingUserPool =
                                      pendingState.userPool;
                                  return (pendingChats.isNotEmpty)
                                      ? Text('Pending',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3)
                                      : SizedBox.shrink();
                                }
                                return Center(child: Container());
                              },
                            ),

                            buildPending(user),
                            if (chats.isEmpty) buildEmptyView(context),

                            if (chats.isNotEmpty)
                              Text(
                                'Messages',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            if (chats.isNotEmpty)
                              buildChatsList(chats, userPool, user),
                            if (chatState.chatLoading)
                              Center(child: CircularProgressIndicator()),
                            //elevated button that creates a dummy DiscoveryChat object with pending as false and the sender id being the current user's id
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return Text('bruhhhhh');
        });
      },
    );
  }

  ListView buildChatsList(
      List<DiscoveryChat?> chats, List<User?> userPool, User user) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int chatIndex) {
          final DiscoveryChat chat = chats[chatIndex]!;

          User? chatUser = userPool.firstWhereOrNull((user) =>
              user!.id == chat.receiverId || user.id == chat.senderId);

          bool seen = !chat.seenBy.contains(user.id!);

          return InkWell(
            child: ChatTile(chat: chat, user: chatUser!, seen: seen),
            onTap: () {
              viewDiscoveryChat(
                  localUser: user,
                  chat: chat,
                  context: context,
                  matchedUser: chatUser);
            },
          );
        });
  }

  Column buildEmptyView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'You have no chats yet',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        SizedBox(height: 20),
        //icon of a frown
        Icon(
          Icons.sentiment_dissatisfied,
          size: 100,
        ),
      ],
    );
  }

  BlocBuilder<DiscoveryChatPendingBloc, DiscoveryChatPendingState> buildPending(
      User user) {
    return BlocBuilder<DiscoveryChatPendingBloc, DiscoveryChatPendingState>(
        builder: (context, pendingState) {
      if (pendingState is DiscoveryChatPendingLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (pendingState is DiscoveryChatPendingLoaded) {
        List<DiscoveryChat?> pendingChats = pendingState.pending;

        List<User?> pendingUserPool = pendingState.userPool;

        return (pendingChats.isNotEmpty)
            ? SizedBox(
                height: 100,
                child: ListView.builder(
                    physics: //auto scroll physics
                        AlwaysScrollableScrollPhysics(),
                    controller: _pendingScrollController,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: pendingChats.length,
                    itemBuilder: (context, index) {
                      DiscoveryChat pendingChat = pendingChats[index]!;
                      User pendingUser = pendingUserPool.firstWhere(
                          (user) => user!.id == pendingChat.receiverId)!;
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              viewDiscoveryChat(
                                  localUser: user,
                                  chat: pendingChat,
                                  context: context,
                                  matchedUser: pendingUser);
                            },
                            child: UserImage.small(
                              margin: const EdgeInsets.only(top: 10, right: 10),
                              height: 70,
                              width: 70,
                              url: pendingUser.imageUrls[0],
                            ),
                          ),
                          Text(
                            pendingUser.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      );
                    }),
              )
            : SizedBox.shrink();
      }
      return Container();
    });
  }

  BlocBuilder<DiscoveryChatJudgeableBloc, DiscoveryChatJudgeableState>
      buildJudgeable(User user) {
    return BlocBuilder<DiscoveryChatJudgeableBloc, DiscoveryChatJudgeableState>(
        builder: (context, judgeableState) {
      if (judgeableState is DiscoveryChatJudgeableLoading) {
        BlocProvider.of<DiscoveryChatJudgeableBloc>(context)
            .add(LoadDiscoveryChatJudgeable(user: user, context: context));
        return Center(child: Container());
      }
      if (judgeableState is DiscoveryChatJudgeableLoaded) {
        List<DiscoveryChat?> judgeableChats = judgeableState.judgeableChats;
        List<User?> judgeableUserPool = judgeableState.userPool;

        return (judgeableChats.isNotEmpty)
            ? SizedBox(
                height: 100,
                child: ListView.builder(
                    controller: _judgeableScrollController,
                    physics: //auto scroll physics
                        AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: judgeableChats.length,
                    itemBuilder: (context, index) {
                      DiscoveryChat? judgeableChat = judgeableChats[index];
                      User? judgeableUser = judgeableUserPool.firstWhereOrNull(
                          (user) =>
                              user!.id == judgeableChat!.receiverId ||
                              user.id == judgeableChat.senderId);

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              viewDiscoveryChat(
                                  localUser: user,
                                  chat: judgeableChat!,
                                  context: context,
                                  matchedUser: judgeableUser!);
                            },
                            child: UserImage.small(
                              margin: const EdgeInsets.only(top: 10, right: 10),
                              height: 70,
                              width: 70,
                              url: judgeableUser!.imageUrls[0],
                            ),
                          ),
                          Text(
                            judgeableUser.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ],
                      );
                    }))
            : //sized box shrink
            SizedBox.shrink();
      }
      return Center(child: CircularProgressIndicator());
    });
  }

  void refresh(BuildContext context, User user) {
    BlocProvider.of<DiscoveryChatBloc>(context)
        .add(RefreshLoads(user: user, context: context));
    BlocProvider.of<DiscoveryChatPendingBloc>(context)
        .add(RefreshPendingLoads(user: user, context: context));
    BlocProvider.of<DiscoveryChatJudgeableBloc>(context)
        .add(RefreshJudgeableLoads(user: user, context: context));
  }
}

class DebugMakeChatButton extends StatelessWidget {
  const DebugMakeChatButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          DiscoveryChat chat = DiscoveryChat.genericDiscoveryChat(
            senderId: 'EP8G9hmWTocwEQIwkllwowLiBAR2',
            chatId: Uuid().v4(),
            lastMessageSentDateTime: DateTime.now(),
            lastMessageSent: 'Hello',
            receiverId: '16m1SP25UQSoMDxRj9bhtbFmkfv2',
            pending: false,
          );

          FirestoreRepository().initializeDiscoveryChats(chat);
        },
        child: Text('Generate Chat'));
  }
}

void viewDiscoveryChat({
  required DiscoveryChat chat,
  required BuildContext context,
  required User matchedUser,
  required User localUser,
}) {
  Provider.of<DiscoveryMessageBloc>(context, listen: false)
      .add(LoadDiscoveryMessage(chatId: chat.chatId, matchedUser: matchedUser));

  if (!chat.seenBy.contains(localUser.id)) {
    Provider.of<DiscoveryChatBloc>(context, listen: false)
        .add(ViewDiscoveryChat(context: context, chat: chat, user: localUser));
  }

  Navigator.pushNamed(context, DiscoveryMessagesScreen.routeName,
      arguments: null);
}
