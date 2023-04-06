part of 'wave_liking_bloc.dart';

abstract class WaveLikingState extends Equatable {
  const WaveLikingState();

  @override
  List<Object?> get props => [];
}

class WaveLikingLoaded extends WaveLikingState {
  final String? userId;
  final List<String> likes;
  final List<String> shortTermLikes;
  final List<String> dislikes;
  final List<String> shortTermDislikes;
  final Timer? timer;
  final List<LikeArg> likedArgs;
  final List<LikeArg> dislikedArgs;


  WaveLikingLoaded(
      {required this.likes, required this.dislikes, required this.timer, required this.userId, required this.shortTermLikes, required this.shortTermDislikes, required this.likedArgs, required this.dislikedArgs});

  @override
  List<Object?> get props => [likes, dislikes, timer, userId, shortTermLikes, shortTermDislikes, likedArgs, dislikedArgs];
}
