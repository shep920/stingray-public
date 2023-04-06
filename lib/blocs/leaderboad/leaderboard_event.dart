part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeaderboard extends LeaderboardEvent {
  final User user;
  const LoadLeaderboard({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseLeaderboard extends LeaderboardEvent {
  const CloseLeaderboard();

  @override
  List<Object?> get props => [];
}

class UpdateLeaderboard extends LeaderboardEvent {
  final List<User?> leaderBoard;

  const UpdateLeaderboard({required this.leaderBoard});

  @override
  List<Object> get props => [leaderBoard];
}
