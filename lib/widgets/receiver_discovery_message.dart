import 'dart:math' as math; // import this

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/screens/home/home_screens/views/photo_view/photo_view.dart';
import 'package:hero/widgets/custome_like_button.dart';
import 'package:hero/widgets/text_splitter.dart';
import 'package:hero/widgets/triangle.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../blocs/comment/comment_bloc.dart';
import '../models/models.dart';
import '../repository/firestore_repository.dart';
import '../screens/home/home_screens/stingray_chats/comments_screen.dart';
import '../screens/home/home_screens/stingray_chats/stingray_messages_screen.dart';

class ReceivedDiscoveryMessage extends StatelessWidget {
  final DiscoveryMessage message;

  const ReceivedDiscoveryMessage({
    Key? key,
    required this.message,
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
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.imageUrl != '')
                  //a cached image with a rect container
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyPhotoView.routeName,
                        arguments: {
                          'imageUrl': message.imageUrl,
                        },
                      );
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(message.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (message.message != '')
                  Padding(
                    padding:
                        EdgeInsets.only(top: (message.imageUrl == '') ? 0 : 20),
                    child: TextSplitter(
                      message.message,
                      context,
                      TextStyle(
                          color: Colors.black,
                          fontFamily: 'Monstserrat',
                          fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
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
