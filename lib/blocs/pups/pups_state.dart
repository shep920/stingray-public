part of 'pups_bloc.dart';

abstract class PupsState extends Equatable {
  const PupsState();

  @override
  List<Object> get props => [];
}

class PupsLoading extends PupsState {}

class PupsLoaded extends PupsState {
  final List<User?> pups;

  const PupsLoaded({required this.pups});

  @override
  List<Object> get props => [pups];
}
