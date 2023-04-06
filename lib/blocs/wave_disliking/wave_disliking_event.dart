part of 'wave_disliking_bloc.dart';

abstract class WaveDislikingEvent extends Equatable {
  const WaveDislikingEvent();

  @override
  List<Object?> get props => [];
}

class RemoveDislikeWave extends WaveDislikingEvent {
  final String waveId;
  final String userId;
  final User poster;

  const RemoveDislikeWave({
    required this.waveId,
    required this.userId,
    required this.poster,
  });

  @override
  List<Object?> get props => [waveId, userId, poster];
}

class DislikeWave extends WaveDislikingEvent {
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

class UpdateWaveDislikes extends WaveDislikingEvent {}

class DeleteShortTermMemory extends WaveDislikingEvent {
  
}
