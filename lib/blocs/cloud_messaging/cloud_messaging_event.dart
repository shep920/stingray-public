part of 'cloud_messaging_bloc.dart';

abstract class CloudMessagingEvent extends Equatable {
  const CloudMessagingEvent();

  @override
  List<Object?> get props => [];
}

class LoadCloudMessaging extends CloudMessagingEvent {
  final String id;
  const LoadCloudMessaging({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateCloudMessaging extends CloudMessagingEvent {
  final String? token;
  final String id;

  const UpdateCloudMessaging(this.id, {required this.token});

  @override
  List<Object?> get props => [token, id];
}
