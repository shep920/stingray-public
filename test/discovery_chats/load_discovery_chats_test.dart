import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero/blocs/admin-verification/admin_verification_bloc.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/models.dart';
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
import 'package:uuid/uuid.dart';

void loadDiscoveryChats(
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
    List<DiscoveryChat?>? testChats;

    DiscoveryChat dummyData = DiscoveryChat.genericDiscoveryChat(
        chatId: Uuid().v4(),
        receiverId: testUser.id!,
        senderId: testUserTwo.id!);

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
      ],
      child: MaterialApp(
        home: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            //assign test state to the profile state
            testState = profileState;
            if (profileState is ProfileLoaded) {
              localUser = profileState.user;
              return BlocBuilder<DiscoveryChatBloc, DiscoveryChatState>(
                builder: (context, discoveryChatState) {
                  testChatState = discoveryChatState;
                  if (discoveryChatState is DiscoveryChatLoaded) {
                    testChats = discoveryChatState.chats;
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
  });
}

void main() {
  FirestoreRepository firestoreRepository = FirestoreRepository(testing: true);
  StorageRepository storageRepository = StorageRepository(testing: true);
  final user = User.genericUser('test');
  User testUser = User.testUser('test');
  User testUserTwo = testUser.copyWith(id: 'test2')!;
  TypesenseRepository typesenseRepository = TypesenseRepository();

  loadDiscoveryChats(
      firestoreRepository: firestoreRepository,
      testUser: testUser,
      testUserTwo: testUserTwo,
      typesenseRepository: typesenseRepository,
      storageRepository: storageRepository);
}
