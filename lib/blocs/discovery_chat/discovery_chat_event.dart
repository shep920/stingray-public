part of 'discovery_chat_bloc.dart';

abstract class DiscoveryChatEvent extends Equatable {
  const DiscoveryChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoveryChat extends DiscoveryChatEvent {
  final User user;
  final BuildContext context;

  const LoadDiscoveryChat({required this.user, required this.context});

  @override
  List<Object?> get props => [user, context];
}

class CloseDiscoveryChat extends DiscoveryChatEvent {
  const CloseDiscoveryChat();

  @override
  List<Object?> get props => [];
}

class UpdateDiscoveryChat extends DiscoveryChatEvent {
  final List<DiscoveryChat?> chats;
  final List<User?> chatUsers;

  final List<User?> userPool;
  final bool hasMore;

  const UpdateDiscoveryChat(
      {required this.chats,
      required this.chatUsers,
      required this.userPool,
      required this.hasMore});

  @override
  List<Object?> get props => [
        chats,
        chatUsers,
        userPool,
        hasMore,
      ];
}

class PaginateChats extends DiscoveryChatEvent {
  final String userId;
  final BuildContext context;

  const PaginateChats({required this.userId, required this.context});

  @override
  List<Object?> get props => [userId, context];
}

//start stream event
class StartStream extends DiscoveryChatEvent {
  final String userId;
  final BuildContext context;

  const StartStream({required this.userId, required this.context});

  @override
  List<Object?> get props => [userId, context];
}

class RefreshLoads extends DiscoveryChatEvent {
  final User user;
  final BuildContext context;

  const RefreshLoads({required this.user, required this.context});

  @override
  List<Object?> get props => [user, context];
}

class AddLocalMessage extends DiscoveryChatEvent {
  final DiscoveryMessage? message;

  const AddLocalMessage({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddLocalMessageFromJudgeable extends DiscoveryChatEvent {
  final DiscoveryMessage? message;
  final User matchedUser;

  const AddLocalMessageFromJudgeable({required this.message, required this.matchedUser});

  @override
  List<Object?> get props => [message, matchedUser];
}

class ViewDiscoveryChat extends DiscoveryChatEvent {
  final User user;
  final BuildContext context;
  final DiscoveryChat chat;

  const ViewDiscoveryChat(
      {required this.user, required this.context, required this.chat});

  @override
  List<Object?> get props => [user, context, chat];
}



