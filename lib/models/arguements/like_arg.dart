import 'package:equatable/equatable.dart';
import 'package:hero/models/user_model.dart';

class LikeArg extends Equatable {
  final String waveId;
  final User poster;

  LikeArg({
    required this.waveId,
    required this.poster,
  });

  @override
  List<Object?> get props => [waveId, poster];
}
