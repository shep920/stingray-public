import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero/blocs/admin%20bloc/admin_bloc.dart';
import 'package:hero/blocs/admin-verification/admin_verification_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/helpers/shared_preferences/user_simple_preferences.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/admin/admin_verification/admin_verifications_screen.dart';
import 'package:hero/screens/home/home_screens/admin/admin_verification/reject_verification_popup.dart';
import 'package:hero/screens/home/home_screens/user-verification/pending_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/rejected_verification_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/user_verification_screen.dart';
import 'package:hero/screens/home/home_screens/votes/vote_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void stingrayStoriesTest(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required TypesenseRepository typesenseRepository,
    required StorageRepository storageRepository}) {
  testWidgets('Testing stingray stories...', (tester) async {
    firestoreRepository.deleteVerification(testUser.id!);
    await firestoreRepository.updateUserData(user: testUser);
    await firestoreRepository.updateUserData(user: testUserTwo);

    ProfileState? testProfileState;
    StingrayState? testStingrayState;
    User? localUser;
    List<Stingray?> stingrays = [];
    Stingray? testStingray;
    Stingray? testStingrayTwo;

    List<String>? seenIds;

    Story? story;
    Map<String, List<Story>>? allStories;
    List<Story?> storiesList = [];
    List<Story?>? storiesListTwo;

    List<Report?> reports = [];

    SharedPreferences.setMockInitialValues({}); //set values here
    UserSimplePreferences.init();
    User userFuture = await firestoreRepository.getFutureUser(testUser.id!);

    expect(userFuture, testUser, reason: 'user should be added to firestore');

    //use a multiblocprovider to provide the blocs of profilebloc and userverificationbloc
    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(
            firestoreRepository: firestoreRepository,
          ),
        ),
        BlocProvider<ProfileBloc>(
            create: (context) =>
                ProfileBloc(databaseRepository: firestoreRepository)),
        BlocProvider<StingrayBloc>(
          create: (context) => StingrayBloc(
            storageRepository: storageRepository,
            databaseRepository: firestoreRepository,
          ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            //assign test state to the profile state
            testProfileState = profileState;
            if (profileState is ProfileLoaded) {
              localUser = profileState.user;
              return BlocBuilder<StingrayBloc, StingrayState>(
                builder: (context, stingrayState) {
                  testStingrayState = stingrayState;

                  if (stingrayState is StingrayLoaded) {
                    stingrays = stingrayState.stingrays;
                    testStingray = stingrayState.stingrays[0];

                    seenIds = stingrayState.seenStoryIds;

                    allStories = stingrayState.storiesMap;
                    storiesList = allStories![testStingray!.id!]!;

                    if (storiesList.isNotEmpty) {
                      story = storiesList[0];
                    }

                    if (stingrayState.stingrays.length > 1) {
                      testStingrayTwo = stingrayState.stingrays[1];
                      storiesListTwo = allStories![testStingrayTwo!.id!]!;
                    }

                    return BlocBuilder<AdminBloc, AdminState>(
                      builder: (context, adminState) {
                        if (adminState is AdminLoaded) {
                          reports = adminState.storyReports;

                          return Container();
                        }
                        return Container();
                      },
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    ));
    await tester.pumpAndSettle();

    BlocProvider.of<ProfileBloc>(tester.element(find.byType(Container)))
        .add(LoadProfile(userId: testUser.id!));

    await tester.pump(Duration(seconds: 2));

    expect(localUser, testUser,
        reason: 'ProfileState user should be loaded and same as testUser.');

    //a for loop to add 20 chats to the database
    for (int i = 0; i < 5; i++) {
      User _newUser = testUser.copyWith(id: Uuid().v4())!;
      Stingray _dummyData = Stingray.generateStingrayFromUser(_newUser);

      await firestoreRepository.setStingray(_dummyData);
    }

    //wait two seconds for the chats to be added to the database
    await tester.pump(Duration(seconds: 2));

    BlocProvider.of<StingrayBloc>(tester.element(find.byType(Container)))
        .add(LoadStingray(user: localUser!, sortOrder: ''));

    await tester.pump(Duration(seconds: 2));

    expect(testStingrayState, isA<StingrayLoaded>(),
        reason: 'DiscoveryChatJudgeableState should be loaded');

    expect(stingrays.length, 5, reason: 'testChats should have 10 chats in it');

    //make a fake File to upload to the database
    File _fakeFile = File('test_resources/test_image.png');

    BlocProvider.of<StingrayBloc>(tester.element(find.byType(Container)))
        .add(UploadStory(file: _fakeFile, stingrayId: testStingray!.id!));

    await tester.pump(Duration(seconds: 2));

    expect(stingrays[0]!.stories.length, 1,
        reason: 'stingray should have a story in it');

    //expect story to not be null
    expect(story, isNotNull, reason: 'story should not be null');

    //expect the first string to be 'bruh'
    expect(seenIds, [], reason: 'seenIds should be empty');

    BlocProvider.of<StingrayBloc>(tester.element(find.byType(Container)))
        .add(ViewStory(story: story!));

    await tester.pump(Duration(seconds: 2));

    //expect seenIds to have the story id in it
    expect(seenIds, [story!.id],
        reason: 'seenIds should have the story id in it');

    Stingray _dummyDataTwo = Stingray.generateStingrayFromUser(testUserTwo);
    await firestoreRepository.setStingray(_dummyDataTwo);

    await tester.pump(Duration(seconds: 2));

    //stingrayTwo shoul not be null
    expect(testStingrayTwo, isNotNull,
        reason: 'testStingrayTwo should not be null');

    for (int i = 0; i < 10; i++) {
      BlocProvider.of<StingrayBloc>(tester.element(find.byType(Container)))
          .add(UploadStory(file: _fakeFile, stingrayId: testStingrayTwo!.id!));
    }
  });
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);
  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!;
  TypesenseRepository typesenseRepository = TypesenseRepository();

  stingrayStoriesTest(
      firestoreRepository: firestoreRepository,
      storageRepository: storageRepository,
      testUser: testUser,
      testUserTwo: testUserTwo,
      typesenseRepository: typesenseRepository);
}
