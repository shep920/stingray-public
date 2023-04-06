import 'package:flutter/material.dart';
import 'package:hero/blocs/message/message_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../blocs/comment/comment_bloc.dart';
import '../models/models.dart';
import '../repository/firestore_repository.dart';

class CustomCommentLikeButton extends StatefulWidget {
  const CustomCommentLikeButton({
    Key? key,
    required this.comment,
    required this.user,
    required this.stingray,
    required this.liked,
  }) : super(key: key);

  final Comment comment;
  final User user;
  final Stingray? stingray;
  final bool liked;

  @override
  State<CustomCommentLikeButton> createState() => _CustomLikeButtonState();
}

class _CustomLikeButtonState extends State<CustomCommentLikeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        child: LikeButton(
          likeCount:
              (widget.liked) ? widget.comment.likes + 1 : widget.comment.likes,
          isLiked: (widget.liked)
              ? true
              : (widget.comment.userIdsWhoLiked.contains(widget.user.id))
                  ? true
                  : false,
          onTap: (isLiked) async {
            // FirestoreRepository().updateStingrayMessageLikeCount(
            //     comment, stingray?.id, comments, commentIndex, user.id!);

            (isLiked)
                ? Provider.of<CommentBloc>(context, listen: false)
                    .add(UnlikeComment(comment: widget.comment))
                : Provider.of<CommentBloc>(context, listen: false)
                    .add(LikeComment(comment: widget.comment));

            return !isLiked;
          },
        ));
  }
}
