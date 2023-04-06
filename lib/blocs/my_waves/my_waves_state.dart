part of 'my_waves_bloc.dart';

abstract class MyWavesState extends Equatable {
  const MyWavesState();

  @override
  List<Object?> get props => [];
}

class MyWavesLoading extends MyWavesState {}

class MyWavesLoaded extends MyWavesState {
  final List<Wave?> waves;

  final bool loading;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;

  const MyWavesLoaded({
    required this.waves,
    required this.loading,
    required this.hasMore,
    required this.lastmyWaveDoc,
  });

  @override
  List<Object?> get props => [
        waves,
        loading,
        hasMore,
        lastmyWaveDoc,
      ];

  MyWavesLoaded copyWith({
    List<Wave?>? waves,
    
    bool? loading,
    bool? hasMore,
    DocumentSnapshot? lastmyWaveDoc,
  }) {
    return MyWavesLoaded(
      waves: waves ?? this.waves,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      lastmyWaveDoc: lastmyWaveDoc ?? this.lastmyWaveDoc,
    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

