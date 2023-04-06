part of 'sea_real_bloc.dart';

abstract class SeaRealEvent extends Equatable {
  const SeaRealEvent();

  @override
  List<Object?> get props => [];
}

class LoadSeaReal extends SeaRealEvent {
  final User user;

  const LoadSeaReal({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseSeaReal extends SeaRealEvent {
  const CloseSeaReal();

  @override
  List<Object?> get props => [];
}

class UpdateSeaReal extends SeaRealEvent {
  final List<Wave?> waves;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;
  final List<User?> userPool;

  const UpdateSeaReal(
      {required this.waves,
      required this.hasMore,
      required this.lastmyWaveDoc,
      required this.userPool});

  @override
  List<Object?> get props => [
        waves,
        hasMore,
        lastmyWaveDoc,
      ];
}

class PaginateWaves extends SeaRealEvent {
  final User user;

  const PaginateWaves({required this.user});

  @override
  List<Object?> get props => [user];
}

class RefreshLoads extends SeaRealEvent {
  final User user;

  const RefreshLoads({required this.user});

  @override
  List<Object?> get props => [user];
}

class DeleteWave extends SeaRealEvent {
  final Wave wave;

  const DeleteWave({
    required this.wave,
  });

  @override
  List<Object?> get props => [wave];
}

class CreateSeaReal extends SeaRealEvent {
  final User sender;
  final File frontImage;
  final File backImage;
  final bool retaken;

  CreateSeaReal({
    required this.sender,
    required this.frontImage,
    required this.backImage,
    required this.retaken,
  });

  @override
 
 List<Object?> get props => [sender, frontImage, backImage, retaken];
}