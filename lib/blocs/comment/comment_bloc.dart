import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repository/firestore_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentBlocState> {
  final FirestoreRepository _firestoreRepository;
  late StreamSubscription _commentListener;
  CommentBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(CommentLoading()) {
    on<UpdateComment>(_onUpdateComment);
    on<LoadComment>(_onLoadComment);
    on<CloseComment>(_onCloseComment);
    on<LikeComment>(_likeComment);
    on<UnlikeComment>(_unlikeComment);
  }

  void _onLoadComment(
    LoadComment event,
    Emitter<CommentBlocState> emit,
  ) {
    List<dynamic> commentIdsLiked = [];
    List<dynamic> commentIdsUnliked = [];
    _commentListener =
        _firestoreRepository.comments(event.message.id).listen((comments) {
      if (this.state is CommentLoaded) {
        commentIdsLiked = (this.state as CommentLoaded).commentIdsLiked;
        commentIdsUnliked = (this.state as CommentLoaded).commentIdsUnliked;
      }

      add(
        UpdateComment(
            comments: comments,
            message: event.message,
            chat: event.chat,
            commentIdsLiked: commentIdsLiked,
            commentIdsUnliked: commentIdsUnliked),
      );
    });
  }

  void _onUpdateComment(
    UpdateComment event,
    Emitter<CommentBlocState> emit,
  ) {
    List<dynamic> commentIdsLiked = [];
    List<dynamic> commentIdsUnliked = [];

    commentIdsLiked = event.commentIdsLiked;
    commentIdsUnliked = event.commentIdsUnliked;

    List<Comment?> comments = event.comments;
    comments.sort((b, a) => a!.dateTime.compareTo(b!.dateTime));
    emit(CommentLoaded(
        comments: comments,
        message: event.message,
        chat: event.chat,
        commentIdsLiked: commentIdsLiked,
        commentIdsUnliked: commentIdsUnliked));
  }

  void _onCloseComment(
    CloseComment event,
    Emitter<CommentBlocState> emit,
  ) {
    final state = this.state as CommentLoaded;
    if (state.commentIdsLiked.isNotEmpty ||
        state.commentIdsUnliked.isNotEmpty) {
      List<Comment?> oldComments = state.comments;
      List<Comment?> likedComments = [];
      List<Comment?> finalComments = [];
      List<dynamic> commentIdsLiked = state.commentIdsLiked;
      List<dynamic> commentIdsUnliked = state.commentIdsUnliked;

      if (commentIdsLiked.isNotEmpty) {
        for (Comment? comment in oldComments) {
          if (state.commentIdsLiked.contains(comment!.id)) {
            int likes = comment.likes + 1;
            List<dynamic> userIdsWhoLiked = comment.userIdsWhoLiked;
            userIdsWhoLiked.add(event.userId);

            Comment newComment = Comment(
                id: comment.id,
                senderId: comment.senderId,
                dateTime: comment.dateTime,
                timeString: comment.timeString,
                likes: likes,
                message: comment.message,
                posterName: comment.posterName,
                posterImageUrl: comment.posterImageUrl,
                userIdsWhoLiked: userIdsWhoLiked);
            likedComments.add(newComment);
          } else {
            likedComments.add(comment);
          }
        }
      } else {
        likedComments = oldComments;
      }
      if (commentIdsUnliked.isNotEmpty) {
        for (Comment? comment in likedComments) {
          if (state.commentIdsUnliked.contains(comment!.id)) {
            int likes = comment.likes - 1;
            List<dynamic> userIdsWhoLiked = comment.userIdsWhoLiked;
            userIdsWhoLiked.remove(event.userId);
            Comment newComment = Comment(
                id: comment.id,
                senderId: comment.senderId,
                dateTime: comment.dateTime,
                timeString: comment.timeString,
                likes: likes,
                message: comment.message,
                posterName: comment.posterName,
                posterImageUrl: comment.posterImageUrl,
                userIdsWhoLiked: userIdsWhoLiked);
            finalComments.add(newComment);
          } else {
            finalComments.add(comment);
          }
        }
      } else {
        finalComments = likedComments;
      }

      _firestoreRepository.updateStingrayComments(
        state.message,
        finalComments,
      );
    }

    print('closed comment');
    _commentListener.cancel();
    emit(CommentLoading());
  }

  void _likeComment(
    LikeComment event,
    Emitter<CommentBlocState> emit,
  ) {
    final state = this.state as CommentLoaded;
    List<dynamic> commentIdsLiked = state.commentIdsLiked;
    List<dynamic> commentIdsUnliked = state.commentIdsUnliked;
    if (!commentIdsLiked.contains(event.comment.id)) {
      if (commentIdsUnliked.contains(event.comment.id)) {
        commentIdsUnliked.remove(event.comment.id);
      } else {
        commentIdsLiked.add(event.comment.id);
      }
    }
    emit(CommentLoaded(
      comments: state.comments,
      chat: state.chat,
      commentIdsLiked: commentIdsLiked,
      commentIdsUnliked: state.commentIdsUnliked,
      message: state.message,
    ));
  }

  void _unlikeComment(
    UnlikeComment event,
    Emitter<CommentBlocState> emit,
  ) {
    final state = this.state as CommentLoaded;
    List<dynamic> commentIdsUnliked = state.commentIdsUnliked;
    List<dynamic> commentIdsLiked = state.commentIdsLiked;

    if (!commentIdsUnliked.contains(event.comment.id)) {
      if (commentIdsLiked.contains(event.comment.id)) {
        commentIdsLiked.remove(event.comment.id);
      } else {
        commentIdsUnliked.add(event.comment.id);
      }
    }
    emit(CommentLoaded(
      comments: state.comments,
      chat: state.chat,
      commentIdsLiked: state.commentIdsLiked,
      commentIdsUnliked: commentIdsUnliked,
      message: state.message,
    ));
  }
}
