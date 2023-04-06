import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero/blocs/my_waves/my_waves_bloc.dart';
import 'package:hero/blocs/prizes/prizes_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';

import 'package:hero/models/models.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/stingrays/stingray_stats_doc_model.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';

void stingrayLeaderBoardTest(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required StorageRepository storageRepository}) {
  group('Prize Tests: ', () {
    Prize generic = Prize.genericPrize();

    PrizesBloc prizesBloc = PrizesBloc(
        databaseRepository: firestoreRepository,
        storageRepository: storageRepository);

    List<Prize> prizes = [];

    StreamSubscription prizeSubscription =
        firestoreRepository.prizes.listen((event) {
      prizes = event;
    });

    test('Empty Prizes', () async {
      expect(prizes, []);
    });

    test('Add Prize', () async {
      prizesBloc.add(CreatePrize(prize: generic));

      await Future.delayed(Duration(seconds: 2));
      expect(prizes.length, 1);
    });

    //delete prize
    test('Delete Prize', () async {
      await firestoreRepository.deletePrize(prizeId: generic.id);
      expect(prizes.length, 0);
    });

    //changePrizeRemaining
    test('Change Prize Remaining', () async {
      await firestoreRepository.createPrize(prize: generic);
      await firestoreRepository.changePrizeRemaining(
          prizeId: generic.id, remaining: 10);
      expect(prizes[0].remaining, 10);
    });
  });
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);

  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!;
  stingrayLeaderBoardTest(
      firestoreRepository: firestoreRepository,
      testUser: testUser,
      testUserTwo: testUserTwo,
      storageRepository: storageRepository);
}
