part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationsEvent {
  final User? user;

  LoadNotificationsEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class NotificationsUserEvent extends NotificationsEvent {
  final User user;

  const NotificationsUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateNotifications extends NotificationsEvent {
  final List<UserNotification?> notifications;

  const UpdateNotifications({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class LoadUserFromFirestore extends NotificationsEvent {
  final String? userId;

  LoadUserFromFirestore(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserFromFirestore extends NotificationsEvent {
  final User user;

  const UpdateUserFromFirestore({required this.user});

  @override
  List<Object> get props => [user];
}

class IncrementImageUrlIndex extends NotificationsEvent {
  final int imageUrlIndex;

  const IncrementImageUrlIndex({
    required this.imageUrlIndex,
  });

  @override
  List<Object> get props => [imageUrlIndex];
}

class DecrementImageUrlIndex extends NotificationsEvent {
  final int imageUrlIndex;

  const DecrementImageUrlIndex({
    required this.imageUrlIndex,
  });

  @override
  List<Object> get props => [imageUrlIndex];
}

class CloseNotifications extends NotificationsEvent {
  const CloseNotifications();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsUserFromHandle extends NotificationsEvent {
  final String handle;
  final BuildContext context;

  const LoadNotificationsUserFromHandle(
      {required this.handle, required this.context});

  @override
  List<Object> get props => [handle, context];
}
