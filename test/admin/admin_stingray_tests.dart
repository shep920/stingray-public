import 'package:flutter_test/flutter_test.dart';

import 'package:hero/models/models.dart';

import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/repository/typesense_repo.dart';

void adminStingrayTests(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required TypesenseRepository typesenseRepository,
    required StorageRepository storageRepository}) {
  group('Admin Stingray Tests: ', () {
    Stingray? _stingray;
    User? _user;

    test('Test addStingray', () async {
      await firestoreRepository.updateUserData(user: testUser);
      firestoreRepository
          .addStingray(Stingray.generateStingrayFromUser(testUser));

      _stingray = await firestoreRepository.getStingray(testUser.id!);
      _user = await firestoreRepository.getFutureUser(testUser.id!);

      expect(_user!.isStingray, true);

      expect(_stingray, isNotNull);
    });

    test('Test delete', () async {
      firestoreRepository.deleteStingray((testUser));

      _stingray = await firestoreRepository.getStingray(testUser.id!);
      _user = await firestoreRepository.getFutureUser(testUser.id!);

      expect(_user!.isStingray, false);

      expect(_stingray, null);
    });
  });
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);
  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!;
  TypesenseRepository typesenseRepository = TypesenseRepository();

  adminStingrayTests(
      firestoreRepository: firestoreRepository,
      testUser: testUser,
      testUserTwo: testUserTwo,
      typesenseRepository: typesenseRepository,
      storageRepository: storageRepository);
}
