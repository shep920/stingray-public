part of 'discovery_chat_pending_bloc.dart';

abstract class DiscoveryChatPendingEvent extends Equatable {
  const DiscoveryChatPendingEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoveryChatPending extends DiscoveryChatPendingEvent {
  final User user;
  final BuildContext context;

  const LoadDiscoveryChatPending({required this.user, required this.context});

  @override
  List<Object?> get props => [user, context];
}

class CloseDiscoveryChatPending extends DiscoveryChatPendingEvent {
  const CloseDiscoveryChatPending();

  @override
  List<Object?> get props => [];
}

class UpdateDiscoveryChatPending extends DiscoveryChatPendingEvent {
  final List<DiscoveryChat?> pending;
  final List<User?> pendingUsers;

  final List<User?> userPool;

  final DocumentSnapshot? lastPendingDoc;

  final bool hasMore;

  const UpdateDiscoveryChatPending({
    required this.pending,
    required this.pendingUsers,
    required this.userPool,
    required this.lastPendingDoc,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [
        pending,
        pendingUsers,
        userPool,
        lastPendingDoc,
      ];
}

class PaginatePending extends DiscoveryChatPendingEvent {
  final User user;
  final BuildContext context;

  const PaginatePending({required this.user, required this.context});

  @override
  List<Object?> get props => [user, context];
}

//start stream event
class StartStream extends DiscoveryChatPendingEvent {
  final String userId;
  final BuildContext context;

  const StartStream({required this.userId, required this.context});

  @override
  List<Object?> get props => [userId, context];
}

class RefreshPendingLoads extends DiscoveryChatPendingEvent {
  final User user;
  final BuildContext context;

  const RefreshPendingLoads({required this.user, required this.context});

  @override
  List<Object?> get props => [user, context];
}

class SendDirectMessage extends DiscoveryChatPendingEvent {
  final User user;
  final User matchedUser;
  final String imageUrl;
  final String chatId;

  final String message;
  

  const SendDirectMessage(
      {required this.user,
      required this.message,
      required this.matchedUser,
      required this.imageUrl, required this.chatId});

  @override
  List<Object?> get props => [user, message, matchedUser, imageUrl, chatId];
}
