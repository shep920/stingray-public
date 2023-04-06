import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero/blocs/my_waves/my_waves_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';

import 'package:hero/models/models.dart';
import 'package:hero/models/posts/wave_model.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';

void myWavesTest(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required StorageRepository storageRepository}) {
  group('My Waves Tests: ', () {
    User? _user;
    List<Wave?> _myWaves = [];
    bool hasMore = false;

    Widget _theApp = MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
            create: (context) =>
                ProfileBloc(databaseRepository: firestoreRepository)),
        BlocProvider<MyWavesBloc>(
          create: (context) => MyWavesBloc(
            firestoreRepository: firestoreRepository,
          ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoaded) {
              _user = profileState.user;
              return BlocBuilder<MyWavesBloc, MyWavesState>(
                builder: (context, myWavesState) {
                  if (myWavesState is MyWavesLoaded) {
                    _myWaves = myWavesState.waves;
                    hasMore = myWavesState.hasMore;
                    return Container();
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );

    testWidgets('My Waves Test Initial', (WidgetTester tester) async {
      await firestoreRepository.updateUserData(user: testUser);
      await tester.pumpWidget(_theApp);
      await tester.pumpAndSettle();
      BlocProvider.of<ProfileBloc>(tester.element(find.byType(Container)))
          .add(LoadProfile(userId: testUser.id!));
      await tester.pumpAndSettle();
      expect(_user, testUser);
      expect(_myWaves, []);
    });

    testWidgets('Load My Waves empty:', (WidgetTester tester) async {
      await tester.pumpWidget(_theApp);
      await tester.pumpAndSettle();
      BlocProvider.of<MyWavesBloc>(tester.element(find.byType(Container)))
          .add(LoadMyWaves(
        user: _user!,
      ));
      await tester.pumpAndSettle();
      expect(_user, testUser);
      expect(_myWaves, []);
    });

    testWidgets('Load My Waves full:', (WidgetTester tester) async {
      //for loop 100
      await tester.pumpWidget(_theApp);

      BlocProvider.of<ProfileBloc>(tester.element(find.byType(Container)))
          .add(LoadProfile(userId: testUser.id!));
      await tester.pumpAndSettle();

      for (var i = 0; i < 10; i++) {
        Wave testWave = Wave.genericWave(senderId: _user!.id!, message: 'test');
        firestoreRepository.uploadWave(testWave);
      }

      await tester.pumpAndSettle();
      BlocProvider.of<MyWavesBloc>(tester.element(find.byType(Container)))
          .add(LoadMyWaves(
        user: _user!,
      ));
      await tester.pumpAndSettle();

      expect(_user, testUser);
      expect(_myWaves.length, 10);
    });

    testWidgets('Pagination:', (WidgetTester tester) async {
      //delete all waves
      await firestoreRepository.deleteAllWaves();

      await tester.pumpWidget(_theApp);

      BlocProvider.of<ProfileBloc>(tester.element(find.byType(Container)))
          .add(LoadProfile(userId: testUser.id!));
      await tester.pumpAndSettle();

      for (var i = 0; i < 105; i++) {
        Wave testWave = Wave.genericWave(senderId: _user!.id!, message: 'test');
        firestoreRepository.uploadWave(testWave);
      }

      await tester.pumpAndSettle();
      BlocProvider.of<MyWavesBloc>(tester.element(find.byType(Container)))
          .add(LoadMyWaves(
        user: _user!,
      ));
      await tester.pumpAndSettle();

      expect(_user, testUser);
      expect(_myWaves.length, 10);

      BlocProvider.of<MyWavesBloc>(tester.element(find.byType(Container)))
          .add(PaginateWaves(
        user: _user!,
      ));
      await tester.pumpAndSettle();

      expect(_myWaves.length, 20);
      expect(hasMore, true);

      //paginate 8 more times
      for (var i = 0; i < 12; i++) {
        if (hasMore) {
          BlocProvider.of<MyWavesBloc>(tester.element(find.byType(Container)))
              .add(PaginateWaves(
            user: _user!,
          ));
          await tester.pumpAndSettle();
        }
      }

      expect(_myWaves.length, 70);
      expect(hasMore, false);

      //expect all waves to have different popularity values
      List<int> popularityValues = [];
      for (var element in _myWaves) {
        popularityValues.add(element!.popularity);
      }
      expect(popularityValues.toSet().length, 1);
    });

    
  });
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);

  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!; 
}