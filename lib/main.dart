import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:hero/blocs/admin%20bloc/admin_bloc.dart';
import 'package:hero/blocs/admin-verification/admin_verification_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/backpack/backpack_bloc.dart';
import 'package:hero/blocs/chat/chat_bloc.dart';
import 'package:hero/blocs/cloud_messaging/cloud_messaging_bloc.dart';
import 'package:hero/blocs/leaderboad/leaderboard_bloc.dart';
import 'package:hero/blocs/like/like_bloc.dart';
import 'package:hero/blocs/liked_waves/liked_waves_bloc.dart';
import 'package:hero/blocs/message/message_bloc.dart';
import 'package:hero/blocs/my_waves/my_waves_bloc.dart';
import 'package:hero/blocs/sea_real/sea_real_bloc.dart';
import 'package:hero/blocs/similar%20pups/similar_pups_bloc.dart';
import 'package:hero/blocs/stingray_leaderboard_bloc/stingray_leaderboard_bloc.dart';
import 'package:hero/blocs/swipe/swipe_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/blocs/wave_disliking/wave_disliking_bloc.dart';
import 'package:hero/blocs/wave_liking/wave_liking_bloc.dart';
import 'package:hero/blocs/yip_yaps/yip_yaps_bloc.dart';
import 'package:hero/config/app_router.dart';
import 'package:hero/config/dark_theme.dart';
import 'package:hero/config/theme.dart';
import 'package:hero/cubits/edit_bio/editbio_cubit.dart';
import 'package:hero/cubits/kelp_memory/kelp_memory_cubit.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/cubits/signup/bottomNavBar/bottomnavbar_cubit.dart';
import 'package:hero/cubits/signupNew/cubit/signup_cubit.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/helpers/shared_preferences/user_simple_preferences.dart';
import 'package:hero/helpers/vibration.dart';
import 'package:hero/provider/new_version_timer.dart';
import 'package:hero/repository/auth_repository.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/messaging_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'blocs/comment/comment_bloc.dart';
import 'blocs/discovery_chat/discovery_chat_bloc.dart';
import 'blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'blocs/discovery_chat_pending/discovery_chat_pending_bloc.dart';
import 'blocs/discovery_messages/discovery_message_bloc.dart';

import 'blocs/notifications/notifications_bloc.dart';

import 'blocs/profile/profile_bloc.dart';
import 'blocs/pups/pups_bloc.dart';
import 'blocs/stingrays/stingray_bloc.dart';
import 'blocs/user discovery swiping/user_discovery_bloc.dart';
import 'blocs/vote/vote_bloc.dart';
import 'blocs/wave/wave_bloc.dart';
import 'blocs/wave_replies/wave_replies_bloc.dart';
import 'cubits/comment/comment_cubit.dart';
import 'cubits/signIn/cubit/signin_cubit.dart';
import 'cubits/update/update_cubit.dart';
import 'firebase_options.dart';
import 'repository/storage_repository.dart';

//set a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    MyVibration.vibrate();
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  UserSimplePreferences.init();
  await FirebaseAppCheck.instance.activate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (_) => FirestoreRepository(),
        ),
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider(
          create: (context) => MessagingRepository(),
        ),
        RepositoryProvider(
          create: (context) => TypesenseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<BottomnavbarCubit>(
            create: (context) => BottomnavbarCubit(),
            child: MainPage(),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<KelpMemoryCubit>(
            create: (context) => KelpMemoryCubit(
              firestoreRepository: context.read<FirestoreRepository>(),
            ),
          ),
          BlocProvider<TrollingPoliceCubit>(
            create: (context) => TrollingPoliceCubit(
              firestoreRepository: context.read<FirestoreRepository>(),
            ),
          ),
          BlocProvider<SigninCubit>(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<UpdateCubit>(
            create: (context) => UpdateCubit(
              firestoreRepository: context.read<FirestoreRepository>(),
            ),
          ),
          BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(
                    authBloc: BlocProvider.of<AuthBloc>(context),
                    databaseRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<VoteBloc>(
              create: (context) => VoteBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<NotificationsBloc>(
              create: (context) => NotificationsBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<LikeBloc>(
              create: (context) => LikeBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<DiscoveryChatBloc>(
              create: (context) => DiscoveryChatBloc(
                    typesenseRepository: context.read<TypesenseRepository>(),
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<DiscoveryChatPendingBloc>(
              create: (context) => DiscoveryChatPendingBloc(
                    typesenseRepository: context.read<TypesenseRepository>(),
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<DiscoveryChatJudgeableBloc>(
              create: (context) => DiscoveryChatJudgeableBloc(
                    typesenseRepository: context.read<TypesenseRepository>(),
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<StingrayLeaderboardBloc>(
              create: (context) => StingrayLeaderboardBloc(
                    typesenseRepo: context.read<TypesenseRepository>(),
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<MessageBloc>(
              create: (context) => MessageBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<WaveLikingBloc>(
              create: (context) => WaveLikingBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<WaveDislikingBloc>(
              create: (context) => WaveDislikingBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<DiscoveryMessageBloc>(
              create: (context) => DiscoveryMessageBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<WaveRepliesBloc>(
              create: (context) => WaveRepliesBloc(
                  firestoreRepository: context.read<FirestoreRepository>(),
                  storageRepository: context.read<StorageRepository>())),
          BlocProvider<LeaderboardBloc>(
              create: (context) => LeaderboardBloc(
                  databaseRepository: context.read<FirestoreRepository>(),
                  typesenseRepository: context.read<TypesenseRepository>())),
          BlocProvider<UserVerificationBloc>(
              create: (context) => UserVerificationBloc(
                  storageRepository: context.read<StorageRepository>(),
                  databaseRepository: context.read<FirestoreRepository>(),
                  typesenseRepository: context.read<TypesenseRepository>())),
          BlocProvider<AdminVerificationBloc>(
              create: (context) => AdminVerificationBloc(
                  databaseRepository: context.read<FirestoreRepository>(),
                  typesenseRepository: context.read<TypesenseRepository>())),
          BlocProvider<SimilarPupsBloc>(
              create: (context) => SimilarPupsBloc(
                  databaseRepository: context.read<FirestoreRepository>(),
                  typesenseRepository: context.read<TypesenseRepository>())),

          //BackpackBloc
          BlocProvider<BackpackBloc>(
              create: (context) => BackpackBloc(
                  databaseRepository: context.read<FirestoreRepository>(),
                  storageRepository: context.read<StorageRepository>())),
          BlocProvider<PupsBloc>(
              create: (context) => PupsBloc(
                  databaseRepository: context.read<FirestoreRepository>(),
                  typesenseRepository: context.read<TypesenseRepository>())),
          BlocProvider<AdminBloc>(
              create: (context) => AdminBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<CloudMessagingBloc>(
              create: (context) => CloudMessagingBloc(
                  databaseRepository: context.read<FirestoreRepository>(),
                  messagingRepository: context.read<MessagingRepository>())),
          BlocProvider<CommentBloc>(
              create: (context) => CommentBloc(
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<EditbioCubit>(
            create: (context) => EditbioCubit(),
          ),
          BlocProvider<OnBoardingCubit>(
            create: (context) => OnBoardingCubit(),
          ),
          BlocProvider<CommentCubit>(
            create: (context) => CommentCubit(),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              typesenseRepository: context.read<TypesenseRepository>(),
            ),
          ),
          BlocProvider<MyWavesBloc>(
              create: (context) => MyWavesBloc(
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<SeaRealBloc>(
              create: (context) => SeaRealBloc(
                    firestoreRepository: context.read<FirestoreRepository>(),
                    typesenseRepo: context.read<TypesenseRepository>(),
                    storageRepository: context.read<StorageRepository>(),
                  )),
          BlocProvider<LikedWavesBloc>(
              create: (context) => LikedWavesBloc(
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<YipYapsBloc>(
              create: (context) => YipYapsBloc(
                    firestoreRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider(
            create: (context) => SwipeBloc(
              searchBloc: context.read<SearchBloc>(),
              firestoreRepository: context.read<FirestoreRepository>(),
              profileBloc: context.read<ProfileBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => UserDiscoveryBloc(
              firestoreRepository: context.read<FirestoreRepository>(),
              searchBloc: context.read<SearchBloc>(),
              profileBloc: context.read<ProfileBloc>(),
            ),
          ),
          BlocProvider<StingrayBloc>(
              create: (context) => StingrayBloc(
                    storageRepository: context.read<StorageRepository>(),
                    databaseRepository: context.read<FirestoreRepository>(),
                  )),
          BlocProvider<WaveBloc>(
            create: (context) => WaveBloc(
                firestoreRepository: context.read<FirestoreRepository>(),
                storageRepository: context.read<StorageRepository>(),
                typesenseRepository: context.read<TypesenseRepository>(),
                stingrayBloc: context.read<StingrayBloc>()),
          ),
        ],
        child: MultiProvider(
          providers: [
            Provider<AuthRepository>(
              create: (_) => AuthRepository(),
            ),
            ChangeNotifierProvider(
              create: (_) => NewVersionTimer(),
            )
          ],
          child: MaterialApp(
            //add the navigator key to the material app
            navigatorKey: navigatorKey,
            title: 'Stingray WV',
            theme: theme(),
            darkTheme: darkTheme(),
            themeMode: ThemeMode.system,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: Wrapper.routeName,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

Future<void> _configureFirebaseAuth() async {
  String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
  int configPort = const int.fromEnvironment("AUTH_EMU_PORT");
  // Android emulator must be pointed to 10.0.2.2
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 9099;
  await FirebaseAuth.instance.useAuthEmulator(host, port);
  debugPrint('Using Firebase Auth emulator on: $host:$port');
}

Future<void> _configureFirebaseStorage() async {
  String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
  int configPort = const int.fromEnvironment("STORAGE_EMU_PORT");
  // Android emulator must be pointed to 10.0.2.2
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 9199;
  await FirebaseStorage.instance.useStorageEmulator(host, port);
  debugPrint('Using Firebase Storage emulator on: $host:$port');
}

void _configureFirebaseFirestore() {
  String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
  int configPort = const int.fromEnvironment("DB_EMU_PORT");
  // Android emulator must be pointed to 10.0.2.2
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 8080;

  FirebaseFirestore.instance.settings = Settings(
    host: '$host:$port',
    sslEnabled: false,
    persistenceEnabled: false,
  );
  debugPrint('Using Firebase Firestore emulator on: $host:$port');
}
