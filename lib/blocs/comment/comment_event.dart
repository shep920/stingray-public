part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class LoadComment extends CommentEvent {
  final String? stingrayId;
  final Message message;
  final Chat chat;
  const LoadComment(this.stingrayId,
      {required this.message, required this.chat});

  @override
  List<Object> get props => [];
}

class UpdateComment extends CommentEvent {
  final List<Comment?> comments;
  final Message message;
  final Chat chat;
  final List<dynamic> commentIdsLiked;
  final List<dynamic> commentIdsUnliked;

  const UpdateComment({
    required this.comments,
    required this.message,
    required this.chat,
    required this.commentIdsLiked,
    required this.commentIdsUnliked,
  });

  @override
  List<Object> get props => [comments, message, chat, commentIdsLiked, commentIdsUnliked];
}

class CloseComment extends CommentEvent {
  final String userId;
  const CloseComment(
    {required this.userId}
  );

  @override
  List<Object> get props => [userId];
}

class LikeComment extends CommentEvent {
  final Comment comment;

  const LikeComment({required this.comment});

  @override
  List<Object> get props => [comment];
}

class UnlikeComment extends CommentEvent {
  final Comment comment;

  const UnlikeComment({required this.comment});

  @override
  List<Object> get props => [comment];
}
