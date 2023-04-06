part of 'stingray_leaderboard_bloc.dart';

abstract class StingrayLeaderboardEvent extends Equatable {
  const StingrayLeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadStingrayLeaderboard extends StingrayLeaderboardEvent {
  final List<Stingray?> stingrays;

  const LoadStingrayLeaderboard({required this.stingrays});

  @override
  List<Object?> get props => [stingrays];
}

class CloseStingrayLeaderboard extends StingrayLeaderboardEvent {
  const CloseStingrayLeaderboard();

  @override
  List<Object?> get props => [];
}

class UpdateStingrayLeaderboard extends StingrayLeaderboardEvent {
  final List<StingrayStats?> stats;
  final DocumentSnapshot? lastStatsDoc;
  final bool hasMore;

  const UpdateStingrayLeaderboard({
    required this.stats,
    required this.lastStatsDoc,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [
        stats,
        lastStatsDoc,
        hasMore,
      ];
}

class PaginateStats extends StingrayLeaderboardEvent {
  final List<Stingray> stingrays;

  const PaginateStats({required this.stingrays});

  @override
  List<Object?> get props => [stingrays];
}

class ChangeRefreshStatus extends StingrayLeaderboardEvent {
  const ChangeRefreshStatus();

  @override
  List<Object?> get props => [];
}
