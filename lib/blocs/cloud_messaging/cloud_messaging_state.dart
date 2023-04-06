part of 'cloud_messaging_bloc.dart';

abstract class CloudMessagingState extends Equatable {
  const CloudMessagingState();

  @override
  List<Object> get props => [];
}

class CloudMessagingLoading extends CloudMessagingState {}

class CloudMessagingLoaded extends CloudMessagingState {
  

  const CloudMessagingLoaded();

  @override
  List<Object> get props => [];
}
