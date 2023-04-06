part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object?> get props => [];
}

class LikeUserEvent extends LikeEvent {
  final User user;

  const LikeUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateLike extends LikeEvent {
  final User user;

  const UpdateLike({required this.user});

  @override
  List<Object> get props => [user];
}

class LoadLikeFromFirestore extends LikeEvent {
  final Stingray stingray;

  LoadLikeFromFirestore({required this.stingray});

  @override
  List<Object?> get props => [stingray];
}

class UpdateLikeFromFirestore extends LikeEvent {
  final List<UserLiked?> likes;

  const UpdateLikeFromFirestore({required this.likes});

  @override
  List<Object> get props => [likes];
}

class CloseLike extends LikeEvent {
  const CloseLike();

  @override
  List<Object?> get props => [];
}

class LoadAllLikes extends LikeEvent {
  const LoadAllLikes();

  @override
  List<Object?> get props => [];
}
