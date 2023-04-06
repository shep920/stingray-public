import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/stingray_leaderboard_bloc/stingray_leaderboard_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/helpers/shared_preferences/user_simple_preferences.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/models/waves_meta_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/banned/banned_screen.dart';
import 'package:hero/screens/home/home_screens/views/stingray_leaderboard/all_stingrays_leaderboard.dart';
import 'package:hero/screens/home/home_screens/views/story/story_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/waves_replies_screen.dart';
import 'package:hero/screens/home/home_screens/views/widgets/hot_and_recent_selector.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:like_button/like_button.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
//import timeago package
import 'package:timeago/timeago.dart' as timeago;

import '../../../../blocs/like/like_bloc.dart';
import '../../../../blocs/message/message_bloc.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/stingrays/stingray_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart' as vote;
import '../../../../blocs/wave/wave_bloc.dart';
import '../../../../blocs/wave_liking/wave_liking_bloc.dart';
import '../../../../blocs/wave_replies/wave_replies_bloc.dart' as waveReplies;
import '../../../../models/models.dart';
import '../../../../repository/firestore_repository.dart';
import '../../../../widgets/like_card.dart';
import '../../../../widgets/text_splitter.dart';
import 'waves/widget/wave_tile.dart';

class GenericView extends StatefulWidget {
  const GenericView({Key? key}) : super(key: key);

  @override
  State<GenericView> createState() => _GenericViewState();
}

class _GenericViewState extends State<GenericView> {
//setup a scrollController to paginate the waves
  int selectedIndex = 0;
  int imageUrlIndex = 0;

  late ScrollController _scrollController;
  bool isLoading = false;
  bool hasMore = true;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      WaveLoaded state =
          BlocProvider.of<WaveBloc>(context, listen: false).state as WaveLoaded;
      StingrayLoaded stingraystate =
          BlocProvider.of<StingrayBloc>(context, listen: false).state
              as StingrayLoaded;
      if ((_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * .6) &&
          !state.isLoading &&
          (stingraystate.selectedIndex == -1 ||
                  (stingraystate.selectedIndex == -1)
              ? (state.featureSortParam == TsKeywords.newParam)
                  ? state.featuredWavesMeta.hasMore
                  : state.hotfeaturedWavesMeta.hasMore
              : state.wavesMeta[stingraystate.selectedIndex].hasMore)) {
        BlocProvider.of<WaveBloc>(context, listen: false)
            .add(const UpdateLoadingStatus());

        BlocProvider.of<WaveBloc>(context, listen: false).add(PaginateWaves(
            stingray: (stingraystate.selectedIndex == -1)
                ? Stingray.featuredStingray()
                : stingraystate.stingrays[stingraystate.selectedIndex]!));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          if (profileState.user.isBanned &&
              profileState.user.banExpiration.isAfter(DateTime.now())) {
            Navigator.pushReplacementNamed(context, BannedScreen.routeName);
            return Container();
          }
          return BlocBuilder<StingrayBloc, StingrayState>(
            builder: (context, state) {
              if (state is StingrayLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is StingrayLoaded) {
                List<Stingray?> stingrays = state.stingrays;

                Stingray? stingray = (state.stingrays.isNotEmpty)
                    ? (state.selectedIndex == -1)
                        ? Stingray.featuredStingray()
                        : state.stingrays[state.selectedIndex]
                    : null;

                return (stingray != null)
                    ? RefreshIndicator(
                        //primary color
                        color: Theme.of(context).colorScheme.primary,
                        onRefresh: () async {
                          final state =
                              BlocProvider.of<WaveBloc>(context, listen: false)
                                  .state as WaveLoaded;
                          //blocProvider of waveBloc to check the state of the waveBloc
                          if ((state is WaveLoaded && state.timer == null) ||
                              (!state.timer!.isActive)) {
                            //add the Refresh event to the waveBloc
                            BlocProvider.of<WaveBloc>(context, listen: false)
                                .add(RefreshStingrayWaves(stingray: stingray));
                            BlocProvider.of<WaveLikingBloc>(context,
                                    listen: false)
                                .add(DeleteShortTermMemory());
                          }

                          final leaderBoardState =
                              BlocProvider.of<StingrayLeaderboardBloc>(context,
                                      listen: false)
                                  .state as StingrayLeaderboardLoaded;

                          if ((leaderBoardState.refreshable)) {
                            //add the Refresh event to the waveBloc
                            BlocProvider.of<StingrayLeaderboardBloc>(context,
                                    listen: false)
                                .add(LoadStingrayLeaderboard(
                                    stingrays: stingrays));
                          }
                        },
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            Column(
                              children: [
                                buildHeader(context, state),
                                const SizedBox(
                                  height: 10,
                                ),
                                AllStingraysLeaderboad(),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (state.selectedIndex == -1)
                                  HotAndRecentSelector(),
                                if (state.selectedIndex == -1)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                BlocBuilder<WaveBloc, WaveState>(
                                  builder: (context, waveState) {
                                    if (waveState is WaveLoading) {
                                      BlocProvider.of<WaveBloc>(context).add(
                                          LoadWave(stingrays: state.stingrays));
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (waveState is WaveLoaded) {
                                      WavesMeta? wavesMeta = (state
                                                  .selectedIndex ==
                                              -1)
                                          ? (waveState.featureSortParam ==
                                                  TsKeywords.newParam)
                                              ? waveState.featuredWavesMeta
                                              : waveState.hotfeaturedWavesMeta
                                          : waveState.wavesMeta
                                              .firstWhereOrNull((element) =>
                                                  element.stingray.id ==
                                                  stingray.id);

                                      List<Wave?>? waves = (wavesMeta == null)
                                          ? null
                                          : wavesMeta.waves;

                                      return (waves == null)
                                          ? //minimum space possible
                                          const SizedBox(
                                              height: 1,
                                            )
                                          : Column(
                                              children: [
                                                ListView.builder(
                                                  itemCount: waves.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int waveIndex) {
                                                    Wave wave =
                                                        waves[waveIndex]!;

                                                    Stingray? _stingray = state
                                                        .stingrays
                                                        .firstWhereOrNull(
                                                      (element) =>
                                                          element!.id ==
                                                          wave.senderId,
                                                    );

                                                    User? _poster =
                                                        (_stingray != null)
                                                            ? User.fromStingray(
                                                                _stingray)
                                                            : null;

                                                    WaveTile? waveTile =
                                                        (_poster != null)
                                                            ? WaveTile(
                                                                poster: _poster,
                                                                wave: wave,
                                                                onDeleted: () {
                                                                  BlocProvider.of<
                                                                              WaveBloc>(
                                                                          context)
                                                                      .add(DeleteWave(
                                                                          wave:
                                                                              wave));

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )
                                                            : null;
                                                    return (waveTile != null)
                                                        ? InkWell(
                                                            onTap: () {
                                                              goToReplies(
                                                                  waveTile,
                                                                  context);
                                                            },
                                                            child:
                                                                buildGenericWaveTile(
                                                                    waveTile))
                                                        : const SizedBox
                                                            .shrink();
                                                  },
                                                ),
                                                (waveState.isLoading)
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : const SizedBox(
                                                        height: 1,
                                                      )
                                              ],
                                            );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'Weird. Looks like there are no stingrays yet :/',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      );
              } else {
                return Container(
                  child: const Text("Loading"),
                );
              }
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Padding buildStingrayPictures(BuildContext context, Stingray stingray) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.4,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            stingray.imageUrls[imageUrlIndex])),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(3, 3),
                      )
                    ]),
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
              GestureDetector(child: LayoutBuilder(builder: (ctx, constraints) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Opacity(
                    opacity: 0.0,
                    child: Container(
                      color: Colors.black,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth * 0.3,
                    ),
                  ),
                );
              }), onTap: () {
                setState(() {
                  //if the index is the last index, then go back to the first index
                  if (imageUrlIndex == stingray.imageUrls.length - 1) {
                    imageUrlIndex = 0;
                  } else {
                    imageUrlIndex++;
                  }
                });
              }),
              GestureDetector(child: LayoutBuilder(builder: (ctx, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: 0.0,
                    child: Container(
                      color: Colors.black,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth * 0.3,
                    ),
                  ),
                );
              }), onTap: () {
                setState(() {
                  //if the index is the first index, then go back to the last index
                  if (imageUrlIndex == 0) {
                    imageUrlIndex = stingray.imageUrls.length - 1;
                  } else {
                    imageUrlIndex--;
                  }
                });
              }),
              Positioned(
                bottom: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stingray.name}, ${stingray.age}',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '${stingray.jobTitle}',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.info_outline,
                              size: 25,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            //show an alert dialog explaining the red flags
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text(
                                        'Red Flags',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!,
                                      ),
                                      content: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Image(
                                                image: AssetImage(
                                                    'assets/red_flag.gif')),
                                            Text(
                                              'A Stingray gets a red flag every time they are blocked. Nothing really happens if they get a bunch, it just shows they are sus.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('OK',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        )
                                      ],
                                    ));
                          },
                          child: Container(
                              width: 50,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text.rich(TextSpan(
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.flag,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${stingray.redFlags}',
                                    ),
                                  ],
                                )),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                  child: StepProgressIndicator(
                    totalSteps: stingray.imageUrls.length,
                    currentStep: imageUrlIndex + 1,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    unselectedColor: Theme.of(context).scaffoldBackgroundColor,
                    size: 10,
                  ),
                  top: 0,
                  left: 0,
                  right: 0),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildHeader(BuildContext context, StingrayLoaded state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                        imageUrlIndex = 0;
                      });
                      Provider.of<StingrayBloc>(context, listen: false)
                          .add(const UpdateSelectedIndex(selectedIndex: -1));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (-1 == state.selectedIndex)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent),
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 40,
                          child: FaIcon(
                            FontAwesomeIcons.crown,
                            size: 40,
                            color: (state.selectedIndex == -1)
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).colorScheme.primary,
                          )),
                    ))),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.stingrays.length,
                itemBuilder: (BuildContext context, int rowIndex) {
                  Stingray _stingray = state.stingrays[rowIndex]!;
                  List<Story>? _stories =
                      state.storiesMap[state.stingrays[rowIndex]!.id!];
                  bool seenAllStories = _stories != null &&
                      _stories.every(
                          (story) => state.seenStoryIds.contains(story.id));
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                        child: GestureDetector(
                            onTap: () {
                              Stingray _selectedStingray =
                                  state.stingrays[rowIndex]!;
                              List<Story>? _selectedStories =
                                  state.storiesMap[_selectedStingray.id!];

                              setState(() {
                                selectedIndex = rowIndex;
                                imageUrlIndex = 0;
                              });

                              if (_selectedStories != null &&
                                  _selectedStories.length > 0 &&
                                  (!seenAllStories ||
                                      state.selectedIndex == rowIndex)) {
                                _selectedStories.sort(
                                    (a, b) => b.postedAt.compareTo(a.postedAt));

                                _selectedStories.sort((a, b) {
                                  if (state.seenStoryIds.contains(a.id)) {
                                    return 1;
                                  } else if (state.seenStoryIds
                                      .contains(b.id)) {
                                    return -1;
                                  } else {
                                    return 0;
                                  }
                                });

                                BlocProvider.of<StingrayBloc>(context)
                                    .add(ViewStory(story: _selectedStories[0]));

                                Navigator.of(context).pushNamed(
                                    StoryView.routeName,
                                    arguments: _stories);
                              } else {
                                Provider.of<StingrayBloc>(context,
                                        listen: false)
                                    .add(UpdateSelectedIndex(
                                        selectedIndex: rowIndex));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (rowIndex == state.selectedIndex)
                                    ? Theme.of(context).colorScheme.primary
                                    : (seenAllStories)
                                        ? Colors.transparent
                                        : Colors.green,
                              ),
                              child: Hero(
                                tag: state.stingrays[rowIndex]!.id!,
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 40,
                                    child: (_stingray.id! == 'featured')
                                        ? FaIcon(
                                            FontAwesomeIcons.crown,
                                            size: 40,
                                            color: (rowIndex ==
                                                    state.selectedIndex)
                                                ? Theme.of(context)
                                                    .scaffoldBackgroundColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          )
                                        : ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: _stingray.imageUrls[0],
                                              fit: BoxFit.cover,
                                              memCacheHeight: 150,
                                              memCacheWidth: 150,
                                            ),
                                          )),
                              ),
                            ))),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buildGenericWaveTile(WaveTile waveTile) {
    return (waveTile.wave.threadId != null)
        ? ThreadedWaveTile(context: context, waveTile: waveTile)
        : waveTile;
  }
}

class ThreadedWaveTile extends StatelessWidget {
  const ThreadedWaveTile({
    Key? key,
    required this.waveTile,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  final WaveTile waveTile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WaveTile(
            poster: waveTile.poster,
            wave: waveTile.wave,
            showDivider: false,
            extendBelow: true,
            onDeleted: () {
              BlocProvider.of<WaveBloc>(context)
                  .add(DeleteWave(wave: waveTile.wave));

              Navigator.pop(context);
            }),
        Row(
          //show a smaller circle avatr, then text saying show this thread
          children: [
            Container(
              margin:
                  const EdgeInsets.only(bottom: 10.0, left: 15.0, right: 10.0),
              width: 40,
              height: 40,
              child: InkWell(
                child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        waveTile.poster.imageUrls[0])),
                onTap: () {
                  BlocProvider.of<vote.VoteBloc>(context)
                      .add(vote.LoadUserEvent(user: waveTile.poster));
                  Navigator.pushNamed(
                    context,
                    '/votes',
                  );
                },
              ),
            ),
            InkWell(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Show this thread',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: ExtraColors.highlightColor,
                      ),
                ),
              ),
              onTap: () {
                goToReplies(waveTile, context);
              },
            ),
          ],
        ),
        //horizontal line
        Container(
          child: Divider(
            color: Theme.of(context).backgroundColor,
            thickness: .1,
          ),
        ),
      ],
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
