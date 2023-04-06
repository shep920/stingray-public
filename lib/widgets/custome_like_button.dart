import 'package:flutter/material.dart';
import 'package:hero/blocs/message/message_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../repository/firestore_repository.dart';

class CustomLikeButton extends StatefulWidget {
  const CustomLikeButton({
    Key? key,
    required this.message,
    required this.user,
    required this.stingray,
    required this.liked,
  }) : super(key: key);

  final Message message;
  final User user;
  final Stingray? stingray;
  final bool liked;

  @override
  State<CustomLikeButton> createState() => _CustomLikeButtonState();
}

class _CustomLikeButtonState extends State<CustomLikeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        child: LikeButton(
          likeCount:
              (widget.liked) ? widget.message.likes + 1 : widget.message.likes,
          isLiked: (widget.liked)
              ? true
              : (widget.message.userIdsWhoLiked.contains(widget.user.id))
                  ? true
                  : false,
          onTap: (isLiked) async {
            

            (isLiked)
                ? Provider.of<MessageBloc>(context, listen: false)
                    .add(UnlikeMessage(message: widget.message))
                : Provider.of<MessageBloc>(context, listen: false)
                    .add(LikeMessage(message: widget.message));

            return !isLiked;
          },
        ));
  }
}
