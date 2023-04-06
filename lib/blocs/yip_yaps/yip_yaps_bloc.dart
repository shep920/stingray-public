import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';

import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/posts/yip_yap_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../models/chat_viewers_model.dart';
import '../../models/discovery_chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../repository/typesense_repo.dart';

part 'yip_yaps_event.dart';
part 'yip_yaps_state.dart';

class YipYapsBloc extends Bloc<YipYapsEvent, YipYapsState> {
  final FirestoreRepository _firestoreRepository;

  YipYapsBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(YipYapsLoading()) {
    on<LoadYipYaps>(_onLoadYipYaps);
    on<UpdateYipYaps>(_onUpdateYipYaps);
    on<CloseYipYaps>(_onCloseYipYaps);
    on<PaginateYipYaps>(_paginateWaves);

    // on<PaginateYipYaps>(_paginateWaves);

    on<RefreshLoads>(_refreshLoads);
    on<DeleteYipYap>(_onDeleteWave);
  }

  Future<void> _onLoadYipYaps(
    LoadYipYaps event,
    Emitter<YipYapsState> emit,
  ) async {
    DocumentSnapshot? _lastMyWaveDoc;
    final QuerySnapshot<Object?> _myWaveQuery =
        await _firestoreRepository.getYipYaps(lastDocument: null);
    if (_myWaveQuery.docs.isNotEmpty) {
      _lastMyWaveDoc = _myWaveQuery.docs.last;
    }
    final List<Wave?> _yipWaves = Wave.waveListFromQuerySnapshot(_myWaveQuery);

    //cast _yipyaps to type Wave
    final List<Wave?> _yipYaps = _yipWaves.cast<Wave?>().toList();

    bool hasMore = _yipYaps.length >= 10;

    add(UpdateYipYaps(
      yipYaps: _yipYaps,
      hasMore: hasMore,
      lastmyWaveDoc: _lastMyWaveDoc,
    ));
  }

  void _onUpdateYipYaps(
    UpdateYipYaps event,
    Emitter<YipYapsState> emit,
  ) {
    emit(YipYapsLoaded(
      yipYaps: event.yipYaps,
      hasMore: event.hasMore,
      loading: false,
      lastmyWaveDoc: event.lastmyWaveDoc,
    ));
  }

  // void _startStream(CloseYipYaps event, Emitter<YipYapsState> emit) {

  // }

  Future<void> _refreshLoads(
    RefreshLoads event,
    Emitter<YipYapsState> emit,
  ) async {
    final state = this.state as YipYapsLoaded;
    //get the client

    Wave? testWave = await _firestoreRepository.getTestWave(event.user.id!);

    //check if test is the same as the one in state
    if (state.yipYaps.isNotEmpty && testWave != state.yipYaps[0]) {
      add(LoadYipYaps(
        user: event.user,
      ));
    } else {
      emit(state);
    }
  }

  //paginate s
  Future<void> _paginateWaves(
    PaginateYipYaps event,
    Emitter<YipYapsState> emit,
  ) async {
    final state = this.state as YipYapsLoaded;
    emit(state.copyWith(loading: true));
    bool hasMore = true;

    List<Wave?> _myOldWavess = state.yipYaps;
    DocumentSnapshot<Object?>? _lastYipYapsDoc;

    final QuerySnapshot<Object?> _yipYapsQuery = await _firestoreRepository
        .getYipYaps(lastDocument: state.lastmyWaveDoc);

    if (_yipYapsQuery.docs.isNotEmpty) {
      _lastYipYapsDoc = _yipYapsQuery.docs.last;
    }
    final List<Wave?> _yipYaps =
        Wave.waveListFromQuerySnapshot(_yipYapsQuery) as List<Wave?>;

    List<Wave?> _myNewWaves = _myOldWavess + _yipYaps;

    if (_yipYaps.length < 10 || _yipYaps.isEmpty) {
      hasMore = false;
    }

    add(UpdateYipYaps(
      yipYaps: _myNewWaves,
      hasMore: _yipYaps.length >= 10,
      lastmyWaveDoc: _lastYipYapsDoc,
    ));
  }

  void _onCloseYipYaps(
    CloseYipYaps event,
    Emitter<YipYapsState> emit,
  ) {
    print('YipYapsBloc disposed');

    emit(YipYapsLoading());
  }

  //on delete wave
  Future<void> _onDeleteWave(
    DeleteYipYap event,
    Emitter<YipYapsState> emit,
  ) async {
    final state = this.state as YipYapsLoaded;

    if (state.yipYaps.isNotEmpty) {
      List<Wave?> _myOldWavess = state.yipYaps;
      _myOldWavess.remove(event.wave);

      emit(YipYapsLoading());

      add(UpdateYipYaps(
        yipYaps: _myOldWavess,
        hasMore: state.hasMore,
        lastmyWaveDoc: state.lastmyWaveDoc,
      ));
    } else {
      emit(state);
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
