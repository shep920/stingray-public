part of 'similar_pups_bloc.dart';

abstract class SimilarPupsEvent extends Equatable {
  const SimilarPupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSimilarPups extends SimilarPupsEvent {
  final User user;
  const LoadSimilarPups({required this.user});

  @override
  List<Object?> get props => [user];
}

class PaginateSimilarPups extends SimilarPupsEvent {
  final User user;
  const PaginateSimilarPups({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseSimilarPups extends SimilarPupsEvent {
  const CloseSimilarPups();

  @override
  List<Object?> get props => [];
}

class UpdateSimilarPups extends SimilarPupsEvent {
  final List<User?> similarPups;

  const UpdateSimilarPups({required this.similarPups});

  @override
  List<Object> get props => [similarPups];
}
