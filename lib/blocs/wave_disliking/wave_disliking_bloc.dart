import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/models/arguements/like_arg.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../models/message_model.dart';
import '../../models/stingray_model.dart';
import '../../models/user_model.dart';

part 'wave_disliking_event.dart';
part 'wave_disliking_state.dart';

class WaveDislikingBloc extends Bloc<WaveDislikingEvent, WaveDislikingState> {
  final FirestoreRepository _firestoreRepository;

  WaveDislikingBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(WaveDislikingLoaded(
          removedDislikes: [],
          timer: null,
          userId: null,
          shortTermRemovedDislikes: [],
          dislikes: [],
          shortTermDislikes: [],
          dislikedArgs: [],
          removedDislikedArgs: [],
        )) {
    on<DislikeWave>(_dislikeWave);
    on<RemoveDislikeWave>(_removeDislikeWave);
    on<UpdateWaveDislikes>(_updateWaveDislikes);
    on<DeleteShortTermMemory>(_deleteShortTermMemory);
  }

  Future<void> _dislikeWave(
    DislikeWave event,
    Emitter<WaveDislikingState> emit,
  ) async {
    final state = this.state as WaveDislikingLoaded;
    List<String> dislikes = state.dislikes;
    List<String> removedDislikes = state.removedDislikes;
    Timer? timer = state.timer;
    String? userId = state.userId;
    List<LikeArg> dislikedArgs = state.dislikedArgs;

    if (removedDislikes.contains(event.waveId)) {
      removedDislikes.remove(event.waveId);
    } else {
      dislikes.add(event.waveId);
      dislikedArgs.add(LikeArg(
        poster: event.poster,
        waveId: event.waveId,
      ));
    }

    timer ??= Timer(const Duration(seconds: 3), () {
      add(UpdateWaveDislikes());
    });

    userId ??= event.userId;

    emit(WaveDislikingLoaded(
        dislikes: dislikes,
        removedDislikes: state.removedDislikes,
        timer: timer,
        userId: userId,
        shortTermDislikes: state.shortTermDislikes,
        shortTermRemovedDislikes: state.shortTermRemovedDislikes,
        dislikedArgs: dislikedArgs,
        removedDislikedArgs: state.removedDislikedArgs));
  }

  Future<void> _removeDislikeWave(
    RemoveDislikeWave event,
    Emitter<WaveDislikingState> emit,
  ) async {
    final state = this.state as WaveDislikingLoaded;
    List<String> removedDislikes = state.removedDislikes;
    List<String> dislikes = state.dislikes;
    Timer? timer = state.timer;
    String? userId = state.userId;
    List<LikeArg> removedDislikedArgs = state.removedDislikedArgs;

    if (dislikes.contains(event.waveId)) {
      dislikes.remove(event.waveId);
    } else {
      if (!removedDislikes.contains(event.waveId)) {
        removedDislikes.add(event.waveId);
        removedDislikedArgs.add(LikeArg(
          poster: event.poster,
          waveId: event.waveId,
        ));
      }
    }

    timer ??= Timer(Duration(minutes: 1), () {
      add(UpdateWaveDislikes());
    });

    userId ??= event.userId;

    emit(WaveDislikingLoaded(
        dislikes: state.dislikes,
        removedDislikes: removedDislikes,
        timer: timer,
        userId: userId,
        shortTermDislikes: state.shortTermDislikes,
        shortTermRemovedDislikes: state.shortTermRemovedDislikes,
        dislikedArgs: state.dislikedArgs,
        removedDislikedArgs: removedDislikedArgs));
  }

  Future<void> _updateWaveDislikes(
    UpdateWaveDislikes event,
    Emitter<WaveDislikingState> emit,
  ) async {
    final state = this.state as WaveDislikingLoaded;
    List<String> dislikes = state.dislikes;
    List<String> removedDislikes = state.removedDislikes;
    List<String> shortTermDislikes = state.shortTermDislikes;
    List<String> shortTermRemovedDislikes = state.shortTermRemovedDislikes;
    List<LikeArg> dislikedArgs = state.dislikedArgs;
    List<LikeArg> removedDislikedArgs = state.removedDislikedArgs;

    if (dislikes.isNotEmpty) {
      dislikes.forEach((waveId) async {
        _firestoreRepository.dislikeWave(waveId, state.userId!);
        User _poster =
            dislikedArgs.firstWhere((arg) => arg.waveId == waveId).poster;
        if (_poster.isStingray) {
          _firestoreRepository.dislikeStingrayStats(stingrayId: _poster.id!);
        }
      });
    }

    if (removedDislikes.isNotEmpty) {
      removedDislikes.forEach((waveId) async {
        await _firestoreRepository.removeWaveDislike(waveId, state.userId!);
        User _poster = removedDislikedArgs
            .firstWhere((arg) => arg.waveId == waveId)
            .poster;
        if (_poster.isStingray) {
          _firestoreRepository.likeStingrayStats(stingrayId: _poster.id!);
        }
      });
    }

    shortTermRemovedDislikes.forEach((dislikeWaveId) {
      if (shortTermRemovedDislikes.contains(dislikeWaveId)) {
        shortTermRemovedDislikes.remove(dislikeWaveId);
        removedDislikes.remove(dislikeWaveId);
      }
    });

    shortTermDislikes.addAll(dislikes);

    //if short term dislikes contains a waveId that is in the removedDislikes list, remove it from the removedDislikes list else add it to the short term removedDislikes list
    shortTermDislikes.forEach((likeWaveId) {
      if (shortTermRemovedDislikes.contains(likeWaveId)) {
        shortTermDislikes.remove(likeWaveId);
        removedDislikes.remove(likeWaveId);
      }
    });

    shortTermRemovedDislikes.addAll(removedDislikes);

    emit(WaveDislikingLoaded(
        dislikes: [],
        removedDislikes: [],
        timer: null,
        userId: null,
        shortTermRemovedDislikes: shortTermRemovedDislikes,
        shortTermDislikes: shortTermDislikes,
        dislikedArgs: [],
        removedDislikedArgs: []));
  }

  void _deleteShortTermMemory(
    DeleteShortTermMemory event,
    Emitter<WaveDislikingState> emit,
  ) {
    final state = this.state as WaveDislikingLoaded;

    emit(WaveDislikingLoaded(
        dislikes: state.dislikes,
        removedDislikes: state.removedDislikes,
        timer: state.timer,
        userId: state.userId,
        shortTermRemovedDislikes: [],
        shortTermDislikes: [],
        dislikedArgs: state.dislikedArgs,
        removedDislikedArgs: state.removedDislikedArgs));
  }

  @override
  Future<void> close() async {
    super.close();
    print('WaveDislikingBloc disposed');
  }
}
