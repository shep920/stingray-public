import 'dart:math' as math; // import this

import 'package:flutter/material.dart';
import 'package:hero/widgets/custome_like_button.dart';
import 'package:hero/widgets/triangle.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../blocs/comment/comment_bloc.dart';
import '../models/models.dart';
import '../repository/firestore_repository.dart';
import '../screens/home/home_screens/stingray_chats/comments_screen.dart';
import '../screens/home/home_screens/stingray_chats/stingray_messages_screen.dart';

class ReceivedMessage extends StatelessWidget {
  final List<Message?> messages;
  final Message message;
  final User user;
  final Stingray? stingray;
  final bool liked;
  
  final Chat chat;

  const ReceivedMessage({
    Key? key,
    required this.message,
    required this.user,
    required this.stingray,
    required this.messages,
    
    required this.chat,
    required this.liked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: Triangle(Colors.grey[300]),
          ),
        ),
        Flexible(
          child: InkWell(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                        color: Colors.black,
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
                          message: message, chat: chat));
                  Navigator.pushNamed(
                    context,
                    '/comments',
                  );
                },
              ),
              SizedBox(
                height: 7,
              ),
              Text(message.commentCount.toString()),
            ],
          ),
        ),
        CustomLikeButton(
          
          message: message,
          
          
          user: user,
          stingray: stingray,
          liked: liked,
        ),
      ],
    ));

    return Padding(
      padding: EdgeInsets.only(right: 50.0, left: 18, top: 5, bottom: 5),
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
