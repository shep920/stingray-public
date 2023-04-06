import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:hero/models/backpack_item_model.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';

import '../../models/chat_model.dart';

part 'backpack_event.dart';
part 'backpack_state.dart';

class BackpackBloc extends Bloc<BackpackEvent, BackpackState> {
  final FirestoreRepository _firestoreRepository;
  final StorageRepository _storageRepository;
  late StreamSubscription _prizeSubscription;

  BackpackBloc({
    required FirestoreRepository databaseRepository,
    required StorageRepository storageRepository,
  })  : _firestoreRepository = databaseRepository,
        _storageRepository = storageRepository,
        super(BackpackLoading()) {
    on<LoadBackpack>(_onLoadBackpack);
    on<UpdateBackpack>(_onUpdateBackpack);

    on<CloseBackpack>(_onCloseBackpack);
    on<UseItem>(_onUseItem);
  }

  void _onLoadBackpack(
    LoadBackpack event,
    Emitter<BackpackState> emit,
  ) {
    _prizeSubscription = _firestoreRepository
        .getBackPackItemsStream(event.id)
        .listen((backpack) {
      add(
        UpdateBackpack(backpack: backpack),
      );
    });
  }

  void _onUpdateBackpack(
    UpdateBackpack event,
    Emitter<BackpackState> emit,
  ) {
    emit(BackpackLoaded(backpack: event.backpack));
  }

  Future<void> _onCloseBackpack(
    CloseBackpack event,
    Emitter<BackpackState> emit,
  ) async {
    _prizeSubscription.cancel();
  }

  Future<void> _onUseItem(
    UseItem event,
    Emitter<BackpackState> emit,
  ) async {
    functionSwitch(event.item.functionName, event.userId);
    _firestoreRepository.useItem(userId: event.userId, item: event.item);
  }

  functionSwitch(String functionName, String userId) {
    switch (functionName) {
      case Prize.addFiveVotesFunction:
        _firestoreRepository.addVotesUsable(id: userId, votesUsable: 5);
        break;
      case Prize.addTenVotesFunction:
        _firestoreRepository.addVotesUsable(id: userId, votesUsable: 10);
        break;
      case Prize.addTwoVotesFunction:
        _firestoreRepository.addVotesUsable(id: userId, votesUsable: 2);
        break;
      case Prize.addTwoVotesFunction:
        _firestoreRepository.addVotesUsable(id: userId, votesUsable: 2);
        break;
      case Prize.validateFunction:
        break;
      default:
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
