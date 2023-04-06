import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:hero/models/models.dart';
import 'package:hero/models/user_search_view_model.dart';
import 'package:hero/repository/firestore_repository.dart';

part 'vote_event.dart';
part 'vote_state.dart';

class VoteBloc extends Bloc<VoteEvent, VoteState> {
  final FirestoreRepository _firestoreRepository;

  VoteBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(VoteLoading()) {
    on<VoteEvent>((event, emit) {});

    on<LoadUserEvent>((event, emit) {
      try {
        emit(VoteLoaded(user: event.user, imageUrlIndex: 0));
      } catch (e) {
        print(e);
      }
    });

    on<LoadUserFromFirestore>(_loadUserFromFirestore);
    on<UpdateUserFromFirestore>(_updateUserFromFirestore);
    on<IncrementImageUrlIndex>(_incrementImageUrlIndex);
    on<DecrementImageUrlIndex>(_decrementImageUrlIndex);

    on<CloseVote>(_onCloseVote);
    on<LoadVoteUserFromHandle>(_loadVoteUserFromHandle);
  }

  _loadUserFromFirestore(
    LoadUserFromFirestore event,
    Emitter<VoteState> emit,
  ) async {
    try {
      {
        User _user = await _firestoreRepository.getFutureUser(event.userId);
        add(
          UpdateUserFromFirestore(user: _user),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  _updateUserFromFirestore(
    UpdateUserFromFirestore event,
    Emitter<VoteState> emit,
  ) {
    try {
      emit(VoteLoaded(user: event.user, imageUrlIndex: 0));
    } catch (e) {
      print(e);
    }
  }

  void _incrementImageUrlIndex(
    IncrementImageUrlIndex event,
    Emitter<VoteState> emit,
  ) {
    if (state is VoteLoaded) {
      final state = this.state as VoteLoaded;
      int imageUrlIndex = event.imageUrlIndex;
      if (imageUrlIndex < state.user!.imageUrls.length - 1) {
        imageUrlIndex = imageUrlIndex + 1;
      }

      emit(VoteLoaded(
        user: state.user,
        imageUrlIndex: imageUrlIndex,
      ));
    }
  }

  void _decrementImageUrlIndex(
    DecrementImageUrlIndex event,
    Emitter<VoteState> emit,
  ) {
    if (state is VoteLoaded) {
      final state = this.state as VoteLoaded;
      int imageUrlIndex = event.imageUrlIndex;
      if (imageUrlIndex > 0) {
        imageUrlIndex = imageUrlIndex - 1;
      }

      emit(VoteLoaded(
        user: state.user,
        imageUrlIndex: imageUrlIndex,
      ));
    }
  }

  void _onCloseVote(
    CloseVote event,
    Emitter<VoteState> emit,
  ) {
    print('VoteBloc disposed');

    emit(VoteLoading());
  }

  Future<void> _loadVoteUserFromHandle(
    LoadVoteUserFromHandle event,
    Emitter<VoteState> emit,
  ) async {
    try {
      {
        User? user = await _firestoreRepository.getUserFromHandle(event.handle);
        emit(VoteLoaded(user: user, imageUrlIndex: 0));
        Navigator.of(event.context).pushNamed('/votes');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> close() async {
    super.close();
  }
}
