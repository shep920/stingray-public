import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/waves_replies_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';

class GoTo{
  static void replies(WaveTile waveTile, BuildContext context) {
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

  
}