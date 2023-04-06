import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/static_data/report_stuff.dart';
import 'package:hero/widgets/dismiss_keyboard.dart';
import 'package:image_picker/image_picker.dart';
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
import '../../../../blocs/discovery_messages/discovery_message_bloc.dart';
import '../../../../blocs/message/message_bloc.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../models/discovery_message_model.dart';
import '../../../../models/report_model.dart';
import '../../../../repository/firestore_repository.dart';
import '../../../../widgets/receiver_discovery_message.dart';
import '../../../../widgets/sent_discovery_message.dart';

class DiscoveryMessagesScreen extends StatelessWidget {
  static const String routeName = '/discoveryMessages';
  final Map<String, dynamic>? map;

  DiscoveryMessagesScreen({Key? key, required this.map}) : super(key: key);

  static Route route({required Map<String, dynamic>? map}) {
    return MaterialPageRoute(
      builder: (_) => DiscoveryMessagesScreen(map: map),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (map != null) {
      BlocProvider.of<DiscoveryMessageBloc>(context).add(
        LoadDiscoveryMessageFromId(
          chatId: map!['chatId'],
          userId: map!['userId'],
        ),
      );
    }
    return BlocBuilder<StingrayBloc, StingrayState>(
      builder: (context, state) {
        if (state is StingrayLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is StingrayLoaded) {
          return BlocBuilder<DiscoveryMessageBloc, DiscoveryMessageState>(
            builder: (context, messageState) {
              if (messageState is DiscoveryMessageLoading) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (messageState is DiscoveryMessageLoaded) {
                User matchedUser = messageState.matchedUser;
                String chatId = messageState.discoveryMessageDocument!.chatId;

                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                  if (profileState is ProfileLoading)
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                  if (profileState is ProfileLoaded) {
                    User user = profileState.user;
                    String judge;
                    (user.id == messageState.discoveryMessageDocument!.judgeId)
                        ? judge = user.name
                        : judge = matchedUser.name;

                    return WillPopScope(
                      onWillPop: () async {
                        Provider.of<DiscoveryMessageBloc>(context,
                                listen: false)
                            .add(const CloseDiscoveryMessage());
                        return true;
                      },
                      child: Scaffold(
                          appBar:
                              buildAppBar(context, matchedUser, chatId, user),
                          body: Column(
                            children: [
                              Expanded(
                                child: DismissKeyboard(
                                  child: ListView.builder(
                                    //remove padding at bottom
                                    padding: const EdgeInsets.only(bottom: 0),
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemCount: messageState
                                        .discoveryMessageDocument!
                                        .messages
                                        .length,
                                    itemBuilder: (context, index) {
                                      DiscoveryMessage? message = messageState
                                          .discoveryMessageDocument!
                                          .messages[index];

                                      return (message!.senderId !=
                                              matchedUser.id)
                                          ? Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                children: [
                                                  SentDiscoveryMessage(
                                                    message: message,
                                                    key: key,
                                                  ),
                                                  if (index ==
                                                          messageState
                                                                  .discoveryMessageDocument!
                                                                  .messages
                                                                  .length -
                                                              1 ||
                                                      messageState
                                                                  .discoveryMessageDocument!
                                                                  .messages[
                                                                      index +
                                                                          1]!
                                                                  .senderId !=
                                                              matchedUser.id &&
                                                          message.dateTime
                                                                  .difference(messageState
                                                                      .discoveryMessageDocument!
                                                                      .messages[
                                                                          index +
                                                                              1]!
                                                                      .dateTime)
                                                                  .inHours >=
                                                              1)
                                                    Text(
                                                      //timeage
                                                      //
                                                      timeago.format(
                                                          message.dateTime),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6!
                                                          .copyWith(
                                                            color: Colors.grey,
                                                          ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                children: [
                                                  ReceivedDiscoveryMessage(
                                                    message: message,
                                                    key: key,
                                                  ),
                                                  if (index ==
                                                          messageState
                                                                  .discoveryMessageDocument!
                                                                  .messages
                                                                  .length -
                                                              1 ||
                                                      messageState
                                                                  .discoveryMessageDocument!
                                                                  .messages[
                                                                      index +
                                                                          1]!
                                                                  .senderId !=
                                                              matchedUser.id
                                                          //and the message date time is at least 1 hour
                                                          &&
                                                          message.dateTime
                                                                  .difference(messageState
                                                                      .discoveryMessageDocument!
                                                                      .messages[
                                                                          index +
                                                                              1]!
                                                                      .dateTime)
                                                                  .inHours >=
                                                              1)
                                                    Text(
                                                      timeago.format(
                                                          message.dateTime),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6!
                                                          .copyWith(
                                                            color: Colors.grey,
                                                          ),
                                                    ),
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ),
                              if (messageState
                                  .discoveryMessageDocument!.pending)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  //set a fun color
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Center(
                                    child: Text(
                                      'Waiting on ${judge}...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              if (messageState
                                          .discoveryMessageDocument!.judgeId ==
                                      user.id &&
                                  messageState
                                      .discoveryMessageDocument!.pending)
                                Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                //blocProvider add a discovery message event AcceptChat
                                                BlocProvider.of<
                                                            DiscoveryMessageBloc>(
                                                        context)
                                                    .add(
                                                  AcceptDiscoveryChat(
                                                      context: context,
                                                      sender: user),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          //icon image button with a color of red and an icon of close
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                BlocProvider.of<
                                                            DiscoveryMessageBloc>(
                                                        context)
                                                    .add(
                                                  RejectDiscoveryChat(
                                                      sender: user,
                                                      context: context),
                                                );
                                                Provider.of<DiscoveryMessageBloc>(
                                                        context,
                                                        listen: false)
                                                    .add(
                                                        const CloseDiscoveryMessage());
                                                Provider.of<DiscoveryChatBloc>(
                                                        context,
                                                        listen: false)
                                                    .add(LoadDiscoveryChat(
                                                        user: user,
                                                        context: context));
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              if (!messageState
                                      .discoveryMessageDocument!.blocked &&
                                  !messageState
                                      .discoveryMessageDocument!.pending)
                                SafeArea(
                                  child: MessageForm(
                                    chatId: chatId,
                                    receiver: matchedUser,
                                    sender: user,
                                  ),
                                )
                            ],
                          )),
                    );
                  }
                  return const Text('bruhhhhh');
                });
              }
              return const Text('help meeeeeeeeee');
            },
          );
        }
        return const Text('uh. no');
      },
    );
  }

  AppBar buildAppBar(
      BuildContext context, User matchedUser, String chatId, User user) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: FaIcon(
          Icons.arrow_back_ios,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Provider.of<DiscoveryMessageBloc>(context, listen: false)
              .add(const CloseDiscoveryMessage());
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<VoteBloc>(context, listen: false)
                            .add(LoadUserEvent(user: matchedUser));
                        Navigator.pushNamed(context, '/votes');
                      },
                      child: CircleAvatar(
                          radius: 20,
                          backgroundImage: CachedNetworkImageProvider(
                              matchedUser.imageUrls[0]!)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            matchedUser.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(matchedUser.handle,
                              style: Theme.of(context).textTheme.headline5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                color: Theme.of(context).accentColor,
              ),
              onSelected: (value) {
                if (value == 'report chat') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ReportDialog(
                        chatId: chatId,
                        user: user,
                        reported: matchedUser,
                      );
                    },
                  );
                } else if (value == 'remove chat') {
                  //show alert dialog to confirm removing the chat
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Remove Chat',
                        ),
                        content: const Text(
                          'Are you sure you want to remove this chat?\n\nThis is a permanent decision, it will remove the chat, along with all messages and comments, and cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Cancel',
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Remove',
                            ),
                            onPressed: () {
                              BlocProvider.of<DiscoveryMessageBloc>(context)
                                  .add(
                                RejectDiscoveryChat(
                                    sender: user, context: context),
                              );
                              Provider.of<DiscoveryMessageBloc>(context,
                                      listen: false)
                                  .add(const CloseDiscoveryMessage());
                              Provider.of<DiscoveryChatBloc>(context,
                                      listen: false)
                                  .add(LoadDiscoveryChat(
                                      user: user, context: context));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'report chat',
                  child: Text('Report Chat'),
                ),
                const PopupMenuItem(
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
    );
  }
}

class ReportDialog extends StatefulWidget {
  const ReportDialog({
    Key? key,
    required this.user,
    required this.chatId,
    required this.reported,
  }) : super(key: key);

  final User user;
  final String chatId;
  final User reported;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Report Chat',
      ),
      content: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(200),
        ],
        controller: _textController,
        decoration: const InputDecoration(
          labelText: 'Reason',
        ),
        onChanged: (value) {},
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Report',
          ),
          onPressed: () {
            if (_textController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a reason')));
            } else {
              final Report report = Report.generateUserReport(
                reason: _textController.text,
                type: ReportStuff.discovery_chat_type,
                chatId: widget.chatId,
                reported: widget.reported,
                reporter: widget.user,
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
  final User sender;
  final User receiver;
  final String chatId;

  MessageForm(
      {Key? key,
      required this.sender,
      required this.receiver,
      required this.chatId})
      : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  late TextEditingController messageController;
  bool hasText = false;
  File? file;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        if (file != null)
          Stack(
            fit: StackFit.loose,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  //rounded corners
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //red x surrounded by a white circle iconbutton in top right corner to remove the image
              Positioned(
                //position it in the middle of the image
                top: 0,
                left: 0,
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      //divider color
                      color: Theme.of(context).dividerColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                  onPressed: () {
                    setState(() {
                      file = null;
                    });
                  },
                ),
              ),
            ],
          ),
        Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            style: Theme.of(context).textTheme.headline5,
            inputFormatters: [
              LengthLimitingTextInputFormatter(500),
            ],
            textInputAction: TextInputAction.send,
            maxLines: null,
            expands: true,
            textCapitalization: TextCapitalization.sentences,
            controller: messageController,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  hasText = false;
                });
              } else {
                setState(() {
                  hasText = true;
                });
              }
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: (hasText || file != null)
                    ? () {
                        makeMessage();
                      }
                    : null,
                padding: const EdgeInsets.all(4),
              ),
              suffixIconColor:
                  (hasText) ? Colors.grey : ExtraColors.highlightColor,
              prefixIcon: IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    File? _file = await PickFile.setImage(
                        source: ImageSource.gallery, context: context);

                    if (_file != null) {
                      setState(() {
                        file = _file;
                      });
                    }
                  },
                  padding: const EdgeInsets.all(4)),
              contentPadding: const EdgeInsets.all(8.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: .50, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              ),
              //make text style match the rest of the app
            ),
            onSubmitted: (text) {
              makeMessage();
            },
          ),
          width: MediaQuery.of(context).size.width,
          height: 50,
        ),
      ],
    );
  }

  Future<void> makeMessage() async {
    String _imaageUrl = '';
    String _id = const Uuid().v4();
    String _message = messageController.text;
    File? _file = file;

    setState(() {
      messageController.clear();
      file = null;
    });

    if (_file != null) {
      await StorageRepository().uploadDiscoveryMessageImage(
          compressedFile: _file, chatId: widget.chatId);
      _imaageUrl = await StorageRepository().getDiscoveryMessageImageUrl(
          chatId: widget.chatId, compressedFile: _file);
    }

    DiscoveryMessage? message = DiscoveryMessage(
      imageUrl: _imaageUrl,
      chatId: widget.chatId,
      receiverId: widget.receiver.id!,
      senderId: widget.sender.id!,
      message: _message,
      dateTime: DateTime.now(),
      id: _id,
    );

    FirestoreRepository().updateDiscoveryMessage(
      message,
    );

    BlocProvider.of<DiscoveryChatBloc>(context).add(AddLocalMessage(
      message: message,
    ));

    FirestoreRepository().updateDiscoveryChatLastMessage(message);
    FirestoreRepository().updateDiscoveryMessageListener(
        widget.sender, widget.receiver, message.message, widget.chatId);
    if (!widget.receiver.newMessages) {
      FirestoreRepository().setNewMessages(widget.receiver.id!, true);
    }

    messageController.clear();
  }
}
