part of 'wave_liking_bloc.dart';

abstract class WaveLikingEvent extends Equatable {
  const WaveLikingEvent();

  @override
  List<Object?> get props => [];
}

class LikeWave extends WaveLikingEvent {
  final String waveId;
  final String userId;
  final User poster;

  const LikeWave({
    required this.waveId,
    required this.userId,
    required this.poster,
  });

  @override
  List<Object?> get props => [waveId, userId, poster];
}

class DislikeWave extends WaveLikingEvent {
  final String waveId;
  final String userId;
  final User poster;

  const DislikeWave({
    required this.waveId,
    required this.userId,
    required this.poster,
  });

  @override
  List<Object?> get props => [waveId, userId, poster];
}

class UpdateWaveLikes extends WaveLikingEvent {}

class DeleteShortTermMemory extends WaveLikingEvent {
  
}
