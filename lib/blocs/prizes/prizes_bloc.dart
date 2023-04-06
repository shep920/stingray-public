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
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';

import '../../models/chat_model.dart';

part 'prizes_event.dart';
part 'prizes_state.dart';

class PrizesBloc extends Bloc<PrizesEvent, PrizesState> {
  final FirestoreRepository _firestoreRepository;
  final StorageRepository _storageRepository;
  late StreamSubscription _prizeSubscription;

  PrizesBloc({
    required FirestoreRepository databaseRepository,
    required StorageRepository storageRepository,
  })  : _firestoreRepository = databaseRepository,
        _storageRepository = storageRepository,
        super(PrizesLoading()) {
    on<LoadPrizes>(_onLoadPrizes);
    on<UpdatePrizes>(_onUpdatePrizes);

    on<ClosePrizes>(_onClosePrizes);
    on<CreatePrize>(_onCreatePrize);
    on<DeletePrize>(_onDeletePrize);
    on<ChangePrizeRemaining>(_onChangePrizeRemaining);
  }

  void _onLoadPrizes(
    LoadPrizes event,
    Emitter<PrizesState> emit,
  ) {
    _prizeSubscription = _firestoreRepository.prizes.listen((prizes) {
      add(
        UpdatePrizes(prizes: prizes),
      );
    });
  }

  void _onUpdatePrizes(
    UpdatePrizes event,
    Emitter<PrizesState> emit,
  ) {
    emit(PrizesLoaded(prizes: event.prizes));
  }

  Future<void> _onClosePrizes(
    ClosePrizes event,
    Emitter<PrizesState> emit,
  ) async {
    //get the user from the PrizesLoaded state

    //close the profile
    _prizeSubscription.cancel();
  }

  Future<void> _onCreatePrize(
    CreatePrize event,
    Emitter<PrizesState> emit,
  ) async {
    Prize prize = event.prize;
    if (event.image != null) {
      {
        _storageRepository.uploadPrizeImage(
          image: event.image!,
          prizeId: prize.id,
        );
        String imageUrl =
            await _storageRepository.getPrizeImageUrl(event.image!, prize.id);
        prize = prize.copyWith(imageUrl: imageUrl);
      }
    }

    _firestoreRepository.createPrize(prize: event.prize);
  }

  Future<void> _onDeletePrize(
    DeletePrize event,
    Emitter<PrizesState> emit,
  ) async {
    _firestoreRepository.deletePrize(prizeId: event.prize.id);
  }

  Future<void> _onChangePrizeRemaining(
    ChangePrizeRemaining event,
    Emitter<PrizesState> emit,
  ) async {
    _firestoreRepository.changePrizeRemaining(
        prizeId: event.prize.id, remaining: event.remaining);
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
