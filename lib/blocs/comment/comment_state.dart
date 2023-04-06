part of 'comment_bloc.dart';

abstract class CommentBlocState extends Equatable {
  const CommentBlocState();
  
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentBlocState {}

class CommentLoaded extends CommentBlocState {
  final List<Comment?> comments;
  final Message message;
  final Chat chat;
  final List<dynamic> commentIdsLiked;
  final List<dynamic> commentIdsUnliked;


  const CommentLoaded({required this.comments, required this.message, required this.chat, required this.commentIdsLiked, required this.commentIdsUnliked});

  @override
  List<Object> get props => [comments, message, chat, commentIdsLiked, commentIdsUnliked];
}


