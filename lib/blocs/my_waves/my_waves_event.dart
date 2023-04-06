part of 'my_waves_bloc.dart';

abstract class MyWavesEvent extends Equatable {
  const MyWavesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyWaves extends MyWavesEvent {
  final User user;

  const LoadMyWaves({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseMyWaves extends MyWavesEvent {
  const CloseMyWaves();

  @override
  List<Object?> get props => [];
}

class UpdateMyWaves extends MyWavesEvent {
  final List<Wave?> waves;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;

  const UpdateMyWaves(
      {required this.waves,
      required this.hasMore,
      required this.lastmyWaveDoc});

  @override
  List<Object?> get props => [
        waves,
        hasMore,
        lastmyWaveDoc,
      ];
}

class PaginateWaves extends MyWavesEvent {
  final User user;

  const PaginateWaves({required this.user});

  @override
  List<Object?> get props => [user];
}

class RefreshLoads extends MyWavesEvent {
  final User user;

  const RefreshLoads({required this.user});

  @override
  List<Object?> get props => [user];
}


class DeleteWave extends MyWavesEvent {
  final Wave wave;

  const DeleteWave({
    required this.wave,
  });

  @override
  List<Object?> get props => [wave];
}
