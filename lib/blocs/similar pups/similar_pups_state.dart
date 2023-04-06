part of 'similar_pups_bloc.dart';

abstract class SimilarPupsState extends Equatable {
  const SimilarPupsState();

  @override
  List<Object> get props => [];
}

class SimilarPupsLoading extends SimilarPupsState {}

class SimilarPupsLoaded extends SimilarPupsState {
  final List<User?> similarPups;
  final bool isLoading;
  final bool hasMore;
  final int cap;
  final int totalLoaded;

  const SimilarPupsLoaded(
      {required this.similarPups,
      required this.isLoading,
      required this.hasMore,
      required this.cap,
      required this.totalLoaded});

  @override
  List<Object> get props => [similarPups, isLoading, hasMore, cap, totalLoaded];

  //make a copywith
  SimilarPupsLoaded copyWith({
    List<User?>? similarPups,
    bool? isLoading,
    bool? hasMore,
    int? cap,
    int? totalLoaded,
  }) {
    return SimilarPupsLoaded(
      similarPups: similarPups ?? this.similarPups,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      cap: this.cap,
      totalLoaded: this.totalLoaded,
    );
  }
}
