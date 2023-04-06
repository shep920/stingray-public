import 'package:flutter_test/flutter_test.dart';

import 'package:hero/models/models.dart';

import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/repository/typesense_repo.dart';

void waveTest(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required TypesenseRepository typesenseRepository,
    required StorageRepository storageRepository}) {
  testWidgets('Testing increment wave replies...', (tester) async {
    firestoreRepository.deleteVerification(testUser.id!);
    await firestoreRepository.updateUserData(user: testUser);
    await firestoreRepository.updateUserData(user: testUserTwo);

    Wave testWave = Wave.genericWave(senderId: testUser.id!, message: 'test');
    int testPopularity = testWave.popularity;

    firestoreRepository.uploadWave(testWave);

    Wave? futureGetWave = await firestoreRepository.getWave(testWave.id);

    //expect the two waves to be equal
    expect(futureGetWave!.id, testWave.id,
        reason: 'wave should be added to firestore');

    firestoreRepository.incrementWaveReplies(testWave.id);

    futureGetWave = await firestoreRepository.getWave(testWave.id);

    //popularity should be incremented by 600
    expect(futureGetWave!.popularity, testPopularity + 600,
        reason: 'wave should be more popularity');

    expect(futureGetWave.comments, testWave.comments + 1,
        reason: 'wave should have 1 more comment');

    firestoreRepository.decrementWaveReplies(testWave.id);

    futureGetWave = await firestoreRepository.getWave(testWave.id);

    //popularity should be incremented by 600
    expect(futureGetWave!.popularity, testPopularity,
        reason: 'wave should be less popularity');

    expect(futureGetWave.comments, 0,
        reason: 'wave should have 1 less comment');

    // liking

    firestoreRepository.updateWaveLikes(testWave.id, testUser.id!);

    futureGetWave = await firestoreRepository.getWave(testWave.id);

    expect(futureGetWave!.popularity, testPopularity + 100,
        reason: 'wave should be more popularity');

    firestoreRepository.deleteWave(testWave);

    futureGetWave = await firestoreRepository.getWave(testWave.id);

    expect(futureGetWave, null,
        reason: 'wave should be deleted from firestore');
  });
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);
  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!;
  TypesenseRepository typesenseRepository = TypesenseRepository();

  waveTest(
      firestoreRepository: firestoreRepository,
      testUser: testUser,
      testUserTwo: testUserTwo,
      typesenseRepository: typesenseRepository,
      storageRepository: storageRepository);
  
}
