part of 'wave_bloc.dart';

abstract class WaveEvent extends Equatable {
  const WaveEvent();

  @override
  List<Object?> get props => [];
}

class LoadWave extends WaveEvent {
  final List<Stingray?> stingrays;

  const LoadWave({
    required this.stingrays,
  });

  @override
  List<Object?> get props => [stingrays];
}

class UpdateWave extends WaveEvent {
  final List<WavesMeta> waveMeta;
  final Timer? timer;
  final WavesMeta featuredWavesMeta;
  final WavesMeta hotfeaturedWavesMeta;
  final String featureSortParam;
  const UpdateWave(
      {required this.waveMeta,
      required this.timer,
      required this.featuredWavesMeta,
      required this.hotfeaturedWavesMeta,
      
      required this.featureSortParam});

  @override
  List<Object?> get props => [waveMeta, timer, featuredWavesMeta, hotfeaturedWavesMeta, featureSortParam];
}

class CreateWave extends WaveEvent {
  final User sender;
  final String message;
  final File? file;
  final String? style;
  final List<File>? bubbleImages;

  CreateWave({
    required this.sender,
    required this.message,
    required this.file,
    this.style,
    this.bubbleImages,
  });

  @override
  List<Object?> get props => [sender, message, file, style, bubbleImages];
}

class CreateWaveThread extends WaveEvent {
  final User sender;
  final List<String> messages;
  final List<File?> files;
  final String waveType;
  CreateWaveThread({
    required this.sender,
    required this.messages,
    required this.files,
    required this.waveType,
  });

  @override
  List<Object?> get props => [sender, messages, files, waveType];
}

class CloseWave extends WaveEvent {
  const CloseWave();

  @override
  List<Object?> get props => [];
}

class RefreshStingrayWaves extends WaveEvent {
  final Stingray stingray;

  const RefreshStingrayWaves({required this.stingray});

  @override
  List<Object?> get props => [stingray];
}

class PaginateWaves extends WaveEvent {
  final Stingray stingray;

  const PaginateWaves({required this.stingray});

  @override
  List<Object?> get props => [stingray];
}

class UpdateLoadingStatus extends WaveEvent {
  const UpdateLoadingStatus();

  @override
  List<Object?> get props => [];
}

class ReportWave extends WaveEvent {
  final Wave wave;
  final User reporter;
  final User reported;

  const ReportWave({
    required this.wave,
    required this.reporter,
    required this.reported,
  });

  @override
  List<Object?> get props => [wave, reporter, reported];
}

class DeleteWave extends WaveEvent {
  final Wave wave;

  const DeleteWave({
    required this.wave,
  });

  @override
  List<Object?> get props => [wave];
}

class UpdateSortParam extends WaveEvent {
  final String sortParam;

  const UpdateSortParam({
    required this.sortParam,
  });

  @override
  List<Object?> get props => [sortParam];
}


