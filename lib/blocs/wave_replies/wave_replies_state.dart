part of 'wave_replies_bloc.dart';

abstract class WaveRepliesState extends Equatable {
  const WaveRepliesState();

  @override
  List<Object?> get props => [];
}

class WaveRepliesLoading extends WaveRepliesState {}

class WaveRepliesLoaded extends WaveRepliesState {
  // final List<WavesMeta> wavesMeta;
  //add a timer to the state
  final Timer? timer;
  final bool isLoading;
  final bool hasMore;
  final WaveTile waveTile;

  const WaveRepliesLoaded({
    // required this.wavesMeta,
    required this.timer,
    required this.isLoading,
    required this.hasMore,
    required this.waveTile,
  });

  @override
  List<Object?> get props => [
        // wavesMeta,
        timer,
        isLoading,
        hasMore,
        waveTile,
      ];
}
