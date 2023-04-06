import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/models/leaderboard_model.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../repository/typesense_repo.dart';
import '../typesense/bloc/search_bloc.dart';

part 'user_verification_event.dart';
part 'user_verification_state.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  final FirestoreRepository _firestoreRepository;
  final StorageRepository _storageRepository;
  final TypesenseRepository _typesenseRepository;
  late StreamSubscription _userVerificationSubscription;

  UserVerificationBloc(
      {required FirestoreRepository databaseRepository,
      required TypesenseRepository typesenseRepository,
      required StorageRepository storageRepository})
      : _firestoreRepository = databaseRepository,
        _typesenseRepository = typesenseRepository,
        _storageRepository = storageRepository,
        super(UserVerificationLoading()) {
    on<LoadUserVerification>(_onLoadUserVerification);
    on<UpdateUserVerification>(_onUpdateUserVerification);
    on<CloseUserVerification>(_onCloseUserVerification);
    on<SendUserVerification>(_onSendUserVerification);
    on<CancelUserVerification>(_onCancelUserVerification);
    on<RestartVerification>(_onRestartVerification);
  }

  Future<void> _onLoadUserVerification(
    LoadUserVerification event,
    Emitter<UserVerificationState> emit,
  ) async {
    await _firestoreRepository.verificationExists(event.user.id);

    _userVerificationSubscription = _firestoreRepository
        .getUserVerification(event.user.id)
        .listen((verification) {
      add(
        UpdateUserVerification(verification: verification),
      );
    });
  }

  void _onUpdateUserVerification(
    UpdateUserVerification event,
    Emitter<UserVerificationState> emit,
  ) {
    if (event.verification.verificationStatus == UserVerification.initial) {
      emit(UserVerificationInitial(userVerification: event.verification));
    }
    if (event.verification.verificationStatus == UserVerification.pending) {
      emit(UserVerificationPending(userVerification: event.verification));
    }
    if (event.verification.verificationStatus == UserVerification.accepted) {
      emit(UserVerificationAccepted(userVerification: event.verification));
    }
    if (event.verification.verificationStatus == UserVerification.rejected) {
      emit(UserVerificationRejected(userVerification: event.verification));
    }
  }

  void _onCloseUserVerification(
    CloseUserVerification event,
    Emitter<UserVerificationState> emit,
  ) {
    print('UserVerificationBloc disposed');

    emit(UserVerificationLoading());
  }

  void _onSendUserVerification(
    SendUserVerification event,
    Emitter<UserVerificationState> emit,
  ) async {
    String _imageUrl = '';

    await _storageRepository
        .uploadUserVerificationImage(event.image, event.verification.id)
        .then((value) async => _imageUrl = await _storageRepository
            .getUserVerificationImageUrl(event.image, event.verification.id));

    UserVerification _userVerification = event.verification.copyWith(
        imageUrl: _imageUrl, verificationStatus: UserVerification.pending);

    _firestoreRepository.updateVerification(
        userVerification: _userVerification);
  }

  void _onCancelUserVerification(
    CancelUserVerification event,
    Emitter<UserVerificationState> emit,
  ) async {
    final state = this.state as UserVerificationPending;

    UserVerification _userVerification = state.userVerification
        .copyWith(imageUrl: '', verificationStatus: UserVerification.initial);

    _firestoreRepository.updateVerification(
        userVerification: _userVerification);
  }

  void _onRestartVerification(
    RestartVerification event,
    Emitter<UserVerificationState> emit,
  ) async {
    final state = this.state as UserVerificationRejected;

    UserVerification _userVerification = state.userVerification
        .copyWith(imageUrl: '', verificationStatus: UserVerification.initial);

    _firestoreRepository.updateVerification(
        userVerification: _userVerification);
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
