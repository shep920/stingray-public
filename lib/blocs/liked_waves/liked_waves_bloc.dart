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

part 'liked_waves_event.dart';
part 'liked_waves_state.dart';

class LikedWavesBloc extends Bloc<LikedWavesEvent, LikedWavesState> {
  final FirestoreRepository _firestoreRepository;

  LikedWavesBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(LikedWavesLoading()) {
    on<LoadLikedWaves>(_onLoadLikedWaves);
    on<UpdateLikedWaves>(_onUpdateLikedWaves);
    on<CloseLikedWaves>(_onCloseLikedWaves);
    on<PaginateWaves>(_paginateWaves);
    on<DeleteWave>(_onDeleteWave);

    // on<PaginateWaves>(_paginateWaves);

    on<RefreshLoads>(_refreshLoads);
  }

  Future<void> _onLoadLikedWaves(
    LoadLikedWaves event,
    Emitter<LikedWavesState> emit,
  ) async {
    DocumentSnapshot? _lastMyWaveDoc;
    final QuerySnapshot<Object?> _myWaveQuery =
        await _firestoreRepository.getLikedWaves(event.user.id!, null);
    if (_myWaveQuery.docs.isNotEmpty) {
      _lastMyWaveDoc = _myWaveQuery.docs.last;
    }
    final List<Wave?> _myWaves = Wave.waveListFromQuerySnapshot(_myWaveQuery);

    List<User?> _userPool = [];

    for (var wave in _myWaves) {
      User? _user = await _firestoreRepository.getFutureUser(wave!.senderId);
      _userPool.add(_user);
    }

    bool hasMore = _myWaves.length >= 10;

    add(UpdateLikedWaves(
      waves: _myWaves,
      hasMore: hasMore,
      lastmyWaveDoc: _lastMyWaveDoc,
      userPool: _userPool,
    ));
  }

  void _onUpdateLikedWaves(
    UpdateLikedWaves event,
    Emitter<LikedWavesState> emit,
  ) {
    emit(LikedWavesLoaded(
      waves: event.waves,
      hasMore: event.hasMore,
      loading: false,
      lastmyWaveDoc: event.lastmyWaveDoc,
      userPool: event.userPool,
    ));
  }

  // void _startStream(CloseLikedWaves event, Emitter<LikedWavesState> emit) {

  // }

  Future<void> _refreshLoads(
    RefreshLoads event,
    Emitter<LikedWavesState> emit,
  ) async {
    final state = this.state as LikedWavesLoaded;
    //get the client

    Wave? testWave = await _firestoreRepository.getTestWave(event.user.id!);

    //check if test is the same as the one in state
    if (state.waves.isNotEmpty && testWave != state.waves[0]) {
      add(LoadLikedWaves(
        user: event.user,
      ));
    } else {
      emit(state);
    }
  }

  //paginate s
  Future<void> _paginateWaves(
    PaginateWaves event,
    Emitter<LikedWavesState> emit,
  ) async {
    final state = this.state as LikedWavesLoaded;
    emit(state.copyWith(loading: true));
    bool hasMore = true;
  

    List<Wave?> _myOldWavess = state.waves;
    DocumentSnapshot<Object?>? _lastmyWavesDoc;
    List<User?> _userPool = state.userPool;

    final QuerySnapshot<Object?> _myWavesQuery = await _firestoreRepository
        .getLikedWaves(event.user.id!, state.lastmyWaveDoc);

    if (_myWavesQuery.docs.isNotEmpty) {
      _lastmyWavesDoc = _myWavesQuery.docs.last;
    }
    final List<Wave?> _myWaves = Wave.waveListFromQuerySnapshot(_myWavesQuery);

    List<Wave?> _myNewWaves = _myOldWavess + _myWaves;

    if (_myWaves.length < 10 || _myWaves.isEmpty) {
      hasMore = false;
    }

    for (var wave in _myWaves) {
      if (!_userPool.contains(wave!.senderId)) {
  User? _user = await _firestoreRepository.getFutureUser(wave.senderId);
  _userPool.add(_user);
}
    }



    add(UpdateLikedWaves(
      waves: _myNewWaves,
      hasMore: _myWaves.length >= 10,
      lastmyWaveDoc: _lastmyWavesDoc,
      userPool: _userPool,
    ));
  }

  void _onCloseLikedWaves(
    CloseLikedWaves event,
    Emitter<LikedWavesState> emit,
  ) {
    print('LikedWavesBloc disposed');

    emit(LikedWavesLoading());
  }

  Future<void> _onDeleteWave(
    DeleteWave event,
    Emitter<LikedWavesState> emit,
  ) async {
    final state = this.state as LikedWavesLoaded;

    await _firestoreRepository.deleteWave(event.wave);

    List<Wave?> _myOldWavess = state.waves;
    _myOldWavess.remove(event.wave);
    emit(LikedWavesLoading());
    emit(state.copyWith(waves: _myOldWavess));
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
