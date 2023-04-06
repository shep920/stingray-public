import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/banned/banned_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/trolling/troll_model.dart';
import '../../models/user_model.dart';
import '../../repository/storage_repository.dart';

part 'trolling_state.dart';

class TrollingPoliceCubit extends Cubit<TrollingPoliceState> {
  final FirestoreRepository _firestoreRepository;
  TrollingPoliceCubit({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(TrollingPoliceNormal(trolls: [], timer: null));

  void upDateTrolling(String waveId, BuildContext context, User user) {
    TrollingPoliceNormal state = this.state as TrollingPoliceNormal;
    List<Troll> trolls = state.trolls;
    if (
        //waveId is not in the list
        trolls.where((element) => element.waveId == waveId).isEmpty) {
      int _maxAllowed = 5 + Random().nextInt(5);
      trolls
          .add(Troll(waveId: waveId, timesViewed: 1, maxAllowed: _maxAllowed));
    }
    if (
        //waveId is in the list
        trolls.where((element) => element.waveId == waveId).isNotEmpty) {
      Troll _troll = trolls.where((element) => element.waveId == waveId).first;
      Troll _newTroll = _troll.copyWith(timesViewed: _troll.timesViewed + 1);

      if (_newTroll.timesViewed >= _newTroll.maxAllowed) {
        String _reason =
            'TooManyReads: It seems you tried to view the same wave too many times. We know you probably didn\'t mean to do this, but we have to protect our users from trolls and bots. Hmu on twitter or something if you think this is a mistake. Elsewise, just chill a little bit and try again later.';
        DateTime _expiration =
            //tommorow
            DateTime.now().add(Duration(days: 1));
        _firestoreRepository.ban(user, _reason, _expiration);
        Navigator.of(context).pushNamedAndRemoveUntil(
            BannedScreen.routeName, (Route<dynamic> route) => false);
      }

      trolls.remove(_troll);
      trolls.add(_newTroll);
    }

    Timer _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      resetTrolls();
    });

    emit(TrollingPoliceNormal(trolls: trolls, timer: _timer));
  }

  void resetTrolls() {
    emit(TrollingPoliceNormal(trolls: [], timer: null));
  }
}
