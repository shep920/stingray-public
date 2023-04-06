part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object?> get props => [];
}

class LikeLoading extends LikeState {}

class LikeLoaded extends LikeState {
  final List<UserLiked?> likes;

  const LikeLoaded({
    required this.likes,
  });

  @override
  List<Object?> get props => [likes];
}

class LikeError extends LikeState {}
