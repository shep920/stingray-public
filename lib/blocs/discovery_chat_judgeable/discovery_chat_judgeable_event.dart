part of 'discovery_chat_judgeable_bloc.dart';

abstract class DiscoveryChatJudgeableEvent extends Equatable {
  const DiscoveryChatJudgeableEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoveryChatJudgeable extends DiscoveryChatJudgeableEvent {
  final User user;
  final BuildContext context;
  final bool testing;
  final List<User> testUserPool;

  const LoadDiscoveryChatJudgeable(
      {required this.user,
      required this.context,
      this.testing = false,
      this.testUserPool = const []});

  @override
  List<Object?> get props => [user, context];
}

class CloseDiscoveryChatJudgeable extends DiscoveryChatJudgeableEvent {
  const CloseDiscoveryChatJudgeable();

  @override
  List<Object?> get props => [];
}

class UpdateDiscoveryChatJudgeable extends DiscoveryChatJudgeableEvent {
  final List<DiscoveryChat?> judgeableChats;

  final List<User?> userPool;

  final DocumentSnapshot? lastJudgeableDoc;

  final bool hasMore;

  const UpdateDiscoveryChatJudgeable(
      {required this.judgeableChats,
      required this.userPool,
      required this.lastJudgeableDoc,
      required this.hasMore});

  @override
  List<Object?> get props => [judgeableChats, userPool, lastJudgeableDoc];
}

class PaginateJudgeableChats extends DiscoveryChatJudgeableEvent {
  final User user;
  final BuildContext context;
  final bool testing;
  final List<User> testUserPool;

  const PaginateJudgeableChats(
      {required this.user,
      required this.context,
      this.testing = false,
      this.testUserPool = const []});

  @override
  List<Object?> get props => [user, context];
}

//start stream event
class StartStream extends DiscoveryChatJudgeableEvent {
  final String userId;
  final BuildContext context;

  const StartStream({required this.userId, required this.context});

  @override
  List<Object?> get props => [userId, context];
}

class RefreshJudgeableLoads extends DiscoveryChatJudgeableEvent {
  final User user;
  final BuildContext context;

  const RefreshJudgeableLoads({required this.user, required this.context});

  @override
  List<Object?> get props => [user, context];
}

class RemoveLocalJudgeableChat extends DiscoveryChatJudgeableEvent {
  final DiscoveryMessage? message;

  const RemoveLocalJudgeableChat({required this.message});

  @override
  List<Object?> get props => [message];
}
