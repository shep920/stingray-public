import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/my_waves/my_waves_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
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

class MyWavesScreen extends StatefulWidget {
  //add a routename and route method
  static const String routeName = '/my-waves';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const MyWavesScreen());
  }

  const MyWavesScreen({Key? key}) : super(key: key);

  @override
  State<MyWavesScreen> createState() => _MyWavesScreenState();
}

class _MyWavesScreenState extends State<MyWavesScreen> {
  late ScrollController _scrollController;
  @override
  void initState() {
    if (BlocProvider.of<MyWavesBloc>(context).state is MyWavesLoading) {
      BlocProvider.of<MyWavesBloc>(context).add(LoadMyWaves(
          user: (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
              .user));
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * .85) {
        if (BlocProvider.of<MyWavesBloc>(context, listen: false).state
            is MyWavesLoaded) {
          MyWavesLoaded state =
              BlocProvider.of<MyWavesBloc>(context, listen: false).state
                  as MyWavesLoaded;
          if (!state.loading && state.hasMore) {
            print('reached end of list');

            BlocProvider.of<MyWavesBloc>(context, listen: false).add(
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
              body: BlocBuilder<MyWavesBloc, MyWavesState>(
                builder: (context, myWavesState) {
                  if (myWavesState is MyWavesLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<MyWavesBloc>(context)
                            .add(LoadMyWaves(user: user));
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: myWavesState.waves.length,
                        itemBuilder: (context, index) {
                          Wave _wave = myWavesState.waves[index]!;
                          return WaveTile(
                            wave: _wave,
                            poster: user,
                            onDeleted: () {
                              BlocProvider.of<MyWavesBloc>(context)
                                  .add(DeleteWave(wave: _wave));

                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    );
                  }
                  if (myWavesState is MyWavesLoading) {
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
