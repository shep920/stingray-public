part of 'yip_yaps_bloc.dart';

abstract class YipYapsState extends Equatable {
  const YipYapsState();

  @override
  List<Object?> get props => [];
}

class YipYapsLoading extends YipYapsState {}

class YipYapsLoaded extends YipYapsState {
  final List<Wave?> yipYaps;
  final bool loading;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;

  const YipYapsLoaded({
    required this.yipYaps,
    required this.loading,
    required this.hasMore,
    required this.lastmyWaveDoc,
  });

  @override
  List<Object?> get props => [
        yipYaps,
        loading,
        hasMore,
        lastmyWaveDoc,
      ];

  YipYapsLoaded copyWith({
    List<Wave?>? yipYaps,
    
    bool? loading,
    bool? hasMore,
    DocumentSnapshot? lastmyWaveDoc,
  }) {
    return YipYapsLoaded(
      yipYaps: yipYaps ?? this.yipYaps,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      lastmyWaveDoc: lastmyWaveDoc ?? this.lastmyWaveDoc,
    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

