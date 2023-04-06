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

part 'similar_pups_event.dart';
part 'similar_pups_state.dart';

class SimilarPupsBloc extends Bloc<SimilarPupsEvent, SimilarPupsState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;

  SimilarPupsBloc(
      {required FirestoreRepository databaseRepository,
      required TypesenseRepository typesenseRepository})
      : _firestoreRepository = databaseRepository,
        _typesenseRepository = typesenseRepository,
        super(SimilarPupsLoading()) {
    on<LoadSimilarPups>(_onLoadSimilarPups);
    on<UpdateSimilarPups>(_onUpdateSimilarPups);
    on<CloseSimilarPups>(_onCloseSimilarPups);
    on<PaginateSimilarPups>(_onPaginateSimilarPups);
  }

  Future<void> _onLoadSimilarPups(
    LoadSimilarPups event,
    Emitter<SimilarPupsState> emit,
  ) async {
    List<User?> similarPups = [];
    List<User?> nonSimilarPups = [];

    similarPups = await _typesenseRepository.getSimilarPups(user: event.user);

    if (similarPups.length < 20) {
      nonSimilarPups = await _typesenseRepository.getNonsimilarPups(
          user: event.user, loaded: similarPups);
      similarPups.addAll(nonSimilarPups);
    }

    //remove any pups where finishedOnboarding is false or imageUrls.length = 0
    similarPups.removeWhere((element) =>
        element!.finishedOnboarding == false ||
        element.imageUrls.length == 0 ||
        element.id == event.user.id);

    similarPups.shuffle();

    add(
      UpdateSimilarPups(similarPups: similarPups),
    );
  }

  Future<void> _onPaginateSimilarPups(
    PaginateSimilarPups event,
    Emitter<SimilarPupsState> emit,
  ) async {
    final state = this.state as SimilarPupsLoaded;
    emit(state.copyWith(isLoading: true));
    List<User?> similarPups = state.similarPups;
    List<User?> nonSimilarPups = [];

    List<User?> newpups = await _typesenseRepository.getSimilarPups(
        user: event.user, loaded: similarPups);

    similarPups.addAll(newpups);

    if (newpups.length < 20) {
      nonSimilarPups = await _typesenseRepository.getNonsimilarPups(
          user: event.user, loaded: similarPups);
      similarPups.addAll(nonSimilarPups);
      newpups.addAll(nonSimilarPups);
    }

    similarPups.removeWhere((element) =>
        element!.finishedOnboarding == false ||
        element.imageUrls.length == 0 ||
        element.id == event.user.id);

    emit(state.copyWith(
        similarPups: similarPups,
        isLoading: false,
        totalLoaded: similarPups.length,
        hasMore: (newpups.length < 20) ? false : true));
  }

  void _onUpdateSimilarPups(
    UpdateSimilarPups event,
    Emitter<SimilarPupsState> emit,
  ) {
    List<User?>? similarPups = event.similarPups;

    bool isLoading = false;
    bool hasMore = (similarPups.length < 20) ? false : true;

    similarPups.shuffle();

    emit(SimilarPupsLoaded(
        similarPups: similarPups,
        isLoading: isLoading,
        hasMore: hasMore,
        cap: 100,
        totalLoaded: similarPups.length));
  }

  void _onCloseSimilarPups(
    CloseSimilarPups event,
    Emitter<SimilarPupsState> emit,
  ) {
    print('SimilarPupsBloc disposed');

    emit(SimilarPupsLoading());
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
