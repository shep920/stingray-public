import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';
import 'package:hero/models/user_notifications/user_notification_model.dart';
import 'package:hero/models/user_notifications/user_notification_type.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/views/generic_view.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../models/message_model.dart';
import '../../models/stingray_model.dart';
import '../../models/user_model.dart';
import '../../models/waves_meta_model.dart';
import '../../models/posts/wave_model.dart';
import '../../repository/storage_repository.dart';
import '../../screens/home/home_screens/views/waves/widget/wave_tile.dart';
import '../wave/wave_bloc.dart';

part 'wave_replies_event.dart';
part 'wave_replies_state.dart';

class WaveRepliesBloc extends Bloc<WaveRepliesEvent, WaveRepliesState> {
  final FirestoreRepository _firestoreRepository;
  final StorageRepository _storageRepository;

  WaveRepliesBloc({
    required FirestoreRepository firestoreRepository,
    required StorageRepository storageRepository,
  })  : _firestoreRepository = firestoreRepository,
        _storageRepository = storageRepository,
        super(WaveRepliesLoading()) {
    // on<UpdateWaveReplies>(_onUpdateWaveReplies);

    on<CreateWaveReplies>(_createWaveReplies);
  }

  Future<void> _createWaveReplies(
    CreateWaveReplies event,
    Emitter<WaveRepliesState> emit,
  ) async {
    //if the image is not null, upload it to firebase storage
    String imageurl = '';
    bool _isImage;
    if (event.file != null) {
      await _storageRepository.uploadWaveImage(
        event.file!,
        event.wave.senderId,
      );
      imageurl = await _storageRepository.getWaveImageUrl(
        event.file!,
        event.wave.senderId,
      );
    }

    //check if it ends with .mp4
    _isImage =
        (event.file == null) ? false : (event.file!.path.endsWith(".mp4"));

    Wave _wave = event.wave.copyWith(
        imageUrl: (event.file == null)
            ? null
            : (_isImage)
                ? imageurl
                : null,
        videoUrl: (event.file == null)
            ? null
            : (!_isImage)
                ? imageurl
                : null);

    UserNotification notification = UserNotification.genericUserNotification(
        type: UserNotificationType.reply,
        relevantUserHandle: (_wave.type == Wave.default_type)
            ? event.sender.handle
            : "A minnow",
        relevantWaveId: _wave.replyTo,
        message: _wave.message,
        imageUrl: (_wave.type == Wave.default_type)
            ? event.sender.imageUrls[0]
            : null,
        trailingImageUrl: _wave.imageUrl);

    mentionHandler(event.sender, _wave.message, _wave, _firestoreRepository);

    await _firestoreRepository.uploadWave(_wave);
    if (event.sender.id != event.receiver.id) {
      await _firestoreRepository.updateWaveReplyListener(
          event.sender, _wave, event.receiver.id!);
      await _firestoreRepository.updateUserNonStaticNotification(
          event.receiver.id!, notification);
    }

    if (_wave.replyTo != null) {
      await _firestoreRepository.incrementWaveReplies(_wave.replyTo!);
    }
  }

  // Future<void> _refreshStingrayWaveRepliess(
  //   RefreshStingrayWaveRepliess event,
  //   Emitter<WaveRepliesState> emit,
  // ) async {
  //   //set a timer for a minute that becomes null when the minute is up
  //   Timer? timer;
  //   timer = Timer(Duration(seconds: 10), () {
  //     timer = null;
  //   });

  //   bool hasMore = true;

  //   final state = this.state as WaveRepliesLoaded;
  //   //check if the timer is null

  //   List<WaveRepliessMeta> waves = state.wavesMeta;

  //   WaveRepliessMeta newWaveRepliess = event.waves;
  //   if (newWaveRepliess.waves.length < 5) hasMore = false;

  //   //replace the waves in NewWaveRepliess with the waves in waves where the event.stingray.id is the same as the stingray.id in waves
  //   for (int j = 0; j < waves.length; j++) {
  //     if (newWaveRepliess.stingray.id == waves[j].stingray.id) {
  //       waves[j] = newWaveRepliess;
  //     }
  //   }

  //   //add updateWaveReplies event to the bloc
  //   add(UpdateWaveReplies(waveMeta: waves, timer: timer));
  // }

  // Future<void> _paginateWaveRepliess(
  //   PaginateWaveRepliess event,
  //   Emitter<WaveRepliesState> emit,
  // ) async {
  //   final state = this.state as WaveRepliesLoaded;
  //   //check if the timer is null

  //   List<WaveRepliessMeta> waveMeta = state.wavesMeta;

  //   WaveRepliessMeta newWaveRepliess = event.waves;

  //   //replace the waves in NewWaveRepliess with the waves in waves where the event.stingray.id is the same as the stingray.id in waves
  //   for (int j = 0; j < waveMeta.length; j++) {
  //     if (newWaveRepliess.stingray.id == waveMeta[j].stingray.id) {
  //       List<WaveReplies?> waves = waveMeta[j].waves;
  //       waves.addAll(newWaveRepliess.waves);

  //       final WaveRepliessMeta paginatedMeta = WaveRepliessMeta(
  //         stingray: waveMeta[j].stingray,
  //         waves: waves,
  //         hasMore: newWaveRepliess.hasMore,
  //       );

  //       waveMeta[j] = paginatedMeta;
  //     }
  //   }

  //   //add updateWaveReplies event to the bloc
  //   add(UpdateWaveReplies(waveMeta: waveMeta, timer: state.timer));
  // }

  // void _closeWaveReplies(
  //   CloseWaveReplies event,
  //   Emitter<WaveRepliesState> emit,
  // ) {
  //   print('WaveRepliesBloc disposed');

  //   emit(WaveRepliesLoading());
  // }

  // void _updateLoadingStatus(
  //   UpdateLoadingStatus event,
  //   Emitter<WaveRepliesState> emit,
  // ) {
  //   final state = this.state as WaveRepliesLoaded;
  //   emit(WaveRepliesLoaded(
  //     wavesMeta: state.wavesMeta,
  //     timer: state.timer,
  //     isLoading: true,
  //     hasMore: state.hasMore,
  //   ));
  // }

  @override
  Future<void> close() async {
    super.close();
    print('WaveRepliesBloc disposed');
  }
}
