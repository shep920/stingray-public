part of 'leaderboard_bloc.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<User?> leaderboard;

  const LeaderboardLoaded({required this.leaderboard});

  @override
  List<Object> get props => [leaderboard];
}
