import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';

import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../models/chat_viewers_model.dart';
import '../../models/discovery_chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../repository/typesense_repo.dart';

part 'my_waves_event.dart';
part 'my_waves_state.dart';

class MyWavesBloc extends Bloc<MyWavesEvent, MyWavesState> {
  final FirestoreRepository _firestoreRepository;

  MyWavesBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(MyWavesLoading()) {
    on<LoadMyWaves>(_onLoadMyWaves);
    on<UpdateMyWaves>(_onUpdateMyWaves);
    on<CloseMyWaves>(_onCloseMyWaves);
    on<PaginateWaves>(_paginateWaves);
    on<DeleteWave>(_onDeleteWave);

    // on<PaginateWaves>(_paginateWaves);

    on<RefreshLoads>(_refreshLoads);
  }

  Future<void> _onLoadMyWaves(
    LoadMyWaves event,
    Emitter<MyWavesState> emit,
  ) async {
    DocumentSnapshot? _lastMyWaveDoc;
    final QuerySnapshot<Object?> _myWaveQuery =
        await _firestoreRepository.getMyWaves(event.user.id!, null);
    if (_myWaveQuery.docs.isNotEmpty) {
      _lastMyWaveDoc = _myWaveQuery.docs.last;
    }
    final List<Wave?> _myWaves = Wave.waveListFromQuerySnapshot(_myWaveQuery);

    bool hasMore = _myWaves.length >= 10;

    add(UpdateMyWaves(
      waves: _myWaves,
      hasMore: hasMore,
      lastmyWaveDoc: _lastMyWaveDoc,
    ));
  }

  void _onUpdateMyWaves(
    UpdateMyWaves event,
    Emitter<MyWavesState> emit,
  ) {
    emit(MyWavesLoaded(
      waves: event.waves,
      hasMore: event.hasMore,
      loading: false,
      lastmyWaveDoc: event.lastmyWaveDoc,
    ));
  }

  // void _startStream(CloseMyWaves event, Emitter<MyWavesState> emit) {

  // }

  Future<void> _refreshLoads(
    RefreshLoads event,
    Emitter<MyWavesState> emit,
  ) async {
    final state = this.state as MyWavesLoaded;
    //get the client

    Wave? testWave = await _firestoreRepository.getTestWave(event.user.id!);

    //check if test is the same as the one in state
    if (state.waves.isNotEmpty && testWave != state.waves[0]) {
      add(LoadMyWaves(
        user: event.user,
      ));
    } else {
      emit(state);
    }
  }

  //paginate s
  Future<void> _paginateWaves(
    PaginateWaves event,
    Emitter<MyWavesState> emit,
  ) async {
    final state = this.state as MyWavesLoaded;
    emit(state.copyWith(loading: true));
    bool hasMore = true;

    List<Wave?> _myOldWavess = state.waves;
    DocumentSnapshot<Object?>? _lastmyWavesDoc;

    final QuerySnapshot<Object?> _myWavesQuery = await _firestoreRepository
        .getMyWaves(event.user.id!, state.lastmyWaveDoc);

    if (_myWavesQuery.docs.isNotEmpty) {
      _lastmyWavesDoc = _myWavesQuery.docs.last;
    }
    final List<Wave?> _myWaves = Wave.waveListFromQuerySnapshot(_myWavesQuery);

    List<Wave?> _myNewWaves = _myOldWavess + _myWaves;

    if (_myWaves.length < 10 || _myWaves.isEmpty) {
      hasMore = false;
    }

    add(UpdateMyWaves(
      waves: _myNewWaves,
      hasMore: _myWaves.length >= 10,
      lastmyWaveDoc: _lastmyWavesDoc,
    ));
  }

  void _onCloseMyWaves(
    CloseMyWaves event,
    Emitter<MyWavesState> emit,
  ) {
    print('MyWavesBloc disposed');

    emit(MyWavesLoading());
  }

  Future<void> _onDeleteWave(
    DeleteWave event,
    Emitter<MyWavesState> emit,
  ) async {
    final state = this.state as MyWavesLoaded;

    await _firestoreRepository.deleteWave(event.wave);

    List<Wave?> _myOldWavess = state.waves;
    _myOldWavess.remove(event.wave);
    emit(MyWavesLoading());
    emit(state.copyWith(waves: _myOldWavess));
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
