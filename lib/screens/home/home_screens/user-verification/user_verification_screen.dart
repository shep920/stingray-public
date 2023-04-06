import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/user-verification/accepted_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/initial_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/pending_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/rejected_verification_screen.dart';
import 'package:hero/widgets/widgets.dart';
//import flutter test
import 'package:flutter_test/flutter_test.dart';

class UserVerificationScreen extends StatefulWidget {
  //add a routename and route method
  static const String routeName = '/user-verification';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const UserVerificationScreen());
  }

  const UserVerificationScreen({Key? key}) : super(key: key);

  @override
  State<UserVerificationScreen> createState() => _UserVerificationScreenState();
}

class _UserVerificationScreenState extends State<UserVerificationScreen> {
  @override
  void initState() {
    if (BlocProvider.of<UserVerificationBloc>(context).state
        is UserVerificationLoading) {
      BlocProvider.of<UserVerificationBloc>(context).add(LoadUserVerification(
          user: (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
              .user));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return Scaffold(
              appBar: const TopAppBar(),
              body: BlocBuilder<UserVerificationBloc, UserVerificationState>(
                builder: (context, verificationState) {
                  if (verificationState is UserVerificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (verificationState is UserVerificationInitial) {
                    return const InitialVerificationScreen();
                  }
                  if (verificationState is UserVerificationPending) {
                    return const PendingVerificationScreen();
                  }
                  if (verificationState is UserVerificationAccepted) {
                    return const AcceptedVerificationScreen();
                  }
                  if (verificationState is UserVerificationRejected) {
                    return RejectedVerificationScreen(
                      userVerification: verificationState.userVerification,
                    );
                  }
                  return Container();
                },
              ));
        }
        return Container();
      },
    );
  }
}
