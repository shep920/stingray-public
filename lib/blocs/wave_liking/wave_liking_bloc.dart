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

part 'wave_liking_event.dart';
part 'wave_liking_state.dart';

class WaveLikingBloc extends Bloc<WaveLikingEvent, WaveLikingState> {
  final FirestoreRepository _firestoreRepository;

  WaveLikingBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(WaveLikingLoaded(
            likes: [],
            dislikes: [],
            timer: null,
            userId: null,
            shortTermDislikes: [],
            shortTermLikes: [],
            likedArgs: [],
            dislikedArgs: [])) {
    on<LikeWave>(_likeWave);
    on<DislikeWave>(_dislikeWave);
    on<UpdateWaveLikes>(_updateWaveLikes);
    on<DeleteShortTermMemory>(_deleteShortTermMemory);
  }

  Future<void> _likeWave(
    LikeWave event,
    Emitter<WaveLikingState> emit,
  ) async {
    final state = this.state as WaveLikingLoaded;
    List<String> likes = state.likes;
    List<String> dislikes = state.dislikes;
    Timer? timer = state.timer;
    String? userId = state.userId;
    List<LikeArg> likedArgs = state.likedArgs;

    if (dislikes.contains(event.waveId)) {
      dislikes.remove(event.waveId);
    } else {
      likes.add(event.waveId);
      likedArgs.add(LikeArg(
        waveId: event.waveId,
        poster: event.poster,
      ));
    }

    if (timer == null) {
      timer = Timer(Duration(seconds: 3), () {
        add(UpdateWaveLikes());
      });
    }

    if (userId == null) {
      userId = event.userId;
    }

    emit(WaveLikingLoaded(
        likes: likes,
        dislikes: state.dislikes,
        timer: timer,
        userId: userId,
        shortTermLikes: state.shortTermLikes,
        shortTermDislikes: state.shortTermDislikes,
        likedArgs: likedArgs,
        dislikedArgs: state.dislikedArgs));
  }

  Future<void> _dislikeWave(
    DislikeWave event,
    Emitter<WaveLikingState> emit,
  ) async {
    final state = this.state as WaveLikingLoaded;
    List<String> dislikes = state.dislikes;
    List<String> likes = state.likes;
    Timer? timer = state.timer;
    String? userId = state.userId;
    List<LikeArg> dislikedArgs = state.dislikedArgs;

    if (likes.contains(event.waveId)) {
      likes.remove(event.waveId);
    } else {
      if (!dislikes.contains(event.waveId)) {
        dislikes.add(event.waveId);
        dislikedArgs.add(LikeArg(
          waveId: event.waveId,
          poster: event.poster,
        ));
      }
    }

    if (timer == null) {
      timer = Timer(Duration(minutes: 1), () {
        add(UpdateWaveLikes());
      });
    }

    if (userId == null) {
      userId = event.userId;
    }

    emit(WaveLikingLoaded(
        likes: state.likes,
        dislikes: dislikes,
        timer: timer,
        userId: userId,
        shortTermLikes: state.shortTermLikes,
        shortTermDislikes: state.shortTermDislikes,
        likedArgs: state.likedArgs,
        dislikedArgs: dislikedArgs));
  }

  Future<void> _updateWaveLikes(
    UpdateWaveLikes event,
    Emitter<WaveLikingState> emit,
  ) async {
    final state = this.state as WaveLikingLoaded;
    List<String> likes = state.likes;
    List<String> dislikes = state.dislikes;
    List<String> shortTermLikes = state.shortTermLikes;
    List<String> shortTermDislikes = state.shortTermDislikes;
    List<LikeArg> likedArgs = state.likedArgs;
    List<LikeArg> dislikedArgs = state.dislikedArgs;

    if (likes.isNotEmpty) {
      likes.forEach((waveId) async {
        await _firestoreRepository.updateWaveLikes(waveId, state.userId!);
        await _firestoreRepository.updateWaveLikeListener(waveId);
        User _poster =
            likedArgs.firstWhere((element) => element.waveId == waveId).poster;
        if (_poster.isStingray) {
          await _firestoreRepository.likeStingrayStats(stingrayId: _poster.id!);
        }
      });
    }

    if (dislikes.isNotEmpty) {
      dislikes.forEach((waveId) async {
        await _firestoreRepository.updateWaveDislikes(waveId, state.userId!);
        User _poster = dislikedArgs
            .firstWhere((element) => element.waveId == waveId)
            .poster;
        if (_poster.isStingray) {
          await _firestoreRepository.dislikeStingrayStats(
              stingrayId: _poster.id!);
        }
      });
    }

    shortTermDislikes.forEach((dislikeWaveId) {
      if (shortTermDislikes.contains(dislikeWaveId)) {
        shortTermDislikes.remove(dislikeWaveId);
        dislikes.remove(dislikeWaveId);
      }
    });

    shortTermLikes.addAll(likes);

    //if short term likes contains a waveId that is in the dislikes list, remove it from the dislikes list else add it to the short term dislikes list
    shortTermLikes.forEach((likeWaveId) {
      if (shortTermDislikes.contains(likeWaveId)) {
        shortTermLikes.remove(likeWaveId);
        dislikes.remove(likeWaveId);
      }
    });

    shortTermDislikes.addAll(dislikes);

    emit(WaveLikingLoaded(
        likes: [],
        dislikes: [],
        timer: null,
        userId: null,
        shortTermDislikes: shortTermDislikes,
        shortTermLikes: shortTermLikes,
        likedArgs: [],
        dislikedArgs: []));
  }

  void _deleteShortTermMemory(
    DeleteShortTermMemory event,
    Emitter<WaveLikingState> emit,
  ) {
    final state = this.state as WaveLikingLoaded;

    emit(WaveLikingLoaded(
        likes: state.likes,
        dislikes: state.dislikes,
        timer: state.timer,
        userId: state.userId,
        shortTermDislikes: [],
        shortTermLikes: [],
        likedArgs: state.likedArgs,
        dislikedArgs: state.dislikedArgs));
  }

  @override
  Future<void> close() async {
    super.close();
    print('WaveLikingBloc disposed');
  }
}
