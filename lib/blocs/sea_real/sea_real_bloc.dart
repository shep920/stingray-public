import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';

import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/helpers/is_wave.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_viewers_model.dart';
import '../../models/discovery_chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../repository/typesense_repo.dart';

part 'sea_real_event.dart';
part 'sea_real_state.dart';

class SeaRealBloc extends Bloc<SeaRealEvent, SeaRealState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepo;
  final StorageRepository _storageRepository;

  SeaRealBloc({
    required FirestoreRepository firestoreRepository,
    required TypesenseRepository typesenseRepo,
    required StorageRepository storageRepository,
  })  : _firestoreRepository = firestoreRepository,
        _typesenseRepo = typesenseRepo,
        _storageRepository = storageRepository,
        super(SeaRealLoading()) {
    on<LoadSeaReal>(_onLoadSeaReal);
    on<UpdateSeaReal>(_onUpdateSeaReal);
    on<CloseSeaReal>(_onCloseSeaReal);
    on<PaginateWaves>(_paginateWaves);
    on<DeleteWave>(_onDeleteWave);
    on<CreateSeaReal>(_onCreateSeaReal);

    // on<PaginateWaves>(_paginateWaves);

    on<RefreshLoads>(_refreshLoads);
  }

  Future<void> _onLoadSeaReal(
    LoadSeaReal event,
    Emitter<SeaRealState> emit,
  ) async {
    DocumentSnapshot? _lastMyWaveDoc;
    final List<Wave?> _myWaves =
        await _typesenseRepo.getSeaReals(waveIds: [], user: event.user);

    List<User?> _userPool = [];

    for (var wave in _myWaves) {
      User? _user = await _firestoreRepository.getFutureUser(wave!.senderId);
      _userPool.add(_user);
    }

    bool hasMore = _myWaves.length >= 5;

    add(UpdateSeaReal(
      waves: _myWaves,
      hasMore: hasMore,
      lastmyWaveDoc: _lastMyWaveDoc,
      userPool: _userPool,
    ));
  }

  void _onUpdateSeaReal(
    UpdateSeaReal event,
    Emitter<SeaRealState> emit,
  ) {
    emit(SeaRealLoading());

    emit(SeaRealLoaded(
      waves: event.waves,
      hasMore: event.hasMore,
      loading: false,
      lastmyWaveDoc: event.lastmyWaveDoc,
      userPool: event.userPool,
    ));
  }

  // void _startStream(CloseSeaReal event, Emitter<SeaRealState> emit) {

  // }

  Future<void> _refreshLoads(
    RefreshLoads event,
    Emitter<SeaRealState> emit,
  ) async {
    final state = this.state as SeaRealLoaded;
    //get the client

    Wave? testWave = await _firestoreRepository.getTestSeaReal();

    //check if test is the same as the one in state
    if (state.waves.isNotEmpty && testWave != state.waves[0]) {
      add(LoadSeaReal(
        user: event.user,
      ));
    } else {
      emit(state);
    }
  }

  //paginate s
  Future<void> _paginateWaves(
    PaginateWaves event,
    Emitter<SeaRealState> emit,
  ) async {
    final state = this.state as SeaRealLoaded;
    emit(state.copyWith(loading: true));
    bool hasMore = true;

    List<Wave?> _myOldWavess = state.waves;
    DocumentSnapshot<Object?>? _lastmyWavesDoc;
    List<User?> _userPool = state.userPool;

    List<String> waveIds = _myOldWavess.map((e) => e!.id).toList();

    final List<Wave?> _myWaves =
        await _typesenseRepo.getSeaReals(waveIds: waveIds, user: event.user);

    List<Wave?> _myNewWaves = _myOldWavess + _myWaves;

    if (_myWaves.length < 5 || _myWaves.isEmpty) {
      hasMore = false;
    }

    for (var wave in _myWaves) {
      if (!_userPool.contains(wave!.senderId)) {
        User? _user = await _firestoreRepository.getFutureUser(wave.senderId);
        _userPool.add(_user);
      }
    }

    add(UpdateSeaReal(
      waves: _myNewWaves,
      hasMore: hasMore,
      lastmyWaveDoc: _lastmyWavesDoc,
      userPool: _userPool,
    ));
  }

  void _onCloseSeaReal(
    CloseSeaReal event,
    Emitter<SeaRealState> emit,
  ) {
    print('SeaRealBloc disposed');

    emit(SeaRealLoading());
  }

  Future<void> _onDeleteWave(
    DeleteWave event,
    Emitter<SeaRealState> emit,
  ) async {
    final state = this.state as SeaRealLoaded;

    await _firestoreRepository.deleteWave(event.wave);

    List<Wave?> _myOldWavess = state.waves;
    _myOldWavess.remove(event.wave);
    emit(SeaRealLoading());
    emit(state.copyWith(waves: _myOldWavess));
  }

  @override
  Future<void> close() async {
    super.close();
  }

  Future<void> _onCreateSeaReal(
    CreateSeaReal event,
    Emitter<SeaRealState> emit,
  ) async {
    String id = Uuid().v4();
    bool _isImage = false;
    String _frontImageurl = '';
    String _backImageurl = '';
    List<dynamic> bubbleImageUrls = [];
    await _storageRepository.uploadWaveImage(
      event.frontImage,
      id,
    );
    _frontImageurl = await _storageRepository.getWaveImageUrl(
      event.frontImage,
      id,
    );

    await _storageRepository.uploadWaveImage(
      event.backImage,
      id,
    );
    _backImageurl = await _storageRepository.getWaveImageUrl(
      event.backImage,
      id,
    );

    final Wave wave = Wave.genericWave(
      senderId: event.sender.id!,
      imageUrl: null,
      message: 'SeaReal',
      comments: 0,
      replyTo: null,
      replyToHandles: null,
      style: Wave.seaRealStyle,
      frontImageUrl: _frontImageurl,
      backImageUrl: _backImageurl,
      retaken: event.retaken,
    );

    await _firestoreRepository.uploadWave(wave);

    bool _ontime = IsWave.onTime(wave.createdAt);

    _firestoreRepository.updateVotesUsable(
        votesUsable: (_ontime) ? 1 : 0, id: event.sender.id!);

    if (!event.sender.sentFirstSeaReal) {
      _firestoreRepository.updateSentFirstSeaReal(event.sender.id!);
    }
  }
}
