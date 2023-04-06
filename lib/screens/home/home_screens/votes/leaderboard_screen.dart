import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hero/blocs/sea_real/sea_real_bloc.dart';
import 'package:hero/blocs/similar%20pups/similar_pups_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/helpers/generate_similar_interests.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/models/leaderboard_model.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/user_search_view_model.dart';
import 'package:hero/models/user_searchable.dart';
import 'package:hero/screens/home/home_screens/views/auto_carasol.dart';
import 'package:hero/screens/home/home_screens/views/moving_gradient.dart';
import 'package:hero/screens/home/home_screens/views/prizes_screen/prize_shelf_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/screens/home/home_screens/votes/sea_real_list.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/static_data/general_profile_data/searchbar_initial.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:hero/widgets/dismiss_keyboard.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';
import 'dart:math' as math;

import '../../../../blocs/leaderboad/leaderboard_bloc.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/pups/pups_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const SearchUsersTextField(),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is QueryLoaded) {
            if (state.query == null ||
                state.query == '' ||
                state.query == '@') {
              return const DismissKeyboard(child: DefaultLeaderboardView());
            }
            if (state.users.isEmpty)
              return const Center(
                child: Text("No users found."),
              );
            return SearchingUsersView(
              callback: (index) {
                context
                    .read<VoteBloc>()
                    .add(UpdateUserFromFirestore(user: state.users[index]!));
                Navigator.pushNamed(context, VoteScreen.routeName);
              },
              state: state,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class SearchUsersTextField extends StatelessWidget {
  const SearchUsersTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
          ),
          hintText: SearchbarInitial.initial(),
          hintStyle: const TextStyle(),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white)),

          //light grey color
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
        ),
        style: Theme.of(context).textTheme.headline6,
        onChanged: (query) async {
          context.read<SearchBloc>().add(SearchUsers(
              limit: 10,
              query: query,
              //get the user from blocprovider of profilebloc state as profile loaded
              searcher:
                  (context.read<ProfileBloc>().state as ProfileLoaded).user));
        },
        onFieldSubmitted: (value) {
          context.read<SearchBloc>().add(SearchUsers(
              limit: 0,
              query: '@',
              //get the user from blocprovider of profilebloc state as profile loaded
              searcher:
                  (context.read<ProfileBloc>().state as ProfileLoaded).user));
          //set the form field to @
        },
      ),
    );
  }
}

class SearchingUsersView extends StatelessWidget {
  final QueryLoaded state;
  //final void callback;
  final void Function(int index) callback;
  const SearchingUsersView({
    Key? key,
    required this.state,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.users.length,
            itemBuilder: (BuildContext context, int index) {
              User? user = state.users[index];
              String votes = user!.votes.toString();
              return ListTile(
                  onTap: () {
                    callback(index);
                  },
                  title: Row(
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headline5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.verified) const VerifiedIcon(size: 15)
                    ],
                  ),
                  subtitle: Text(
                    user.handle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              clipBehavior: Clip.hardEdge,
                              spacing: 5.0,
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              runAlignment: WrapAlignment.end,
                              verticalDirection: VerticalDirection.up,
                              children: GenerateSimilarInterests.generate(
                                  maxLength: 5,
                                  defualtColor:
                                      Theme.of(context).colorScheme.primary,
                                  compareTo: user,
                                  localUser:
                                      (BlocProvider.of<ProfileBloc>(context)
                                              .state as ProfileLoaded)
                                          .user),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                //a circular container of primary colors to show the votes
                                Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  votes,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          state.users[index]!.imageUrls[0] as String)));
            },
          ),
        ),
      ],
    );
  }
}

class DefaultLeaderboardView extends StatefulWidget {
  const DefaultLeaderboardView({
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultLeaderboardView> createState() => _DefaultLeaderboardViewState();
}

class _DefaultLeaderboardViewState extends State<DefaultLeaderboardView> {
  late ScrollController _scrollController;
  bool loading = false;
  @override
  void initState() {
    if (BlocProvider.of<SimilarPupsBloc>(context).state is SimilarPupsLoading) {
      BlocProvider.of<SimilarPupsBloc>(context)
          .add(LoadSimilarPups(user: Get.blocUser(context)));
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (BlocProvider.of<SimilarPupsBloc>(context, listen: false).state
          is SimilarPupsLoaded) {
        SimilarPupsLoaded state =
            BlocProvider.of<SimilarPupsBloc>(context, listen: false).state
                as SimilarPupsLoaded;
        if ((_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * .65) &&
            !state.isLoading &&
            state.hasMore &&
            (state.totalLoaded < state.cap)) {
          print('reached end of list');
          BlocProvider.of<SimilarPupsBloc>(context, listen: false).add(
              (PaginateSimilarPups(
                  user: (BlocProvider.of<ProfileBloc>(context).state
                          as ProfileLoaded)
                      .user)));
        }
      }
    });

    if (BlocProvider.of<LeaderboardBloc>(context).state is LeaderboardLoading) {
      BlocProvider.of<LeaderboardBloc>(context, listen: false)
          .add(LoadLeaderboard(user: Get.blocUser(context)));
    }

    if (BlocProvider.of<PupsBloc>(context).state is PupsLoading) {
      BlocProvider.of<PupsBloc>(context, listen: false)
          .add(LoadPups(user: Get.blocUser(context)));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardBloc, LeaderboardState>(
      builder: (context, leaderboardState) {
        if (leaderboardState is LeaderboardLoading)
          return const Center(
            child: CircularProgressIndicator(),
          );
        if (leaderboardState is LeaderboardLoaded) {
          return (leaderboardState.leaderboard.isEmpty)
              ? RefreshIndicator(
                  onRefresh: () async {
                    context.read<LeaderboardBloc>().add(LoadLeaderboard(
                        user:
                            (context.read<ProfileBloc>().state as ProfileLoaded)
                                .user));
                  },
                  child: ListView(
                    children: [
                      Center(
                          child: Column(
                        children: [
                          Text(
                              'Looks like no one\'s voted yet. Be the first to vote!',
                              style: Theme.of(context).textTheme.headline2),
                          //an icon of a hand pointing to the vote button
                          const Icon(
                            Icons.arrow_upward,
                            size: 50,
                          ),
                        ],
                      )),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<LeaderboardBloc>().add(LoadLeaderboard(
                        user:
                            (context.read<ProfileBloc>().state as ProfileLoaded)
                                .user));
                    BlocProvider.of<SeaRealBloc>(context, listen: false)
                        .add((LoadSeaReal(user: Get.blocUser(context))));
                  },
                  child: ListView(controller: _scrollController, children: [
                    buildTopPupsHeader(context),
                    buildChart(context, leaderboardState),
                    const SizedBox(
                      height: 10.0,
                    ),
                    buildTopPupPics(leaderboardState, context),
                    const SizedBox(
                      height: 10.0,
                    ),
                    buildCarasol(context),
                    buildSimilarPupsHeader(context),
                    //make a blocbuilder for SimilarPupsBloc
                    BlocBuilder<SimilarPupsBloc, SimilarPupsState>(
                        builder: (context, similarPupsState) {
                      if (similarPupsState is SimilarPupsLoading) {
                        return Center(
                          child: Container(),
                        );
                      }
                      if (similarPupsState is SimilarPupsLoaded) {
                        List<User?> similarPups = similarPupsState.similarPups;
                        return (similarPups.isEmpty)
                            ? Center(
                                child: Text(
                                  'No similar pups found',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: similarPups.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  User? user = similarPups[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/votes');
                                      Provider.of<VoteBloc>(context,
                                              listen: false)
                                          .add(UpdateUserFromFirestore(
                                              user: user!));
                                    },
                                    child: SimilarPupTile(
                                      user: user,
                                      showVotes: false,
                                    ),
                                  );
                                },
                              );
                      }
                      return Center(
                        child: Container(),
                      );
                    })
                  ]),
                );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  SizedBox buildCarasol(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250.0,
      child: Stack(
        children: [
          const MovingGradientBackground(),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Prizes',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150.0,
                      child: AutoCarasolWidget(
                          imageUrls: Prize.examplePrizes
                              .map((prize) => prize.imageUrl)
                              .toList(),
                          onTap: (index) {
                            Navigator.pushNamed(
                                context, PrizeShelfScreen.routeName);
                          }),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              BlocBuilder<PupsBloc, PupsState>(
                builder: (context, pupState) {
                  if (pupState is PupsLoading) {
                    return Container();
                  }
                  if (pupState is PupsLoaded) {
                    List<User?> pups = pupState.pups;
                    return (pups.isEmpty)
                        ? Container()
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Featured',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      //put an iconbutton of a question mark here
                                      Flexible(
                                        child: IconButton(
                                          onPressed: () {
                                            GenericAwesomeDialog.showDialog(
                                              context: context,
                                              title: 'Featured minnows',
                                              description:
                                                  'Featured minnows are minnows that, for one reason or another, are guaranteed to become a Stingray next week.',
                                            ).show();
                                          },
                                          icon: const Icon(Icons.help),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  height: 150.0,
                                  child: AutoCarasolWidget(
                                      onTap: (index) {
                                        Provider.of<VoteBloc>(context,
                                                listen: false)
                                            .add(UpdateUserFromFirestore(
                                                user: pups[index]!));
                                        Navigator.pushNamed(
                                            context, VoteScreen.routeName);
                                      },
                                      imageUrls: pups
                                          .map((pup) =>
                                              pup!.imageUrls[0] as String)
                                          .toList()),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row buildSimilarPupsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Other Minnows',
          style: Theme.of(context).textTheme.headline2,
        ),
        //put an iconbutton of a question mark here
      ],
    );
  }

  Center buildTopPupPics(
      LeaderboardLoaded leaderboardState, BuildContext context) {
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        children: List.generate(
          leaderboardState.leaderboard.take(5).length,
          (index) {
            User? user = leaderboardState.leaderboard[index];
            return GestureDetector(
              onTap: () {
                Provider.of<VoteBloc>(context, listen: false)
                    .add(UpdateUserFromFirestore(user: user!));
                Navigator.pushNamed(context, VoteScreen.routeName);
              },
              child: PupImage(user: user),
            );
          },
        ),
      ),
    );
  }

  SizedBox buildChart(
      BuildContext context, LeaderboardLoaded leaderboardState) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: leaderboardState.leaderboard.isNotEmpty
            ? leaderboardState.leaderboard[0]!.votes.toDouble()
            : 0,
        minY: 0,
        barTouchData: BarTouchData(enabled: true),
        barGroups: List.generate(
          leaderboardState.leaderboard.take(5).length,
          (index) {
            User? user = leaderboardState.leaderboard[index];
            return BarChartGroupData(
              x: index + 1,
              barRods: [
                BarChartRodData(
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
                  width: 20,
                  toY: user!.votes.toDouble(),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            );
          },
        ),
      )),
    );
  }

  Row buildTopPupsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'Top Minnows',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        //put an iconbutton of a question mark here
        Flexible(
          child: IconButton(
            onPressed: () {
              AwesomeDialog(
                titleTextStyle: Theme.of(context).textTheme.headline2,
                descTextStyle: Theme.of(context).textTheme.headline5,
                context: context,
                dialogType: DialogType.info,
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
                width: 680,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                headerAnimationLoop: false,
                animType: AnimType.bottomSlide,
                title: 'Minnows',
                desc:
                    'Minnows are little fish. In this app, you\'re a minnow until you become a stingray, and you become a stingray by getting the most votes!',
                showCloseIcon: true,
                btnOkOnPress: () {},
              ).show();
            },
            icon: const Icon(Icons.help),
          ),
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final int index;

  const Tile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Text('Tile $index'),
      ),
    );
  }
}

class PupImage extends StatelessWidget {
  const PupImage({
    Key? key,
    required this.user,
    this.showVotes = true,
  }) : super(key: key);

  final User? user;
  final bool showVotes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width * .2,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                imageUrl: user!.imageUrls[0],
                fit: BoxFit.cover,
                memCacheHeight: 150,
                memCacheWidth: 150,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            if (showVotes)
              Positioned(
                top: 0,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Votes: ${user!.votes}',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user!.name,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      if (user!.verified)
                        const VerifiedIcon(
                          size: 20.0,
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimilarPupTile extends StatelessWidget {
  const SimilarPupTile({
    Key? key,
    required this.user,
    this.showVotes = true,
  }) : super(key: key);

  final User? user;
  final bool showVotes;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .3,
                  imageUrl: user!.imageUrls[0],
                  fit: BoxFit.cover,
                  memCacheHeight: 275,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          if (showVotes)
            Positioned(
              top: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Votes: ${user!.votes}',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user!.name,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    if (user!.verified)
                      const VerifiedIcon(
                        size: 20.0,
                      )
                  ],
                ),
                Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  children: GenerateSimilarInterests.generate(
                      defualtColor: Colors.white,
                      compareTo: user!,
                      localUser: (BlocProvider.of<ProfileBloc>(context).state
                              as ProfileLoaded)
                          .user),
                ),
                //make a
              ],
            ),
          ),
        ],
      ),
    );
  }
}
