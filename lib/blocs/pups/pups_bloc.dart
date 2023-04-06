import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/models/leaderboard_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../repository/typesense_repo.dart';
import '../typesense/bloc/search_bloc.dart';

part 'pups_event.dart';
part 'pups_state.dart';

class PupsBloc extends Bloc<PupsEvent, PupsState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;

  PupsBloc(
      {required FirestoreRepository databaseRepository,
      required TypesenseRepository typesenseRepository})
      : _firestoreRepository = databaseRepository,
        _typesenseRepository = typesenseRepository,
        super(PupsLoading()) {
    on<LoadPups>(_onLoadPups);
    on<UpdatePups>(_onUpdatePups);
    on<ClosePups>(_onClosePups);
  }

  Future<void> _onLoadPups(
    LoadPups event,
    Emitter<PupsState> emit,
  ) async {
    List<User?> pups = [];

    pups = await _typesenseRepository.getSuperPups(event.user);

    add(
      UpdatePups(pups: pups),
    );
  }

  void _onUpdatePups(
    UpdatePups event,
    Emitter<PupsState> emit,
  ) {
    List<User?> pups = event.pups;

    pups.sort((a, b) => b!.votes.compareTo(a!.votes));
    emit(PupsLoaded(pups: pups));
  }

  void _onClosePups(
    ClosePups event,
    Emitter<PupsState> emit,
  ) {
    print('PupsBloc disposed');

    emit(PupsLoading());
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
