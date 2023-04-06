part of 'sea_real_bloc.dart';

abstract class SeaRealState extends Equatable {
  const SeaRealState();

  @override
  List<Object?> get props => [];
}

class SeaRealLoading extends SeaRealState {}

class SeaRealLoaded extends SeaRealState {
  final List<Wave?> waves;
  final List<User?> userPool;

  final bool loading;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;

  const SeaRealLoaded({
    required this.waves,
    required this.loading,
    required this.hasMore,
    required this.lastmyWaveDoc,
    required this.userPool,
  });

  @override
  List<Object?> get props => [
        waves,
        loading,
        hasMore,
        lastmyWaveDoc,
        userPool,
      ];

  SeaRealLoaded copyWith({
    List<Wave?>? waves,
    
    bool? loading,
    bool? hasMore,
    DocumentSnapshot? lastmyWaveDoc,
    List<User?>? userPool,
  }) {
    return SeaRealLoaded(
      waves: waves ?? this.waves,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      lastmyWaveDoc: lastmyWaveDoc ?? this.lastmyWaveDoc,
      userPool: userPool ?? this.userPool,
    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

