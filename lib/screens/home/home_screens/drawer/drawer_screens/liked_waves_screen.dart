import 'package:collection/collection.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/liked_waves/liked_waves_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/helpers/go_to_replies.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/user-verification/accepted_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/initial_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/pending_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/rejected_verification_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/widgets/widgets.dart';
//import flutter test
import 'package:flutter_test/flutter_test.dart';

class LikedWavesScreen extends StatefulWidget {
  //add a routename and route method
  static const String routeName = '/liked-waves';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const LikedWavesScreen());
  }

  const LikedWavesScreen({Key? key}) : super(key: key);

  @override
  State<LikedWavesScreen> createState() => _LikedWavesScreenState();
}

class _LikedWavesScreenState extends State<LikedWavesScreen> {
  late ScrollController _scrollController;
  @override
  void initState() {
    if (BlocProvider.of<LikedWavesBloc>(context).state is LikedWavesLoading) {
      BlocProvider.of<LikedWavesBloc>(context).add(LoadLikedWaves(
          user: (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
              .user));
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * .85) {
        if (BlocProvider.of<LikedWavesBloc>(context, listen: false).state
            is LikedWavesLoaded) {
          LikedWavesLoaded state =
              BlocProvider.of<LikedWavesBloc>(context, listen: false).state
                  as LikedWavesLoaded;
          if (!state.loading && state.hasMore) {
            print('reached end of list');

            BlocProvider.of<LikedWavesBloc>(context, listen: false).add(
                (PaginateWaves(
                    user: (BlocProvider.of<ProfileBloc>(context).state
                            as ProfileLoaded)
                        .user)));
          }
        }
      }
    });

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
              body: BlocBuilder<LikedWavesBloc, LikedWavesState>(
                builder: (context, myWavesState) {
                  if (myWavesState is LikedWavesLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<LikedWavesBloc>(context)
                            .add(LoadLikedWaves(user: user));
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: myWavesState.waves.length,
                        itemBuilder: (context, index) {
                          Wave _wave = myWavesState.waves[index]!;
                          User? _poster = myWavesState.userPool
                              .firstWhereOrNull(
                                  (wave) => wave!.id == _wave.senderId);
                          WaveTile? _waveTile = (_poster == null)
                              ? null
                              : WaveTile(
                                  wave: _wave,
                                  poster: _poster,
                                  onDeleted: () {
                                    BlocProvider.of<LikedWavesBloc>(context)
                                        .add(DeleteWave(wave: _wave));

                                    Navigator.pop(context);
                                  },
                                );
                          return (_waveTile == null)
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    GoTo.replies(_waveTile, context);
                                  },
                                  child: _waveTile,
                                );
                        },
                      ),
                    );
                  }
                  if (myWavesState is LikedWavesLoading) {
                    return const Center(child: CircularProgressIndicator());
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
