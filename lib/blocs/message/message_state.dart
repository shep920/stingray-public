part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message?> messages;
  final int? commentCount;
  final String? matchedUserImageUrl;
  final Chat? chat;
  final User matchedUser;
  final bool blocked;
  final String blockerName;
  final String? blockerId;
  final List<dynamic> messageIdsLiked;
  final List<dynamic> messageIdsUnliked;
  

  const MessageLoaded(
      {required this.messages,
      this.commentCount,
      this.matchedUserImageUrl,
      required this.matchedUser,
      required this.blocked,
      required this.blockerName,
      required this.blockerId,
      required this.messageIdsLiked,
      required this.messageIdsUnliked,
      
      this.chat});

  @override
  List<Object?> get props => [
        messages,
        commentCount,
        matchedUserImageUrl,
        chat,
        matchedUser,
        blocked,
        blockerName,
        blockerId,
        messageIdsLiked,
        messageIdsUnliked,
      ];
}
