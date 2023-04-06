import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/repository/firestore_repository.dart';

import '../../../../../models/user_model.dart';
import '../../../../../models/posts/wave_model.dart';
import 'waves_replies_screen.dart';
import 'widget/wave_tile.dart';

class GetRepliesWidget extends StatefulWidget {
  final WaveTile waveTile;
  final List<WaveTile> waveTileList;
  const GetRepliesWidget({
    required this.waveTile,
    required this.waveTileList,
    Key? key,
  }) : super(key: key);

  @override
  State<GetRepliesWidget> createState() => _GetRepliesWidgetState();
}

class _GetRepliesWidgetState extends State<GetRepliesWidget> {
  bool _gettingWaves = false;
  List<Wave?> _waves = [];
  List<User?> _users = [];

  @override
  void initState() {
    _users.add(
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_waves.isEmpty)
        ? InkWell(
            onTap: () async {
              await _getReplies();
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 23),
                    child: Icon(
                      Icons.more_vert,
                      size: 25,
                      color: ExtraColors.waveDividerColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Show replies',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: (_gettingWaves)
                              ? Theme.of(context).colorScheme.primary
                              : ExtraColors.highlightColor),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _waves.length,
            itemBuilder: (context, index) {
              User _user = _users
                  .where((element) => element!.id == _waves[index]!.senderId)
                  .first!;
              WaveTile _waveTile = WaveTile(
                wave: _waves[index]!,
                poster: _user,
                showDivider: (index == _waves.length - 1 ? true : false),
                extendBelow: (index == _waves.length - 1 ? false : true),
              );
              List<WaveTile> _newWaveTiles = widget.waveTileList + [_waveTile];
              return InkWell(
                  onTap: () {
                    User user = (BlocProvider.of<ProfileBloc>(context).state
                            as ProfileLoaded)
                        .user;
                    BlocProvider.of<TrollingPoliceCubit>(context)
                        .upDateTrolling(_waveTile.wave.id, context, user);
                    Navigator.of(context).pushNamed(
                      WaveRepliesScreen.routeName,
                      arguments: {
                        'waveTileList': _newWaveTiles,
                        'isThread': false,
                      },
                    );
                  },
                  child: _waveTile);
            });
  }

  Future<void> _getReplies() async {
    setState(() {
      _gettingWaves = true;
    });

    List<Wave?> _methodWaves = await getChainedReplies(widget.waveTile.wave);

    List<User?> _methodUsers = await getMethodUsers(_methodWaves);

    //remove any _methodWave that has a senderId not found in _methodUsers
    for (int i = 0; i < _methodWaves.length; i++) {
      if (_methodUsers
          .where((element) => element!.id == _methodWaves[i]!.senderId)
          .isEmpty) {
        _methodWaves.removeAt(i);
      }
    }

    setState(() {
      _waves = _methodWaves;
      _users = _methodUsers;
      _gettingWaves = false;
    });
  }

  Future<List<Wave?>> getChainedReplies(Wave chainWave) async {
    List<Wave?> waves = [];

    //write a for loop that can loop up to 10 times. First, runFirestoreRepository.getChainedWave to get the next chained wave. If it comes back null, break the loop. If it comes back a wave, add it to the list of waves. Then, set the wave to the next chained wave. Then, run the loop again.
    for (int i = 0; i < 10; i++) {
      Wave? nextWave = await FirestoreRepository().getChainedWave(chainWave);
      if (nextWave == null) {
        break;
      } else {
        waves.add(nextWave);
        chainWave = nextWave;
      }
    }
    return waves;
  }

  Future<List<User?>> getMethodUsers(List<Wave?> waves) async {
    if (waves.every((wave) => wave!.type == Wave.yip_yap_type)) {
      //Make a list of users. for every wave, add a user of User.anon(wave.posterid)
      List<User> _anonUsers = waves.map((e) => User.anon(e!.senderId)).toList();
      return _anonUsers;
    } else {
      User me =
          (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
      List<String> _userIds;

      _userIds = waves.map<String>((e) => e!.senderId).toList();

      _userIds.remove(
        me.blockedUsers,
      );

      _userIds.remove(
        me.blockedBy,
      );

      List<User?> users = [me];

      for (int i = 0; i < _userIds.length; i++) {
        User? user = await FirestoreRepository().getFutureUser(_userIds[i]);
        users.add(user);
      }

      return users;
    }
  }
}
