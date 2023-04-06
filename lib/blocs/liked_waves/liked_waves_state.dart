part of 'liked_waves_bloc.dart';

abstract class LikedWavesState extends Equatable {
  const LikedWavesState();

  @override
  List<Object?> get props => [];
}

class LikedWavesLoading extends LikedWavesState {}

class LikedWavesLoaded extends LikedWavesState {
  final List<Wave?> waves;
  final List<User?> userPool;

  final bool loading;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;

  const LikedWavesLoaded({
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

  LikedWavesLoaded copyWith({
    List<Wave?>? waves,
    
    bool? loading,
    bool? hasMore,
    DocumentSnapshot? lastmyWaveDoc,
    List<User?>? userPool,
  }) {
    return LikedWavesLoaded(
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
 

