part of 'user_discovery_bloc.dart';

abstract class UserDiscoveryEvent extends Equatable {
  const UserDiscoveryEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserDiscoveryEvent {
  final List<User> users;

  LoadUsers({
    required this.users,
  });

  @override
  List<Object?> get props => [users];
}

class UpdateHome extends UserDiscoveryEvent {
  final List<User>? users;

  UpdateHome({
    required this.users,
  });

  @override
  List<Object?> get props => [
        users,
      ];
}

class UserDiscoverySwipeLeft extends UserDiscoveryEvent {
  final User sender;
  final User receiver;

  UserDiscoverySwipeLeft({
    required this.sender,
    required this.receiver,
  });

  @override
  List<Object?> get props => [sender, receiver];
}

class UserDiscoverySwipeRight extends UserDiscoveryEvent {
  final User sender;
  final User receiver;

  UserDiscoverySwipeRight({
    required this.sender,
    required this.receiver,
  });

  @override
  List<Object?> get props => [sender, receiver];
}

class UserDiscoverySendMessage extends UserDiscoveryEvent {
  final String message;
  final User sender;
  final User receiver;

  UserDiscoverySendMessage({
    required this.message,
    required this.sender,
    required this.receiver,
  });

  @override
  List<Object?> get props => [message, sender, receiver];
}

class IncrementUserDiscoveryImageUrlIndex extends UserDiscoveryEvent {
  const IncrementUserDiscoveryImageUrlIndex();

  @override
  List<Object> get props => [];
}

class DecrementUserDiscoveryImageUrlIndex extends UserDiscoveryEvent {
  const DecrementUserDiscoveryImageUrlIndex();

  @override
  List<Object> get props => [];
}

class CancelMessage extends UserDiscoveryEvent {
  final User sender;
  final User receiver;
  const CancelMessage({
    required this.sender,
    required this.receiver,
  });

  @override
  List<Object> get props => [sender, receiver];
}
