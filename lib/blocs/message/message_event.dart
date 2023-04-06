part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessage extends MessageEvent {
  final String stingrayId;
  final String matchedUserImageUrls;
  final Chat chat;
  final String matchedUserId;

  final String messageId;

  const LoadMessage(
    this.stingrayId,
    this.messageId,
    this.matchedUserImageUrls, {
    required this.chat,
    required this.matchedUserId,
  });

  @override
  List<Object?> get props =>
      [stingrayId, messageId, matchedUserImageUrls, chat, matchedUserId];
}

class UpdateMessage extends MessageEvent {
  final List<Message?> messages;
  final String matchedUserImageUrls;
  final Chat? chat;
  final User matchedUser;
  final bool blocked;
  final String blockerName;
  final String? blockerId;
  final List<dynamic> messageIdsLiked;
  final List<dynamic> messageIdsUnliked;

  const UpdateMessage({
    required this.messages,
    required this.matchedUserImageUrls,
    required this.chat,
    required this.matchedUser,
    required this.blocked,
    required this.blockerName,
    required this.blockerId,
    required this.messageIdsLiked,
    required this.messageIdsUnliked,
  });

  @override
  List<Object?> get props => [
        messages,
        matchedUserImageUrls,
        chat,
        matchedUser,
        blocked,
        blockerName,
        blockerId,
        messageIdsLiked,
        messageIdsUnliked,
      ];
}

class UpdateCommentCount extends MessageEvent {
  final Message message;
  final String stingrayId;
  final int commentCount;

  const UpdateCommentCount({
    required this.stingrayId,
    required this.message,
    required this.commentCount,
  });

  @override
  List<Object> get props => [message, stingrayId, commentCount];
}

class BlockUser extends MessageEvent {
  final User blocker;
  final Stingray stingray;

  const BlockUser({
    required this.blocker,
    required this.stingray,
  });

  @override
  List<Object> get props => [blocker, stingray];
}

class UnblockUser extends MessageEvent {
  final User blocker;
  final Stingray stingray;

  const UnblockUser({
    required this.blocker,
    required this.stingray,
  });

  @override
  List<Object> get props => [blocker, stingray];
}

class CloseMessage extends MessageEvent {
  final String userId;
  const CloseMessage({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SetLoading extends MessageEvent {
  const SetLoading();

  @override
  List<Object> get props => [];
}

class LikeMessage extends MessageEvent {
  final Message message;
  const LikeMessage({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class UnlikeMessage extends MessageEvent {
  final Message message;
  const UnlikeMessage({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
