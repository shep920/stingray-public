import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../../blocs/message/message_bloc.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../models/report_model.dart';
import '../../../../repository/firestore_repository.dart';

class StingrayMessagesScreen extends StatelessWidget {
  static const String routeName = '/stingrayMessages';

  StingrayMessagesScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => StingrayMessagesScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StingrayBloc, StingrayState>(
      builder: (context, state) {
        if (state is StingrayLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is StingrayLoaded) {
          return BlocBuilder<MessageBloc, MessageState>(
            builder: (context, messageState) {
              if (messageState is MessageLoading)
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              if (messageState is MessageLoaded) {
                Stingray? stingray = state.stingrays.firstWhere((stingray) =>
                    stingray!.id == messageState.chat!.stingrayId);

                User matchedUser = messageState.matchedUser;
                Chat? chat = messageState.chat;
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
                    String otherUserName = (user.id == chat!.matchedUserId)
                        ? stingray!.name
                        : matchedUser.name;
                    return WillPopScope(
                      onWillPop: () async {
                        context
                            .read<MessageBloc>()
                            .add(CloseMessage(userId: user.id!));
                        context
                            .read<ChatBloc>()
                            .add(LoadChat(sortOrder: 'Recent'));
                        return true;
                      },
                      child: Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            title: (messageState.chat == null)
                                ? Container()
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Provider.of<VoteBloc>(
                                                              context,
                                                              listen: false)
                                                          .add(
                                                              LoadUserFromFirestore(
                                                                  stingray!
                                                                      .id));
                                                      Navigator.pushNamed(
                                                          context, '/votes');
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                           CachedNetworkImageProvider(
                                                              stingray!
                                                                  .imageUrls[0])
                                                          
                                                    ),
                                                  ),
                                                  Text(stingray.name),
                                                ],
                                              ),
                                            ),
                                            Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Provider.of<VoteBloc>(
                                                              context,
                                                              listen: false)
                                                          .add(LoadUserEvent(
                                                              user:
                                                                  matchedUser));
                                                      Navigator.pushNamed(
                                                          context, '/votes');
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundImage: 
                                                           CachedNetworkImageProvider(chat
                                                              .matchedUserImageUrl!)
                                                          
                                                    ),
                                                  ),
                                                  Text(chat.matchedUserName!),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        //make a PopupMenuButton for the options 'ban user', 'report user', 'block user'
                                        child: PopupMenuButton(
                                          iconSize: 50,
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.black,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'unblock user') {
                                              //show alert dialog to confirm unblocking user
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text('Unblock User'),
                                                    content: Text(
                                                        'Are you sure you want to unblock ${chat.matchedUserName}?'),
                                                    actions: [
                                                      ElevatedButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child: Text('Unblock'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          BlocProvider.of<
                                                                      MessageBloc>(
                                                                  context)
                                                              .add(UnblockUser(
                                                                  blocker: user,
                                                                  stingray:
                                                                      stingray));
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                            if (value == 'block user') {
                                              //show alert dialog to confirm ban
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Block User',
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to block ${matchedUser.name}?\n\nThis will prevent you from sending them messages and vice versa. However, the chat will remain visible, and you will be able to reverse this decision at any time.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text(
                                                          'Cancel',
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'Block',
                                                        ),
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      MessageBloc>(
                                                                  context)
                                                              .add(BlockUser(
                                                                  blocker: user,
                                                                  stingray:
                                                                      stingray));
                                                          Navigator.of(context)
                                                              .pop();

                                                          // BlocProvider.of<
                                                          //             ProfileBloc>(
                                                          //         context)
                                                          //     .add(ProfileBlockUser(
                                                          //         user.id));
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (value == 'report chat') {
                                              //show alert dialog to confirm report with a text field for the reason
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ReportDialog(
                                                      chat: chat,
                                                      stingray: stingray,
                                                      user: user);
                                                },
                                              );
                                            } else if (value == 'remove chat') {
                                              //show alert dialog to confirm removing the chat
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Remove Chat',
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to remove this chat?\n\nThis is a permanent decision, it will remove the chat, along with all messages and comments, and cannot be undone.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text(
                                                          'Cancel',
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'Remove',
                                                        ),
                                                        onPressed: () {
                                                          FirestoreRepository()
                                                              .removeStingrayChat(
                                                                  chat,
                                                                  stingray);
                                                          Navigator
                                                              .popAndPushNamed(
                                                                  context,
                                                                  '/mainPage');
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'report chat',
                                              child: Text('Report Chat'),
                                            ),
                                            if ((user.id == matchedUser.id ||
                                                    user.id == stingray.id) &&
                                                !messageState.blocked)
                                              PopupMenuItem(
                                                value: 'block user',
                                                child: Text('Block '),
                                              ),
                                            if ((user.id == matchedUser.id ||
                                                    user.id == stingray.id) &&
                                                messageState.blockerId ==
                                                    user.id)
                                              PopupMenuItem(
                                                value: 'unblock user',
                                                child: Text('Unblock '),
                                              ),
                                            if (user.id == matchedUser.id ||
                                                user.id == stingray.id)
                                              PopupMenuItem(
                                                value: 'remove chat',
                                                child: Text('Remove chat'),
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          body: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemCount: messageState.messages.length,
                                  itemBuilder: (context, index) {
                                    Message? message =
                                        messageState.messages[index];

                                    return (message!.senderId != stingray!.id)
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: SentMessage(
                                              chat: messageState.chat!,
                                              message: message,
                                              user: user,
                                              stingray: stingray,
                                              key: key,
                                              messages: messageState.messages,
                                              liked: (messageState
                                                      .messageIdsLiked
                                                      .contains(message.id))
                                                  ? true
                                                  : false,
                                            ),
                                          )
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: ReceivedMessage(
                                              message: message,
                                              user: user,
                                              chat: messageState.chat!,
                                              stingray: stingray,
                                              key: key,
                                              messages: messageState.messages,
                                              liked: (messageState
                                                      .messageIdsLiked
                                                      .contains(message.id))
                                                  ? true
                                                  : false,
                                            ),
                                          );
                                  },
                                ),
                              ),
                              if (messageState.blocked)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      '!!!This chat has been blocked by ${messageState.blockerName}!!!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              if ((user.id == stingray!.id ||
                                      user.id ==
                                          messageState.chat!.matchedUserId) &&
                                  !messageState.blocked)
                                MessageForm(
                                  stingray: //stingray where the stingray.id is the same as the stingrayId in the chat
                                      state.stingrays.firstWhere((element) =>
                                          element!.id ==
                                          messageState.chat!.stingrayId),
                                  user: profileState.user,
                                  chatId: messageState.chat!.chatId,
                                  matchedUserId:
                                      messageState.chat!.matchedUserId,
                                  matchedUserImageUrl:
                                      messageState.matchedUserImageUrl,
                                )
                            ],
                          )),
                    );
                  }
                  return Text('bruhhhhh');
                });
              }
              return Text('help meeeeeeeeee');
            },
          );
        }
        return Text('uh. no');
      },
    );
  }
}

class ReportDialog extends StatefulWidget {
  const ReportDialog({
    Key? key,
    required this.chat,
    required this.stingray,
    required this.user,
  }) : super(key: key);

  final Chat? chat;
  final Stingray? stingray;
  final User user;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Report Chat',
      ),
      content: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(200),
        ],
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Reason',
        ),
        onChanged: (value) {},
      ),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Report',
          ),
          onPressed: () {
            if (_textController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a reason')));
            } else {
              final Report report = Report(
                reason: _textController.text,
                type: 'chat report',
                stingray: widget.stingray,
                reportId: Uuid().v4(),
                reporterUser: widget.user,
                reportTime: DateTime.now(),
                chat: widget.chat,
              );
              FirestoreRepository.sendReport(report);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class MessageForm extends StatefulWidget {
  final Stingray? stingray;
  final User user;
  String? chatId;
  String? matchedUserId;
  String? matchedUserImageUrl;

  MessageForm(
      {Key? key,
      required this.user,
      required this.stingray,
      this.matchedUserId,
      this.matchedUserImageUrl,
      required this.chatId})
      : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: UserImagesSmall(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .2,
              imageUrl: widget.user.imageUrls[0]),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.8, vertical: 0),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              minLines: null,
              textInputAction: TextInputAction.send,
              maxLines: null,
              expands: true,
              textCapitalization: TextCapitalization.sentences,
              controller: messageController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add a message...',
                  contentPadding: EdgeInsets.all(5.0)),
              onSubmitted: (text) {
                makeMessage(widget.chatId!);
              },
            ),
          ),
          width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.height * .08,
        ),
        Container(
          child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                makeMessage(widget.chatId!);
              }),
          width: MediaQuery.of(context).size.width * .1,
          height: MediaQuery.of(context).size.height * .08,
        )
      ],
    );
  }

  void makeMessage(String chatId) {
    String? receiverId = (widget.user.id == widget.stingray!.id)
        ? widget.matchedUserId
        : widget.stingray!.id;
    String senderName = (receiverId == widget.user.id)
        ? widget.stingray!.name
        : widget.user.name;
    Message? message = _generateMessage(widget.user, widget.stingray,
        messageController.text, widget.chatId!, receiverId!);
    FirestoreRepository().updateStingrayMessage(
      message,
      widget.stingray!.id,
    );
    FirestoreRepository().updateStingrayChatLastMessage(message,
        widget.stingray!.id, widget.matchedUserId!, widget.user.id!, chatId);
    FirestoreRepository().updateStingrayMessageListener(message, senderName);

    messageController.clear();
  }
}

Message? _generateMessage(User user, Stingray? stingray, String message,
    String chatId, String matchedUserId) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  return Message(
    message: message,
    dateTime: now,
    senderId: user.id,
    likes: 0,
    timeString: formattedDate,
    id: Uuid().v4(),
    chatId: chatId,
    receiverId: matchedUserId,
    commentCount: 0,
    userIdsWhoLiked: [],
  );
}
