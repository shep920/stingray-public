part of 'user_discovery_bloc.dart';

abstract class UserDiscoveryState extends Equatable {
  const UserDiscoveryState();

  @override
  List<Object> get props => [];
}

class UserDiscoveryLoading extends UserDiscoveryState {}

class UserDiscoveryLoaded extends UserDiscoveryState {
  final int imageUrlIndex;
  final List<User> users;

  UserDiscoveryLoaded({
    required this.imageUrlIndex,
    required this.users,
  });

  @override
  List<Object> get props => [users, imageUrlIndex];
}

class UserDiscoveryError extends UserDiscoveryState {}

class UserDiscoveryEmpty extends UserDiscoveryState {}

class UserDiscoverySendMessageState extends UserDiscoveryState {
  final User user;
  final int imageUrlIndex;
  final List<User> users;


  UserDiscoverySendMessageState({required this.user, required this.imageUrlIndex, required this.users});

  @override
  List<Object> get props => [user, imageUrlIndex, users];
}
