import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/models/leaderboard_model.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../repository/typesense_repo.dart';
import '../typesense/bloc/search_bloc.dart';

part 'admin_verification_event.dart';
part 'admin_verification_state.dart';

class AdminVerificationBloc
    extends Bloc<AdminVerificationEvent, AdminVerificationState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;
  late StreamSubscription _userVerificationSubscription;

  AdminVerificationBloc(
      {required FirestoreRepository databaseRepository,
      required TypesenseRepository typesenseRepository})
      : _firestoreRepository = databaseRepository,
        _typesenseRepository = typesenseRepository,
        super(AdminVerificationLoading()) {
    on<LoadAdminVerification>(_onLoadAdminVerification);
    on<UpdateAdminVerification>(_onUpdateAdminVerification);
    on<CloseAdminVerification>(_onCloseAdminVerification);
    on<RejectVerification>(_onRejectVerification);
    on<AcceptVerification>(_onAcceptVerification);
  }

  Future<void> _onLoadAdminVerification(
    LoadAdminVerification event,
    Emitter<AdminVerificationState> emit,
  ) async {
    _userVerificationSubscription =
        _firestoreRepository.getAdminVerification().listen((verifications) {
      add(
        UpdateAdminVerification(verifications: verifications),
      );
    });
  }

  Future<void> _onUpdateAdminVerification(
    UpdateAdminVerification event,
    Emitter<AdminVerificationState> emit,
  ) async {
    List<User> _users = [];
    if (state is AdminVerificationLoaded) {
      _users = (state as AdminVerificationLoaded).users;
    }

    //for each verification that has an id not in the list of users, get it using getFutureUser and add it to the list
    for (UserVerification verification in event.verifications) {
      if (!_users.any((user) => user.id == verification.id)) {
        User _user = await _firestoreRepository.getFutureUser(verification.id);
        _users.add(_user);
      }
    }

    emit(AdminVerificationLoaded(
        verifications: event.verifications, users: _users));
  }

  void _onCloseAdminVerification(
    CloseAdminVerification event,
    Emitter<AdminVerificationState> emit,
  ) {
    _userVerificationSubscription.cancel();
    print('AdminVerificationBloc disposed');

    emit(AdminVerificationLoading());
  }

  Future<void> _onRejectVerification(
    RejectVerification event,
    Emitter<AdminVerificationState> emit,
  ) async {
    UserVerification _newVerification = event.verification.copyWith(
      verificationStatus: UserVerification.rejected,
      rejectionReason: event.reason,
      imageUrl: '',
    );

    _firestoreRepository.updateVerification(userVerification: _newVerification);
  }

  Future<void> _onAcceptVerification(
    AcceptVerification event,
    Emitter<AdminVerificationState> emit,
  ) async {
    UserVerification _newVerification = event.verification.copyWith(
      verificationStatus: UserVerification.accepted,
      rejectionReason: '',
      verifiedAs: event.verifiedAs,
      verifiedOn: Timestamp.fromDate(DateTime.now()),
    );

    _firestoreRepository.updateVerification(userVerification: _newVerification);
    _firestoreRepository.verifyUser(_newVerification.id);
    _firestoreRepository.updateVerificationListener(_newVerification.id);
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
