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

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;

  LeaderboardBloc(
      {required FirestoreRepository databaseRepository,
      required TypesenseRepository typesenseRepository})
      : _firestoreRepository = databaseRepository,
        _typesenseRepository = typesenseRepository,
        super(LeaderboardLoading()) {
    on<LoadLeaderboard>(_onLoadLeaderboard);
    on<UpdateLeaderboard>(_onUpdateLeaderboard);
    on<CloseLeaderboard>(_onCloseLeaderboard);
  }

  Future<void> _onLoadLeaderboard(
    LoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    List<User?>? leaderboard = [];

    leaderboard = await _firestoreRepository.getLeaderboardUsers();

    
    leaderboard
        .removeWhere((user) => event.user.blockedUsers.contains(user!.id));
    leaderboard.removeWhere((user) => event.user.blockedBy.contains(user!.id));

    add(
      UpdateLeaderboard(leaderBoard: leaderboard),
    );
  }

  void _onUpdateLeaderboard(
    UpdateLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) {
    List<User?>? leaderboard = event.leaderBoard;

    leaderboard.sort((a, b) => b!.votes.compareTo(a!.votes));
    emit(LeaderboardLoaded(leaderboard: leaderboard));
  }

  void _onCloseLeaderboard(
    CloseLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) {
    print('LeaderboardBloc disposed');

    emit(LeaderboardLoading());
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
