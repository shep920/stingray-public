part of 'wave_replies_bloc.dart';

abstract class WaveRepliesEvent extends Equatable {
  const WaveRepliesEvent();

  @override
  List<Object?> get props => [];
}

class LoadWaveReplies extends WaveRepliesEvent {
  final Wave wave;
  final WaveTile waveTile;

  const LoadWaveReplies({
    required this.wave,
    required this.waveTile,
  });

  @override
  List<Object?> get props => [wave, waveTile];
}

class UpdateWaveReplies extends WaveRepliesEvent {
  final List<WavesMeta> waveMeta;
  final Timer? timer;
  const UpdateWaveReplies({required this.waveMeta, required this.timer});

  @override
  List<Object?> get props => [waveMeta, timer];
}

class CreateWaveReplies extends WaveRepliesEvent {
  final Wave wave;
  final File? file;
  final User sender;
  final User receiver;
  CreateWaveReplies({
    required this.wave,
    required this.file,
    required this.sender,
    required this.receiver,
  });

  @override
  List<Object?> get props => [wave, file, sender, receiver];
}

class CloseWaveReplies extends WaveRepliesEvent {
  const CloseWaveReplies();

  @override
  List<Object?> get props => [];
}

class RefreshStingrayWaveRepliess extends WaveRepliesEvent {
  final Stingray stingray;
  final WavesMeta waves;
  const RefreshStingrayWaveRepliess(
      {required this.stingray, required this.waves});

  @override
  List<Object?> get props => [stingray, waves];
}

class PaginateWaveRepliess extends WaveRepliesEvent {
  final Stingray stingray;
  final WavesMeta waves;
  const PaginateWaveRepliess({required this.stingray, required this.waves});

  @override
  List<Object?> get props => [stingray, waves];
}

class UpdateLoadingStatus extends WaveRepliesEvent {
  const UpdateLoadingStatus();

  @override
  List<Object?> get props => [];
}
