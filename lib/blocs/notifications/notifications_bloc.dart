import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:hero/models/models.dart';
import 'package:hero/models/user_search_view_model.dart';
import 'package:hero/repository/firestore_repository.dart';

import '../../models/user_notifications/user_notification_model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FirestoreRepository _firestoreRepository;

  NotificationsBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(NotificationsLoading()) {
    on<NotificationsEvent>((event, emit) {});

    on<LoadNotificationsEvent>(_loadNotifications);
    on<UpdateNotifications>(_updateNotifications);

    on<CloseNotifications>(_onCloseNotifications);
  }

  _loadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      {
        List<UserNotification?> notifications = [];
        notifications =
            await _firestoreRepository.getNotifications(event.user!.id);

        add(
          UpdateNotifications(notifications: notifications),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _onCloseNotifications(
    CloseNotifications event,
    Emitter<NotificationsState> emit,
  ) {
    print('NotificationsBloc disposed');

    emit(NotificationsLoading());
  }

  Future<void> _updateNotifications(
    UpdateNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      {
        emit(NotificationsLoaded(
          notifications: event.notifications,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> close() async {
    super.close();
  }
}
