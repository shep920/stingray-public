import 'package:flutter/material.dart';
import 'package:hero/blocs/comment/comment_bloc.dart';
import 'package:hero/models/models.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/stingray_chats/stingray_messages_screen.dart';
import 'package:hero/widgets/triangle.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../screens/home/home_screens/stingray_chats/comments_screen.dart';
import 'custome_like_button.dart';

class SentMessage extends StatelessWidget {
  final List<Message?> messages;
  final Message message;
  final User user;
  final Stingray? stingray;
  final Chat chat;
  final bool liked;
  const SentMessage({
    required Key? key,
    required this.chat,
    required this.message,
    required this.user,
    required this.stingray,
    required this.messages,
    required this.liked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLikeButton(
          message: message,
          user: user,
          stingray: stingray,
          liked: liked,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  FirestoreRepository().initializeStingrayComment(
                      chat.chatId, chat.stingrayId, message.id);
                  Provider.of<CommentBloc>(context, listen: false).add(
                      LoadComment(chat.stingrayId,
                          chat: chat, message: message));
                  Navigator.pushNamed(context, '/comments');
                },
              ),
              Text(message.commentCount.toString()),
            ],
          ),
        ),
        Flexible(
          child: InkWell(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Monstserrat',
                        fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  timeago.format(message.dateTime).toString(),
                ),
              ],
            ),
            onTap: () {
              FirestoreRepository().initializeStingrayComment(
                  chat.chatId, chat.stingrayId, message.id);
              Provider.of<CommentBloc>(context, listen: false).add(
                  LoadComment(chat.stingrayId, message: message, chat: chat));
              Navigator.pushNamed(context, '/comments');
            },
          ),
        ),
        CustomPaint(painter: Triangle(Colors.grey[900])),
      ],
    ));

    return Padding(
      padding: EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
