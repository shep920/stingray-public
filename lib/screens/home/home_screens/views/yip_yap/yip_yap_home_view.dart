import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/my_waves/my_waves_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/blocs/yip_yaps/yip_yaps_bloc.dart';
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

class YipYapHomeView extends StatefulWidget {
  //add a routename and route method
  static const String routeName = '/yip-yap-home';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const YipYapHomeView());
  }

  const YipYapHomeView({Key? key}) : super(key: key);

  @override
  State<YipYapHomeView> createState() => _YipYapsScreenState();
}

class _YipYapsScreenState extends State<YipYapHomeView> {
  late ScrollController _scrollController;
  @override
  void initState() {
    if (BlocProvider.of<YipYapsBloc>(context).state is YipYapsLoading) {
      BlocProvider.of<YipYapsBloc>(context).add(LoadYipYaps(
          user: (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
              .user));
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * .85) {
        if (BlocProvider.of<YipYapsBloc>(context, listen: false).state
            is YipYapsLoaded) {
          YipYapsLoaded state =
              BlocProvider.of<YipYapsBloc>(context, listen: false).state
                  as YipYapsLoaded;
          if (!state.loading && state.hasMore) {
            print('reached end of list');

            BlocProvider.of<YipYapsBloc>(context, listen: false).add(
                (PaginateYipYaps(
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
              body: BlocBuilder<YipYapsBloc, YipYapsState>(
                builder: (context, myWavesState) {
                  if (myWavesState is YipYapsLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<YipYapsBloc>(context)
                            .add(LoadYipYaps(user: user));
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: myWavesState.yipYaps.length,
                        itemBuilder: (context, index) {
                          return WaveTile(
                            wave: myWavesState.yipYaps[index]!,
                            poster: user,
                          );
                        },
                      ),
                    );
                  }
                  if (myWavesState is YipYapsLoading) {
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
