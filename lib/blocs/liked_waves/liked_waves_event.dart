part of 'liked_waves_bloc.dart';

abstract class LikedWavesEvent extends Equatable {
  const LikedWavesEvent();

  @override
  List<Object?> get props => [];
}

class LoadLikedWaves extends LikedWavesEvent {
  final User user;

  const LoadLikedWaves({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseLikedWaves extends LikedWavesEvent {
  const CloseLikedWaves();

  @override
  List<Object?> get props => [];
}

class UpdateLikedWaves extends LikedWavesEvent {
  final List<Wave?> waves;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;
  final List<User?> userPool;

  const UpdateLikedWaves(
      {required this.waves,
      required this.hasMore,
      required this.lastmyWaveDoc,
      required this.userPool});

  @override
  List<Object?> get props => [
        waves,
        hasMore,
        lastmyWaveDoc,
      ];
}

class PaginateWaves extends LikedWavesEvent {
  final User user;

  const PaginateWaves({required this.user});

  @override
  List<Object?> get props => [user];
}

class RefreshLoads extends LikedWavesEvent {
  final User user;

  const RefreshLoads({required this.user});

  @override
  List<Object?> get props => [user];
}


class DeleteWave extends LikedWavesEvent {
  final Wave wave;

  const DeleteWave({
    required this.wave,
  });

  @override
  List<Object?> get props => [wave];
}
