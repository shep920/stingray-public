part of 'wave_bloc.dart';

abstract class WaveState extends Equatable {
  const WaveState();

  @override
  List<Object?> get props => [];
}

class WaveLoading extends WaveState {}

class WaveLoaded extends WaveState {
  final List<WavesMeta> wavesMeta;
  final WavesMeta featuredWavesMeta;
  final WavesMeta hotfeaturedWavesMeta;
  //add a timer to the state
  final Timer? timer;
  final bool isLoading;
  final bool hasMore;
  final String featureSortParam;

  const WaveLoaded({
    required this.featuredWavesMeta,
    required this.wavesMeta,
    required this.timer,
    required this.isLoading,
    required this.hasMore,
    required this.featureSortParam,
    required this.hotfeaturedWavesMeta,
  });

  @override
  List<Object?> get props => [
        featuredWavesMeta,
        wavesMeta,
        timer,
        isLoading,
        featureSortParam,
        hotfeaturedWavesMeta,
      ];

  //make a copyWith method to make it easier to update the state
  WaveLoaded copyWith({
    List<WavesMeta>? wavesMeta,
    WavesMeta? featuredWavesMeta,
    Timer? timer,
    bool? isLoading,
    bool? hasMore,
    String? featureSortParam,
    WavesMeta? hotfeaturedWavesMeta,
  }) {
    return WaveLoaded(
      featuredWavesMeta: featuredWavesMeta ?? this.featuredWavesMeta,
      wavesMeta: wavesMeta ?? this.wavesMeta,
      timer: timer ?? this.timer,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      featureSortParam: featureSortParam ?? this.featureSortParam,
      hotfeaturedWavesMeta: hotfeaturedWavesMeta ?? this.hotfeaturedWavesMeta,
    );
  }
}
