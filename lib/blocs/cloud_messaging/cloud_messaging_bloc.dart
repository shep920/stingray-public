import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';

import '../../repository/messaging_repository.dart';

part 'cloud_messaging_event.dart';
part 'cloud_messaging_state.dart';

class CloudMessagingBloc
    extends Bloc<CloudMessagingEvent, CloudMessagingState> {
  final FirestoreRepository _firestoreRepository;
  final MessagingRepository _messagingRepository;

  CloudMessagingBloc({
    required FirestoreRepository databaseRepository,
    required MessagingRepository messagingRepository,
  })  : _firestoreRepository = databaseRepository,
        _messagingRepository = messagingRepository,
        super(CloudMessagingLoading()) {
    on<LoadCloudMessaging>(_onLoadCloudMessaging);
    on<UpdateCloudMessaging>(_onUpdateCloudMessaging);
  }

  void _onLoadCloudMessaging(
    LoadCloudMessaging event,
    Emitter<CloudMessagingState> emit,
  ) {
    _messagingRepository.getToken().then((token) {
      add(
        UpdateCloudMessaging(event.id, token: token),
      );
    });
  }

  void _onUpdateCloudMessaging(
    UpdateCloudMessaging event,
    Emitter<CloudMessagingState> emit,
  ) {
    print('token from bloc: ${event.token}');
    _firestoreRepository.updateDeviceToken(event.id, event.token);
    emit(CloudMessagingLoaded());
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
