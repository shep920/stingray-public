part of 'trolling_cubit.dart';

abstract class TrollingPoliceState extends Equatable {
  const TrollingPoliceState();

  @override
  List<Object?> get props => [];
}

class TrollingPoliceNormal extends TrollingPoliceState {
  final List<Troll> trolls;
  final Timer? timer;

  const TrollingPoliceNormal({required this.trolls, required this.timer});

  @override
  List<Object?> get props => [trolls, timer];
}


