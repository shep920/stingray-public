part of 'discovery_chat_judgeable_bloc.dart';

abstract class DiscoveryChatJudgeableState extends Equatable {
  const DiscoveryChatJudgeableState();

  @override
  List<Object?> get props => [];
}

class DiscoveryChatJudgeableLoading extends DiscoveryChatJudgeableState {}

class DiscoveryChatJudgeableLoaded extends DiscoveryChatJudgeableState {
  final List<DiscoveryChat?> judgeableChats;

  final bool judgeableLoading;
  final bool judgeableHasMore;
  final DocumentSnapshot? lastJudgeableDoc;

  final List<User?> userPool;

  const DiscoveryChatJudgeableLoaded(
      {required this.judgeableChats,
      required this.judgeableLoading,
      required this.judgeableHasMore,
      required this.userPool,
      required this.lastJudgeableDoc});

  @override
  List<Object?> get props => [
        judgeableChats,
        judgeableLoading,
        judgeableHasMore,
        userPool,
        lastJudgeableDoc,
      ];

  DiscoveryChatJudgeableLoaded copyWith({
    List<DiscoveryChat?>? judgeableChats,
    bool? judgeableLoading,
    bool? judgeableHasMore,
    DocumentSnapshot? judgeableLastDoc,
    List<User?>? userPool,
  }) {
    return DiscoveryChatJudgeableLoaded(
      judgeableChats: judgeableChats ?? this.judgeableChats,
      judgeableLoading: judgeableLoading ?? this.judgeableLoading,
      judgeableHasMore: judgeableHasMore ?? this.judgeableHasMore,
      userPool: userPool ?? this.userPool,
      lastJudgeableDoc: judgeableLastDoc ?? this.lastJudgeableDoc,
    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

