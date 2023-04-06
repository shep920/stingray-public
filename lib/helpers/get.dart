import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingray_leaderboard_bloc/stingray_leaderboard_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';

class Get{
  static User blocUser(BuildContext context) {
    return (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
  }

  static StingrayLeaderboardState stingrayLeaderState(BuildContext context) {
    return BlocProvider.of<StingrayLeaderboardBloc>(context).state;
  }

  static List<Stingray> stingrays(BuildContext context) {
    List<Stingray?> _stingrays= (BlocProvider.of<StingrayBloc>(context).state as StingrayLoaded).stingrays;
    List<Stingray> stingrays = [];
    for (Stingray? stingray in _stingrays) {
      if (stingray != null) {
        stingrays.add(stingray);
      }
    }
    return stingrays;
  }

  
}