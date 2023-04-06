import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero/blocs/my_waves/my_waves_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';

import 'package:hero/models/models.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/stingrays/stingray_stats_doc_model.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';

void stingrayLeaderBoardTest(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required StorageRepository storageRepository}) {
  group('StingrayLeaderboard Tests: ', () {
    StingrayStatsDoc generic =
        StingrayStatsDoc.genericStingrayStatsDoc(stingrayId: testUser.id);

    Wave wave = Wave.genericWave(
        message: 'test', senderId: testUser.id!, replyTo: testUser.id!);
    Wave lateWave = Wave.genericWave(
        message: 'test', senderId: testUser.id!, replyTo: testUser.id!);
    DateTime _lateWaveDate = DateTime.now().subtract(Duration(days: 7));
    lateWave = lateWave.copyWith(createdAt: _lateWaveDate);

    test('getStingrayStats', () async {
      await firestoreRepository.getStingrayStats(
        stingrayId: generic.stingrayId,
      );
      StingrayStatsDoc? stingrayStatsDoc =
          await firestoreRepository.getStingrayStats(stingrayId: testUser.id!);
      expect(stingrayStatsDoc, generic);
    });

    //test, like Stingray stats, that tests likeStingrayStats method
    test('LikeStingrayStats', () async {
      await firestoreRepository.likeStingrayStats(
        stingrayId: generic.stingrayId,
      );
      StingrayStatsDoc? _stingrayStatsDoc =
          await firestoreRepository.getStingrayStats(stingrayId: testUser.id!);
      expect(_stingrayStatsDoc.likes, generic.likes + 1);
    });

    //test getStingrayLeaderboardReplies, it sould return 0

    //dislike
    test('dislikeStingrayStats', () async {
      await firestoreRepository.dislikeStingrayStats(
        stingrayId: generic.stingrayId,
      );
      StingrayStatsDoc? _stingrayStatsDoc =
          await firestoreRepository.getStingrayStats(stingrayId: testUser.id!);
      expect(_stingrayStatsDoc.dislikes, generic.dislikes + 1);
    });

    //test getStingrayLeaderboardWavesCount similar to getStingrayLeaderboardReplies
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
