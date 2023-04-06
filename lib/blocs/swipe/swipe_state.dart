part of 'swipe_bloc.dart';

abstract class SwipeState extends Equatable {
  const SwipeState();

  @override
  List<Object> get props => [];
}

class SwipeLoading extends SwipeState {}

class SwipeLoaded extends SwipeState {
  final int imageUrlIndex;
  final List<User> users;

  SwipeLoaded({
    required this.imageUrlIndex,
    required this.users,
  });

  @override
  List<Object> get props => [users, imageUrlIndex];
}

class SwipeError extends SwipeState {}
