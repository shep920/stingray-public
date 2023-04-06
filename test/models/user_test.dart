import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:test/test.dart';

void userTest({required User user, required FirestoreRepository firestore}) {
  test('should return a generic user', () {
    expect(user.name, '');
    expect(user.age, 0);
    expect(user.imageUrls, []);
    expect(user.jobTitle, '');
    expect(user.bio, '');

    expect(user.isRude, false);
    expect(user.instigations, 0);
    expect(user.votes, 0);
    expect(user.votesUsable, 0);
    expect(user.stingrays, []);
    expect(user.finishedOnboarding, false);
  });
  //using mock firestore, test that the user is saved to the database
  test('should save user to database', () async {
    await firestore.updateUserData(user: user);
    final userFromDatabase = await firestore.getFutureUser(user.id);

    expect(userFromDatabase, user);
  });

  test('should change handle', () async {
    await firestore.updateHandle(id: user.id!, handle: 'test');
    final userFromDatabase = await firestore.getFutureUser(user.id);

    expect(userFromDatabase.handle, 'test');
  });

  firestore.deleteUser(user);
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);
  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!;
  TypesenseRepository typesenseRepository = TypesenseRepository();

  userTest(firestore: firestoreRepository, user: user);
}

