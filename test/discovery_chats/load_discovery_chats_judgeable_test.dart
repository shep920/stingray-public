import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/models.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:uuid/uuid.dart';

void loadDiscoveryJudgeableChats(
    {required FirestoreRepository firestoreRepository,
    required User testUser,
    required User testUserTwo,
    required TypesenseRepository typesenseRepository,
    required StorageRepository storageRepository}) {
  testWidgets('loading discovery chats...', (tester) async {
    firestoreRepository.deleteVerification(testUser.id!);
    await firestoreRepository.updateUserData(user: testUser);
    await firestoreRepository.updateUserData(user: testUserTwo);

    ProfileState? testState;
    User? localUser;
    DiscoveryChatState? testChatState;
    DiscoveryChatJudgeableState? testChatJudgeableState;
    List<DiscoveryChat?>? testChats;
    bool? hasMore;

    //get future of the user
    User userFuture = await firestoreRepository.getFutureUser(testUser.id!);

    expect(userFuture, testUser, reason: 'user should be added to firestore');

    //use a multiblocprovider to provide the blocs of profilebloc and userverificationbloc
    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
            create: (context) =>
                ProfileBloc(databaseRepository: firestoreRepository)),
        BlocProvider<DiscoveryChatBloc>(
          create: (context) => DiscoveryChatBloc(
              firestoreRepository: firestoreRepository,
              typesenseRepository: typesenseRepository),
        ),
        BlocProvider<DiscoveryChatJudgeableBloc>(
          create: (context) => DiscoveryChatJudgeableBloc(
              firestoreRepository: firestoreRepository,
              typesenseRepository: typesenseRepository),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            //assign test state to the profile state
            testState = profileState;
            if (profileState is ProfileLoaded) {
              localUser = profileState.user;
              return BlocBuilder<DiscoveryChatJudgeableBloc,
                  DiscoveryChatJudgeableState>(
                builder: (context, judgeableState) {
                  testChatJudgeableState = judgeableState;
                  if (judgeableState is DiscoveryChatJudgeableLoaded) {
                    testChats = judgeableState.judgeableChats;
                    hasMore = judgeableState.judgeableHasMore;
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
    ));
    await tester.pumpAndSettle();

    BlocProvider.of<ProfileBloc>(tester.element(find.byType(Container)))
        .add(LoadProfile(userId: testUser.id!));

    await tester.pump(Duration(seconds: 2));

    expect(localUser, testUser,
        reason: 'ProfileState user should be loaded and same as testUser.');

    //a for loop to add 20 chats to the database
    for (int i = 0; i < 15; i++) {
      DiscoveryChat _dummyData = DiscoveryChat.genericDiscoveryChat(
          chatId: Uuid().v4(),
          receiverId: testUser.id!,
          senderId: testUserTwo.id!,
          pending: true);

      await firestoreRepository.initializeDiscoveryChats(_dummyData);
    }

    //wait two seconds for the chats to be added to the database
    await tester.pump(Duration(seconds: 2));

    BlocProvider.of<DiscoveryChatJudgeableBloc>(
            tester.element(find.byType(Container)))
        .add(LoadDiscoveryChatJudgeable(
            context: tester.element(find.byType(Container)),
            user: localUser!,
            testing: true,
            testUserPool: [testUserTwo]));

    await tester.pump(Duration(seconds: 2));

    expect(testChatJudgeableState, isA<DiscoveryChatJudgeableLoaded>(),
        reason: 'DiscoveryChatJudgeableState should be loaded');

    expect(testChats!.length, 10,
        reason: 'testChats should have 10 chats in it');

    expect(hasMore, true,
        reason: 'hasMore should be true since there are more chats to load');

    BlocProvider.of<DiscoveryChatJudgeableBloc>(
            tester.element(find.byType(Container)))
        .add(PaginateJudgeableChats(
            context: tester.element(find.byType(Container)),
            user: localUser!,
            testing: true,
            testUserPool: [testUserTwo]));

    await tester.pump(Duration(seconds: 2));

    expect(testChatJudgeableState, isA<DiscoveryChatJudgeableLoaded>(),
        reason: 'DiscoveryChatJudgeableState should be loaded');

    expect(testChats!.length, 15,
        reason: 'testChats should have 15 chats in it');

    expect(hasMore, false,
        reason:
            'hasMore should be false since there no are more chats to load');

    //delete the chats from the database found in testChats
    for (int i = 0; i < testChats!.length; i++) {
      await firestoreRepository.deleteDiscoveryChat(testChats![i]!);
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

  loadDiscoveryJudgeableChats(
      firestoreRepository: firestoreRepository,
      testUser: testUser,
      testUserTwo: testUserTwo,
      typesenseRepository: typesenseRepository,
      storageRepository: storageRepository);
}