part of 'vote_bloc.dart';

abstract class VoteState extends Equatable {
  const VoteState();

  @override
  List<Object?> get props => [];
}

class VoteLoading extends VoteState {}

class VoteLoaded extends VoteState {
  final int imageUrlIndex;
  final User? user;

  const VoteLoaded({
    required this.imageUrlIndex,
    required this.user,
  });

  @override
  List<Object?> get props => [user, imageUrlIndex];
}
