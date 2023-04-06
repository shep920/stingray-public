import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/blocs/yip_yaps/yip_yaps_bloc.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/user-verification/accepted_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/initial_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/pending_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/rejected_verification_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/compose_wave.dart';
import 'package:hero/screens/home/home_screens/views/waves/waves_replies_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:hero/widgets/widgets.dart';
//import flutter test
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as riv;

class YipYapScreen extends StatefulWidget {
  //add a routename and route method
  static const String routeName = '/my-waves';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const YipYapScreen());
  }

  const YipYapScreen({Key? key}) : super(key: key);

  @override
  State<YipYapScreen> createState() => _YipYapsScreenState();
}

class _YipYapsScreenState extends State<YipYapScreen> {
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
          return Scaffold(body: BlocBuilder<YipYapsBloc, YipYapsState>(
            builder: (context, myWavesState) {
              if (myWavesState is YipYapsLoaded) {
                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<YipYapsBloc>(context)
                            .add(LoadYipYaps(user: user));
                      },
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  const riv.RiveAnimation.asset(
                                      'assets/riv/beach.riv',
                                      fit: BoxFit.cover),
                                  Align(
                                    //middle
                                    alignment: Alignment.bottomCenter,

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'The Bay',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        //an information iconbutton
                                        IconButton(
                                          icon: const Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            GenericAwesomeDialog.showDialog(
                                                    context: context,
                                                    title: 'The Bay',
                                                    description:
                                                        'Welcome to The Bay! This is where you can share your thoughts and experiences with complete secrecy. The Waves here act just like normal Waves, but the best part is that your posts will be kept a secret. So feel free to let it all out and be yourself, no one will ever know it was you!')
                                                .show();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //a container of gradient color from E1BC56 to scaffold background color

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: myWavesState.yipYaps.length,
                            itemBuilder: (context, index) {
                              Wave _yipYap = myWavesState.yipYaps[index]!;
                              User _anon = User.anon(_yipYap.senderId);
                              WaveTile _waveTile = WaveTile(
                                wave: _yipYap,
                                poster: _anon,
                                onDeleted: () {
                                  BlocProvider.of<WaveBloc>(context)
                                      .add(DeleteWave(wave: _yipYap));
                                  BlocProvider.of<YipYapsBloc>(context)
                                      .add(DeleteYipYap(wave: _yipYap));
                                  Navigator.pop(context);
                                },
                              );
                              return InkWell(
                                child: _waveTile,
                                onTap: () {
                                  goToReplies(_waveTile, context);
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                            child: TextField(
                              enabled: false,
                              style: Theme.of(context).textTheme.headline4,
                              decoration: InputDecoration(
                                  //have some padding
                                  contentPadding: const EdgeInsets.all(8.0),
                                  //fill color of scaffold background
                                  fillColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  filled: true,

                                  //circule border
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  hintText: 'Send a secret wave!'),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ComposeWaveScreen.routeName,
                                  arguments: Wave.yip_yap_type);
                            }),
                      ),
                    ),
                  ],
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

void goToReplies(WaveTile waveTile, BuildContext context) {
  User user =
      (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
  BlocProvider.of<TrollingPoliceCubit>(context)
      .upDateTrolling(waveTile.wave.id, context, user);
  Map<String, dynamic> _map = {
    'waveTileList': [waveTile],
    'isThread': (waveTile.wave.threadId != null),
  };
  Navigator.pushNamed(context, WaveRepliesScreen.routeName, arguments: _map);
}
