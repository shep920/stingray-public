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
import 'package:hero/models/models.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/stingrays/stingray_stats_doc_model.dart';
import 'package:hero/models/stingrays/stingray_stats_model.dart';
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

part 'stingray_leaderboard_event.dart';
part 'stingray_leaderboard_state.dart';

class StingrayLeaderboardBloc
    extends Bloc<StingrayLeaderboardEvent, StingrayLeaderboardState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepo;

  StingrayLeaderboardBloc({
    required FirestoreRepository firestoreRepository,
    required TypesenseRepository typesenseRepo,
  })  : _firestoreRepository = firestoreRepository,
        _typesenseRepo = typesenseRepo,
        super(StingrayLeaderboardLoading()) {
    on<LoadStingrayLeaderboard>(_onLoadStingrayLeaderboard);
    on<UpdateStingrayLeaderboard>(_onUpdateStingrayLeaderboard);
    on<PaginateStats>(_onPaginateStats);
    on<ChangeRefreshStatus>(_onChangeRefreshStatus);
  }

  Future<void> _onLoadStingrayLeaderboard(
    LoadStingrayLeaderboard event,
    Emitter<StingrayLeaderboardState> emit,
  ) async {
    emit(StingrayLeaderboardLoading());

    List<StingrayStats> stingrayStats = [];
    DocumentSnapshot? _lastVisible;

    QuerySnapshot stingrayStatsDocs =
        await _firestoreRepository.getStingrayLeaderboard();

    for (QueryDocumentSnapshot doc in stingrayStatsDocs.docs) {
      StingrayStatsDoc stingrayStatsDoc =
          StingrayStatsDoc.stingrayStatsDocFromMap(
              doc.data() as Map<String, dynamic>);
      int _totalScore = stingrayStatsDoc.likes - stingrayStatsDoc.dislikes;

      StingrayStats _stingrayStats = StingrayStats(
          dislikes: stingrayStatsDoc.dislikes,
          likes: stingrayStatsDoc.likes,
          stingrayId: stingrayStatsDoc.stingrayId,
          totalScore: _totalScore);

      stingrayStats.add(_stingrayStats);
    }

    stingrayStats.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    //if stingrayStatsdoc.cocs is longer than 0, set lastVisible to the last doc
    if (stingrayStatsDocs.docs.isNotEmpty) {
      _lastVisible = stingrayStatsDocs.docs[stingrayStatsDocs.docs.length - 1];
    }

    bool _hasMore = stingrayStatsDocs.docs.length == 10;

    //remove any stingrayStats that do not have a stingrayId found in event.stingrays
    stingrayStats.removeWhere((stingrayStats) => !event.stingrays
        .any((stingray) => stingray!.id == stingrayStats.stingrayId));

    add(UpdateStingrayLeaderboard(
      stats: stingrayStats,
      hasMore: _hasMore,
      lastStatsDoc: _lastVisible,
    ));
  }

  void _onUpdateStingrayLeaderboard(
    UpdateStingrayLeaderboard event,
    Emitter<StingrayLeaderboardState> emit,
  ) {
    emit(StingrayLeaderboardLoading());
    //timer Timer that sets the state as Loaded, then sends a copywith where refreshable is true
    Timer _timer = Timer(Duration(seconds: 5), () {
      add(ChangeRefreshStatus());
    });

    emit(StingrayLeaderboardLoaded(
      stats: event.stats,
      hasMore: event.hasMore,
      loading: false,
      lastmyWaveDoc: event.lastStatsDoc,
      refreshable: false,
      timer: _timer,
    ));
  }

  //on paginate stats
  Future<void> _onPaginateStats(
    PaginateStats event,
    Emitter<StingrayLeaderboardState> emit,
  ) async {
    final state = this.state as StingrayLeaderboardLoaded;

    List<StingrayStats?> _stats = state.stats;

    DocumentSnapshot? _lastVisible;

    List<StingrayStats> _newStats = [];

    QuerySnapshot stingrayStatsDocs = await _firestoreRepository
        .getStingrayLeaderboard(lastDocument: state.lastmyWaveDoc);

    for (QueryDocumentSnapshot doc in stingrayStatsDocs.docs) {
      StingrayStatsDoc stingrayStatsDoc =
          StingrayStatsDoc.stingrayStatsDocFromMap(
              doc.data() as Map<String, dynamic>);
      int _totalScore = stingrayStatsDoc.likes - stingrayStatsDoc.dislikes;

      StingrayStats _stingrayStats = StingrayStats(
          dislikes: stingrayStatsDoc.dislikes,
          likes: stingrayStatsDoc.likes,
          stingrayId: stingrayStatsDoc.stingrayId,
          totalScore: _totalScore);

      _newStats.add(_stingrayStats);
    }

    _newStats.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    //if stingrayStatsdoc.cocs is longer than 0, set lastVisible to the last doc
    if (stingrayStatsDocs.docs.isNotEmpty) {
      _lastVisible = stingrayStatsDocs.docs[stingrayStatsDocs.docs.length - 1];
    }

    bool _hasMore = stingrayStatsDocs.docs.length == 10;

    //remove any stingrayStats that do not have a stingrayId found in event.stingrays
    _newStats.removeWhere((stingrayStats) => !event.stingrays
        .any((stingray) => stingray.id == stingrayStats.stingrayId));

    //remove any stingrayStats that do not have a stingrayId found in event.stingrays
    _stats.removeWhere((stingrayStats) => !event.stingrays
        .any((stingray) => stingray.id == stingrayStats!.stingrayId));

    _stats.addAll(_newStats);

    

    add(UpdateStingrayLeaderboard(
      stats: _stats,
      hasMore: _hasMore,
      lastStatsDoc: _lastVisible,
    ));
  }

  void _onChangeRefreshStatus(
    ChangeRefreshStatus event,
    Emitter<StingrayLeaderboardState> emit,
  ) {
    final state = this.state as StingrayLeaderboardLoaded;
    emit(StingrayLeaderboardLoading());

    emit(state.copyWith(
      refreshable: true,
    ));
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
