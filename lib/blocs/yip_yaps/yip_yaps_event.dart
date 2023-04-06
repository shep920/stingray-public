part of 'yip_yaps_bloc.dart';

abstract class YipYapsEvent extends Equatable {
  const YipYapsEvent();

  @override
  List<Object?> get props => [];
}

class LoadYipYaps extends YipYapsEvent {
  final User user;

  const LoadYipYaps({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseYipYaps extends YipYapsEvent {
  const CloseYipYaps();

  @override
  List<Object?> get props => [];
}

class UpdateYipYaps extends YipYapsEvent {
  final List<Wave?> yipYaps;
  final bool hasMore;
  final DocumentSnapshot? lastmyWaveDoc;

  const UpdateYipYaps(
      {required this.yipYaps,
      required this.hasMore,
      required this.lastmyWaveDoc});

  @override
  List<Object?> get props => [
        yipYaps,
        hasMore,
        lastmyWaveDoc,
      ];
}

class PaginateYipYaps extends YipYapsEvent {
  final User user;

  const PaginateYipYaps({required this.user});

  @override
  List<Object?> get props => [user];
}

class RefreshLoads extends YipYapsEvent {
  final User user;

  const RefreshLoads({required this.user});

  @override
  List<Object?> get props => [user];
}

class DeleteYipYap extends YipYapsEvent {
  final Wave wave;

  const DeleteYipYap({required this.wave});

  @override
  List<Object?> get props => [wave];
}