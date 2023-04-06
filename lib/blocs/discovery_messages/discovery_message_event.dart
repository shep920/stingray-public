part of 'discovery_message_bloc.dart';

abstract class DiscoveryMessageEvent extends Equatable {
  const DiscoveryMessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoveryMessage extends DiscoveryMessageEvent {
  final String chatId;
  final User matchedUser;

  const LoadDiscoveryMessage({
    required this.chatId,
    required this.matchedUser,
  });

  @override
  List<Object?> get props => [chatId, matchedUser];
}

class LoadDiscoveryMessageFromId extends DiscoveryMessageEvent {
  final String chatId;
  final String userId;

  const LoadDiscoveryMessageFromId({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object?> get props => [chatId, userId];
}

class UpdateDiscoveryMessage extends DiscoveryMessageEvent {
  final DiscoveryMessageDocument? discoveryMessageDocument;
  final User matchedUser;

  const UpdateDiscoveryMessage({
    required this.matchedUser,
    required this.discoveryMessageDocument,
  });

  @override
  List<Object?> get props => [
        matchedUser,
        discoveryMessageDocument,
      ];
}

class BlockUser extends DiscoveryMessageEvent {
  final User blocker;
  final Stingray stingray;

  const BlockUser({
    required this.blocker,
    required this.stingray,
  });

  @override
  List<Object> get props => [blocker, stingray];
}

class UnblockUser extends DiscoveryMessageEvent {
  final User blocker;
  final Stingray stingray;

  const UnblockUser({
    required this.blocker,
    required this.stingray,
  });

  @override
  List<Object> get props => [blocker, stingray];
}

class CloseDiscoveryMessage extends DiscoveryMessageEvent {
  const CloseDiscoveryMessage();

  @override
  List<Object?> get props => [];
}

class AcceptDiscoveryChat extends DiscoveryMessageEvent {
  final BuildContext context;
  final User sender;
  const AcceptDiscoveryChat({required this.sender, required this.context});

  @override
  List<Object?> get props => [sender, context];
}

class RejectDiscoveryChat extends DiscoveryMessageEvent {
  final BuildContext context;
  final User sender;
  const RejectDiscoveryChat({required this.sender, required this.context});

  @override
  List<Object?> get props => [sender];
}
