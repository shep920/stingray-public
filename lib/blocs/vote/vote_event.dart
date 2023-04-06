part of 'vote_bloc.dart';

abstract class VoteEvent extends Equatable {
  const VoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends VoteEvent {
  final User? user;

  LoadUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class VoteUserEvent extends VoteEvent {
  final User user;

  const VoteUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateVote extends VoteEvent {
  final User user;

  const UpdateVote({required this.user});

  @override
  List<Object> get props => [user];
}

class LoadUserFromFirestore extends VoteEvent {
  final String? userId;

  LoadUserFromFirestore(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserFromFirestore extends VoteEvent {
  final User user;

  const UpdateUserFromFirestore({required this.user});

  @override
  List<Object> get props => [user];
}

class IncrementImageUrlIndex extends VoteEvent {
  final int imageUrlIndex;

  const IncrementImageUrlIndex({
    required this.imageUrlIndex,
  });

  @override
  List<Object> get props => [imageUrlIndex];
}

class DecrementImageUrlIndex extends VoteEvent {
  final int imageUrlIndex;

  const DecrementImageUrlIndex({
    required this.imageUrlIndex,
  });

  @override
  List<Object> get props => [imageUrlIndex];
}

class CloseVote extends VoteEvent {
  const CloseVote();

  @override
  List<Object?> get props => [];
}

class LoadVoteUserFromHandle extends VoteEvent {
  final String handle;
  final BuildContext context;

  const LoadVoteUserFromHandle({required this.handle, required this.context});

  @override
  List<Object> get props => [handle, context];
}
