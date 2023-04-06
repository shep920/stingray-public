import 'package:equatable/equatable.dart';

class Troll extends Equatable {
  final String waveId;
  final int timesViewed;
  final int maxAllowed;

  Troll({
    required this.waveId,
    required this.timesViewed,
    required this.maxAllowed,
  });

  @override
  List<Object?> get props => [waveId, timesViewed, maxAllowed];

  //make a copywith
  Troll copyWith({
    String? waveId,
    int? timesViewed,
    int? maxAllowed,
  }) {
    return Troll(
      waveId: waveId ?? this.waveId,
      timesViewed: timesViewed ?? this.timesViewed,
      maxAllowed: maxAllowed ?? this.maxAllowed,
    );
  }
}
