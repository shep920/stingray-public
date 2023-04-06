part of 'wave_disliking_bloc.dart';

abstract class WaveDislikingState extends Equatable {
  const WaveDislikingState();

  @override
  List<Object?> get props => [];
}

class WaveDislikingLoaded extends WaveDislikingState {
  final String? userId;
  final List<String> dislikes;
  final List<String> shortTermDislikes;
  final List<String> removedDislikes;
  final List<String> shortTermRemovedDislikes;
  final Timer? timer;
  
  final List<LikeArg> dislikedArgs;
  final List<LikeArg> removedDislikedArgs;

  WaveDislikingLoaded(
      {required this.dislikes, required this.removedDislikes, required this.timer, required this.userId, required this.shortTermDislikes, required this.shortTermRemovedDislikes, required this.dislikedArgs, required this.removedDislikedArgs});

  @override
  List<Object?> get props => [dislikes, removedDislikes, timer, userId, shortTermDislikes, shortTermRemovedDislikes, dislikedArgs, removedDislikedArgs];
}
