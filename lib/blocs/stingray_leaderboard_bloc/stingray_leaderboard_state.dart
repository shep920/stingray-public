part of 'stingray_leaderboard_bloc.dart';

abstract class StingrayLeaderboardState extends Equatable {
  const StingrayLeaderboardState();

  @override
  List<Object?> get props => [];
}

class StingrayLeaderboardLoading extends StingrayLeaderboardState {}

class StingrayLeaderboardLoaded extends StingrayLeaderboardState {
  final List<StingrayStats?> stats;
  final bool loading;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;
  final bool refreshable;
  final Timer timer;

  const StingrayLeaderboardLoaded({
    required this.stats,
    required this.loading,
    required this.hasMore,
    required this.lastmyWaveDoc,
    required this.refreshable,
    required this.timer,
  });

  @override
  List<Object?> get props => [
        stats,
        loading,
        hasMore,
        lastmyWaveDoc,
        refreshable,
        timer,
      ];

  StingrayLeaderboardLoaded copyWith({
    List<StingrayStats?>? stats,
    bool? loading,
    bool? hasMore,
    DocumentSnapshot? lastmyWaveDoc,
    bool? refreshable,
    Timer? timer,
  }) {
    return StingrayLeaderboardLoaded(
      stats: stats ?? this.stats,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      lastmyWaveDoc: lastmyWaveDoc ?? this.lastmyWaveDoc,
      refreshable: refreshable ?? this.refreshable,
      timer: timer ?? this.timer,
    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

