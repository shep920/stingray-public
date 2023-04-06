import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/stingrays/stingray_stats_model.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/stingray_leaderboard_bloc/stingray_leaderboard_bloc.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/screens/home/home_screens/views/moving_gradient.dart';
import 'package:hero/screens/home/home_screens/views/stingray_leaderboard.dart';
import 'package:hero/screens/home/home_screens/views/stingray_leaderboard/focal_leaderboard_column.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AllStingraysLeaderboad extends StatefulWidget {
  const AllStingraysLeaderboad({
    super.key,
  });

  @override
  State<AllStingraysLeaderboad> createState() => _AllStingraysLeaderboadState();
}

class _AllStingraysLeaderboadState extends State<AllStingraysLeaderboad> {
  bool _isExpanded = false;

  late ScrollController _scrollController;

  initState() {
    if (Get.stingrayLeaderState(context) is StingrayLeaderboardLoading) {
      BlocProvider.of<StingrayLeaderboardBloc>(context)
          .add(LoadStingrayLeaderboard(stingrays: Get.stingrays(context)));
    }

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent * 0.9) {
        final state = Get.stingrayLeaderState(context);
        if (state is StingrayLeaderboardLoaded) {
          if (state.hasMore) {
            BlocProvider.of<StingrayLeaderboardBloc>(context).add(PaginateStats(
              stingrays: Get.stingrays(context),
            ));
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StingrayLeaderboardBloc, StingrayLeaderboardState>(
      builder: (context, stingrayLeaderboardState) {
        if (stingrayLeaderboardState is StingrayLeaderboardLoading) {
          return Container(
            height: 350,
          );
        }
        if (stingrayLeaderboardState is StingrayLeaderboardLoaded) {
          return BlocBuilder<StingrayBloc, StingrayState>(
            builder: (context, stingrayState) {
              if (stingrayState is StingrayLoaded) {
                List<StingrayStats?> stats = stingrayLeaderboardState.stats;
                List<Stingray?> stingrays = stingrayState.stingrays;
                List<StingrayStats?> sortedStats = stats.toList()
                  ..sort((a, b) => b!.totalScore.compareTo(a!.totalScore));

                List<StingrayStats?> top3Stats = sortedStats.take(3).toList();
                List<Stingray?> sortedStingrays = [];
                sortedStats.forEach((stat) {
                  Stingray? stingray = stingrays.firstWhere(
                    (stingray) => stingray!.id == stat!.stingrayId,
                    orElse: () => null,
                  );
                  if (stingray != null) {
                    sortedStingrays.add(stingray);
                  }
                });

                List<Stingray?> top3Stingrays = [];
                if (top3Stats.isNotEmpty) {
                  Stingray? topStingray = stingrays.firstWhere(
                    (stingray) => stingray!.id == top3Stats.first!.stingrayId,
                    orElse: () => null,
                  );
                  StingrayStats? topStingrayStats = top3Stats.first!;
                  top3Stingrays.add(topStingray);
                  if (top3Stats.length > 1) {
                    Stingray? secondStingray = stingrays.firstWhere(
                      (stingray) => stingray!.id == top3Stats[1]!.stingrayId,
                      orElse: () => null,
                    );
                    StingrayStats? secondStingrayStats = top3Stats[1]!;
                    top3Stingrays.add(secondStingray);
                  }
                  if (top3Stats.length > 2) {
                    Stingray? thirdStingray = stingrays.firstWhere(
                      (stingray) => stingray!.id == top3Stats[2]!.stingrayId,
                      orElse: () => null,
                    );
                    StingrayStats? thirdStingrayStats = top3Stats[2]!;
                    top3Stingrays.add(thirdStingray);
                  }
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isExpanded ? 850 : 350.0,
                    child: Stack(
                      children: [
                        const MovingGradientBackground(),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Top Stingrays',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
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
                                            title: 'Top Stingrays',
                                            description:
                                                'These are the people winning. 1 like is one point, 1 dislike is -1 point. Winners get the prizes.')
                                        .show();
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (top3Stingrays[1] != null)
                                  buildFollowUpLeader(
                                    second: true,
                                    stingray: top3Stingrays[1]!,
                                    stats: top3Stats[1]!,
                                  ).animate().fade(),
                                if (top3Stingrays[0] != null)
                                  buildLeader(
                                    stingray: top3Stingrays[0]!,
                                    stats: top3Stats[0]!,
                                  ).animate().fade(),
                                if (top3Stingrays[2] != null)
                                  buildFollowUpLeader(
                                    second: false,
                                    stingray: top3Stingrays[2]!,
                                    stats: top3Stats[2]!,
                                  ).animate().fade(),
                              ],
                            ),
                            if (_isExpanded)
                              SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: sortedStingrays.length,
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return StingrayLeaderboardListTile(
                                      stingray: sortedStingrays[index]!,
                                      stats: sortedStats[index]!,
                                      index: index,
                                    );
                                  },
                                ),
                              ),
                            SizedBox(
                              height: 50,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }

  Widget buildLeader(
      {required Stingray stingray, required StingrayStats stats}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const FaIcon(
          FontAwesomeIcons.chessQueen,
          color: Colors.white,
          size: 48,
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Shimmer(
              period: const Duration(milliseconds: 1000),
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(255, 215, 0, 1),
                  Color.fromRGBO(255, 255, 255, 0.8),
                  Color.fromRGBO(255, 215, 0, 1),
                ],
                stops: [
                  0.4,
                  0.5,
                  0.6,
                ],
                begin: Alignment(-1.0, -0.5),
                end: Alignment(2.0, 0.5),
                tileMode: TileMode.clamp,
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ExtraColors.gold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context
                    .read<VoteBloc>()
                    .add(LoadUserFromFirestore(stingray.id));
                Navigator.pushNamed(context, VoteScreen.routeName);
              },
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: stingray.imageUrls[0],
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                    memCacheHeight: 200,
                    memCacheWidth: 200,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        leaderText(text: stingray.name),
        leaderText(text: stats.totalScore.toString()),
      ],
    );
  }

  Text leaderText({required String text, bool isFirst = true}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline5!.copyWith(
          color: Colors.white,
          fontWeight: (isFirst) ? FontWeight.bold : FontWeight.normal),
    );
  }

  Widget buildFollowUpLeader(
      {required bool second,
      required Stingray stingray,
      required StingrayStats stats}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 35),
        FaIcon(
          (second) ? FontAwesomeIcons.chessRook : FontAwesomeIcons.chessKnight,
          color: Colors.white.withOpacity(0.7),
          size: 48,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            context.read<VoteBloc>().add(LoadUserFromFirestore(stingray.id));
            Navigator.pushNamed(context, VoteScreen.routeName);
          },
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (second)
                  ? const Color.fromRGBO(192, 192, 192, 1)
                  : const Color.fromRGBO(205, 127, 50, 1),
            ),
            child: Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CachedNetworkImage(
                imageUrl: stingray.imageUrls[0],
                fit: BoxFit.fill,
                memCacheHeight: 200,
                memCacheWidth: 200,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        leaderText(text: stingray.name, isFirst: false),
        leaderText(text: stats.totalScore.toString(), isFirst: false),
        const SizedBox(height: 5),
      ],
    );
  }
}

class StingrayLeaderboardListTile extends StatefulWidget {
  const StingrayLeaderboardListTile({
    super.key,
    required this.stats,
    required this.stingray,
    required this.index,
  });

  final Stingray? stingray;
  final StingrayStats? stats;
  final int index;

  @override
  State<StingrayLeaderboardListTile> createState() =>
      _StingrayLeaderboardListTileState();
}

class _StingrayLeaderboardListTileState
    extends State<StingrayLeaderboardListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      ),
      //make the child a row, that first shows the index, then the profile pic,then the stingray name, then the score
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Text(
                  (widget.index + 1).toString(),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<VoteBloc>(context)
                        .add(LoadUserFromFirestore(widget.stingray!.id));
                    Navigator.pushNamed(context, VoteScreen.routeName);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.5),
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.stingray!.imageUrls[0],
                        fit: BoxFit.cover,
                        memCacheHeight: 100,
                        memCacheWidth: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '${widget.stingray!.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FaIcon(
                  FontAwesomeIcons.arrowUp,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.stats!.likes}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 20),
                FaIcon(
                  FontAwesomeIcons.arrowDown,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.stats!.dislikes}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.stats!.totalScore}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
