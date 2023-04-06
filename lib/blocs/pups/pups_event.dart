part of 'pups_bloc.dart';

abstract class PupsEvent extends Equatable {
  const PupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPups extends PupsEvent {
  final User user;
  const LoadPups({required this.user});

  @override
  List<Object?> get props => [user];
}

class ClosePups extends PupsEvent {
  const ClosePups();

  @override
  List<Object?> get props => [];
}

class UpdatePups extends PupsEvent {
  final List<User?> pups;

  const UpdatePups({required this.pups});

  @override
  List<Object> get props => [pups];
}
