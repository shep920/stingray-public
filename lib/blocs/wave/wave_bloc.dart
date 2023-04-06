import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/models.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_notifications/user_notification_model.dart';
import '../../models/user_notifications/user_notification_type.dart';
import '../../models/waves_meta_model.dart';
import '../../models/posts/wave_model.dart';
import '../../repository/storage_repository.dart';
import '../wave_replies/wave_replies_bloc.dart';

part 'wave_event.dart';
part 'wave_state.dart';

class WaveBloc extends Bloc<WaveEvent, WaveState> {
  final FirestoreRepository _firestoreRepository;
  final StorageRepository _storageRepository;
  final TypesenseRepository _typesenseRepository;
  final StingrayBloc _stingrayBloc;

  WaveBloc({
    required FirestoreRepository firestoreRepository,
    required StorageRepository storageRepository,
    required TypesenseRepository typesenseRepository,
    required StingrayBloc stingrayBloc,
  })  : _firestoreRepository = firestoreRepository,
        _storageRepository = storageRepository,
        _typesenseRepository = typesenseRepository,
        _stingrayBloc = stingrayBloc,
        super(WaveLoading()) {
    on<UpdateWave>(_onUpdateWave);
    on<LoadWave>(_onLoadWaves);
    on<CreateWave>(_createWave);
    on<CreateWaveThread>(_createWaveThread);

    on<CloseWave>(_closeWave);
    on<RefreshStingrayWaves>(_refreshStingrayWaves);
    on<PaginateWaves>(_paginateWaves);
    on<UpdateLoadingStatus>(_updateLoadingStatus);
    on<ReportWave>(_reportWave);
    on<DeleteWave>(_deleteWave);

    on<UpdateSortParam>(_updateSortParam);
  }

  Future<void> _onLoadWaves(
    LoadWave event,
    Emitter<WaveState> emit,
  ) async {
    List<WavesMeta> wavesMeta = [];
    bool hasMore = true;
    DocumentSnapshot? _lastDocument;

    WavesMeta _featuredWavesMeta;

    for (var stingray in event.stingrays) {
      hasMore = true;
      final query =
          await _firestoreRepository.getWavesByStingray(stingray!, null);

      if (query.docs.isNotEmpty) {
        _lastDocument = query.docs.last;
      }

      if (query.docs.length < 1) {
        hasMore = false;
      }

      List<Wave?> waves = Wave.waveListFromQuerySnapshot(query);

      wavesMeta.add(WavesMeta(
          stingray: stingray,
          waves: waves,
          hasMore: hasMore,
          lastDoc: _lastDocument));
    }

    List<Wave?> featuredWaves = await _typesenseRepository.getFeaturedWaves(
        waves: [], stingrays: event.stingrays, sortType: TsKeywords.newParam);

    _featuredWavesMeta = WavesMeta(
        stingray: Stingray.featuredStingray(),
        waves: featuredWaves,
        hasMore: (featuredWaves.length < 15) ? false : true,
        lastDoc: null);

    List<Wave?> hotFeaturedWaves = await _typesenseRepository.getFeaturedWaves(
        waves: [], stingrays: event.stingrays, sortType: TsKeywords.hotParam);

    WavesMeta _hotfeaturedWavesMeta = WavesMeta(
        stingray: Stingray.featuredStingray(),
        waves: hotFeaturedWaves,
        hasMore: (hotFeaturedWaves.length < 15) ? false : true,
        lastDoc: null);

    //add a timer that is not active
    final timer = Timer(Duration(seconds: 0), () {});

    add(UpdateWave(
        waveMeta: wavesMeta,
        timer: timer,
        featuredWavesMeta: _featuredWavesMeta,
        hotfeaturedWavesMeta: _hotfeaturedWavesMeta,
        featureSortParam: TsKeywords.newParam));
  }

  void _onUpdateWave(
    UpdateWave event,
    Emitter<WaveState> emit,
  ) {
    bool hasMore = true;
    List<WavesMeta> wavesMeta = event.waveMeta;
    (wavesMeta.length < 5) ? hasMore = false : hasMore = true;

    //set an inactive timer
    Timer? timer = Timer(Duration(microseconds: 1), () {});

    emit(WaveLoading());

    emit(WaveLoaded(
        featuredWavesMeta: event.featuredWavesMeta,
        featureSortParam: event.featureSortParam,
        hotfeaturedWavesMeta: event.hotfeaturedWavesMeta,
        wavesMeta: wavesMeta,
        timer: timer,
        isLoading: false,
        hasMore: hasMore));
  }

  Future<void> _createWave(
    CreateWave event,
    Emitter<WaveState> emit,
  ) async {
    String id = Uuid().v4();
    bool _isImage = false;
    String imageurl = '';
    List<dynamic> bubbleImageUrls = [];
    if (event.file != null) {
      await _storageRepository.uploadWaveImage(
        event.file!,
        id,
      );
      imageurl = await _storageRepository.getWaveImageUrl(
        event.file!,
        id,
      );
    }

    //if the file ends in .mp4, set _isImage to false
    if (event.file != null) {
      if (event.file!.path.endsWith('.mp4')) {
        _isImage = false;
      } else {
        _isImage = true;
      }
    }

    if (event.style != null) {
      List<File> bubbles = event.bubbleImages!;
      for (File bubble in bubbles) {
        await _storageRepository.uploadWaveImage(
          bubble,
          id,
        );
        String bubbleUrl = await _storageRepository.getWaveImageUrl(
          bubble,
          id,
        );
        bubbleImageUrls.add(bubbleUrl);
      }
    }

    final Wave wave = Wave.genericWave(
      senderId: event.sender.id!,
      imageUrl: //if event.file is null, then imageurl is null. Else it is the url of the image
          event.file == null
              ? null
              : (_isImage)
                  ? imageurl
                  : null,
      message: event.message,
      comments: 0,
      replyTo: null,
      threadId: null,
      replyToHandles: null,
      videoUrl: event.file == null
          ? null
          : (!_isImage)
              ? imageurl
              : null,
      style: (event.style == null) ? null : event.style,
      bubbleImageUrls: bubbleImageUrls,
    );

    await mentionHandler(
        event.sender, event.message, wave, _firestoreRepository);

    await _firestoreRepository.uploadWave(wave);
  }

  //create a wave thread
  Future<void> _createWaveThread(
    CreateWaveThread event,
    Emitter<WaveState> emit,
  ) async {
    List<String> messages = event.messages;
    List<Wave> waves = [];
    for (int i = 0; i < messages.length; i++) {
      if (messages[i] == '' && event.files[i] == null) {
        messages.removeAt(i);
        event.files.removeAt(i);
      }
    }

    String? threadId = (messages.length > 1) ? Uuid().v4() : null;
    for (int i = 0; i < messages.length; i++) {
      bool _isImage = false;
      String id = Uuid().v4();

      String? imageurl;
      if (event.files[i] != null) {
        await _storageRepository.uploadWaveImage(
          event.files[i]!,
          id,
        );
        imageurl = await _storageRepository.getWaveImageUrl(
          event.files[i]!,
          id,
        );
      }

      //if the file ends in .mp4, set _isImage to false
      if (event.files[i] != null) {
        if (event.files[i]!.path.endsWith('.mp4')) {
          _isImage = false;
        } else {
          _isImage = true;
        }
      }

      final Wave wave = Wave.genericWave(
        senderId: event.sender.id!,
        message: messages[i],
        imageUrl: (_isImage) ? imageurl : null,
        threadId: threadId,
        replyTo: i == 0 ? null : waves[i - 1].id,
        replyToHandles: i == 0 ? null : [event.sender.handle],
        comments: (i == messages.length - 1) ? 0 : 1,
        type: event.waveType,
        videoUrl: (!_isImage) ? imageurl : null,
      );

      waves.add(wave);

      await mentionHandler(
          event.sender, messages[i], wave, _firestoreRepository);

      await _firestoreRepository.uploadWave(wave);
    }
  }

  Future<void> _refreshStingrayWaves(
    RefreshStingrayWaves event,
    Emitter<WaveState> emit,
  ) async {
    //set a timer for a minute that becomes null when the minute is up
    Timer? timer;
    DocumentSnapshot? _lastDocument;
    timer = Timer(Duration(seconds: 10), () {
      timer = null;
    });

    bool hasMore = true;

    final state = this.state as WaveLoaded;

    WavesMeta _featuredWavesMeta = state.featuredWavesMeta;
    WavesMeta _hotfeaturedWavesMeta = state.hotfeaturedWavesMeta;
    //check if the timer is null

    List<WavesMeta> wavesMeta = state.wavesMeta;

    final stingray = event.stingray;

    if (stingray.id != 'featured') {
      final query =
          await _firestoreRepository.getWavesByStingray(stingray, null);

      if (query.docs.isNotEmpty) {
        _lastDocument = query.docs.last;
      }

      if (query.docs.length < 5) {
        hasMore = false;
      }

      List<Wave?> waves = Wave.waveListFromQuerySnapshot(query);

      WavesMeta newWavesMeta = WavesMeta(
          stingray: stingray,
          waves: waves,
          hasMore: hasMore,
          lastDoc: _lastDocument);

      //replace the waves in NewWaves with the waves in waves where the event.stingray.id is the same as the stingray.id in waves
      for (int j = 0; j < wavesMeta.length; j++) {
        if (newWavesMeta.stingray.id == wavesMeta[j].stingray.id) {
          wavesMeta[j] = newWavesMeta;
        }
      }
    } else {
      if (state.featureSortParam == TsKeywords.hotParam) {
        _hotfeaturedWavesMeta = WavesMeta(
            stingray: Stingray.featuredStingray(),
            waves: [],
            hasMore: true,
            lastDoc: null);
      } else {
        List<Stingray?> _stingrays =
            (_stingrayBloc.state as StingrayLoaded).stingrays;
        List<Wave?> featuredWaves = await _typesenseRepository.getFeaturedWaves(
            waves: [], stingrays: _stingrays, sortType: TsKeywords.newParam);

        _featuredWavesMeta = WavesMeta(
            stingray: Stingray.featuredStingray(),
            waves: featuredWaves,
            hasMore: (featuredWaves.length < 15) ? false : true,
            lastDoc: null);
      }
    }

    //add updateWave event to the bloc
    add(UpdateWave(
        waveMeta: wavesMeta,
        timer: timer,
        featuredWavesMeta: _featuredWavesMeta,
        hotfeaturedWavesMeta: _hotfeaturedWavesMeta,
        featureSortParam: state.featureSortParam));
  }

  Future<void> _paginateWaves(
    PaginateWaves event,
    Emitter<WaveState> emit,
  ) async {
    final state = this.state as WaveLoaded;
    //check if the timer is null

    final stingray = event.stingray;
    List<WavesMeta> waveMeta = state.wavesMeta;
    WavesMeta _featuredWavesMeta = state.featuredWavesMeta;
    WavesMeta _hotfeaturedWavesMeta = state.hotfeaturedWavesMeta;
    if (stingray.id != 'featured') {
      DocumentSnapshot? _lastDocument = state.wavesMeta
          .firstWhere((stingray) => stingray.stingray.id == event.stingray.id)
          .lastDoc;
      bool hasMore = true;

      final query = await _firestoreRepository.getWavesByStingray(
          stingray, _lastDocument);

      if (query.docs.isNotEmpty) {
        _lastDocument = query.docs.last;
      }

      if (query.docs.length < 5) {
        hasMore = false;
      }

      List<Wave?> waves = Wave.waveListFromQuerySnapshot(query);

      WavesMeta newWavesMeta =
          WavesMeta(stingray: stingray, waves: waves, hasMore: hasMore);

      //replace the waves in NewWaves with the waves in waves where the event.stingray.id is the same as the stingray.id in waves
      for (int j = 0; j < waveMeta.length; j++) {
        if (newWavesMeta.stingray.id == waveMeta[j].stingray.id) {
          List<Wave?> waves = waveMeta[j].waves;
          waves.addAll(newWavesMeta.waves);

          final WavesMeta paginatedMeta = WavesMeta(
            stingray: waveMeta[j].stingray,
            waves: waves,
            hasMore: hasMore,
            lastDoc: _lastDocument,
          );

          waveMeta[j] = paginatedMeta;
        }
      }
    } else {
      if (state.featureSortParam == TsKeywords.hotParam) {
        List<Stingray?> _stingrays =
            (_stingrayBloc.state as StingrayLoaded).stingrays;
        List<Wave?> featuredWaves = await _typesenseRepository.getFeaturedWaves(
            waves: _hotfeaturedWavesMeta.waves,
            stingrays: _stingrays,
            sortType: TsKeywords.hotParam);

        List<Wave?> _newWaves = _hotfeaturedWavesMeta.waves;
        _newWaves.addAll(featuredWaves);

        _hotfeaturedWavesMeta = WavesMeta(
            stingray: Stingray.featuredStingray(),
            waves: _newWaves,
            hasMore: (featuredWaves.length < 15) ? false : true,
            lastDoc: null);
      } else {
        List<Stingray?> _stingrays =
            (_stingrayBloc.state as StingrayLoaded).stingrays;
        List<Wave?> featuredWaves = await _typesenseRepository.getFeaturedWaves(
            waves: _featuredWavesMeta.waves,
            stingrays: _stingrays,
            sortType: TsKeywords.newParam);

        List<Wave?> _newWaves = _featuredWavesMeta.waves;
        _newWaves.addAll(featuredWaves);

        _featuredWavesMeta = WavesMeta(
            stingray: Stingray.featuredStingray(),
            waves: _newWaves,
            hasMore: (featuredWaves.length < 15) ? false : true,
            lastDoc: null);
      }
    }

    //add updateWave event to the bloc
    add(UpdateWave(
        waveMeta: waveMeta,
        timer: state.timer,
        featuredWavesMeta: _featuredWavesMeta,
        hotfeaturedWavesMeta: _hotfeaturedWavesMeta,
        featureSortParam: state.featureSortParam));
  }

  void _closeWave(
    CloseWave event,
    Emitter<WaveState> emit,
  ) {
    print('WaveBloc disposed');

    emit(WaveLoading());
  }

  void _updateLoadingStatus(
    UpdateLoadingStatus event,
    Emitter<WaveState> emit,
  ) {
    final state = this.state as WaveLoaded;
    emit(WaveLoaded(
      featuredWavesMeta: state.featuredWavesMeta,
      wavesMeta: state.wavesMeta,
      timer: state.timer,
      isLoading: true,
      hasMore: state.hasMore,
      featureSortParam: state.featureSortParam,
      hotfeaturedWavesMeta: state.hotfeaturedWavesMeta,
    ));
  }

  Future<void> _reportWave(
    ReportWave event,
    Emitter<WaveState> emit,
  ) async {
    final state = this.state as WaveLoaded;
    List<WavesMeta> wavesMeta = state.wavesMeta;

    Report report = Report(
      reporterUser: event.reporter,
      type: 'wave',
      reason: '',
      reportTime: DateTime.now(),
      reportId: Uuid().v4(),
      wave: event.wave,
      reportedUser: event.reported,
    );

    await _firestoreRepository.sendReportNonstatic(report);
  }

  Future<void> _deleteWave(
    DeleteWave event,
    Emitter<WaveState> emit,
  ) async {
    final state = this.state as WaveLoaded;
    List<WavesMeta> wavesMeta = state.wavesMeta;

    await _firestoreRepository.deleteWave(event.wave);
    if (event.wave.replyTo != 'null') {
      await _firestoreRepository.decrementWaveReplies(event.wave.replyTo!);
    }

    //if the wave is in the wavesMeta, remove it
    for (int i = 0; i < wavesMeta.length; i++) {
      for (int j = 0; j < wavesMeta[i].waves.length; j++) {
        if (wavesMeta[i].waves[j]!.id == event.wave.id) {
          wavesMeta[i].waves.removeAt(j);
        }
      }
    }
    //emit waveloading
    emit(WaveLoading());
    //emit a copyWith of the state
    emit(state.copyWith(wavesMeta: wavesMeta));
  }

  //_updateSortParam
  Future<void> _updateSortParam(
    UpdateSortParam event,
    Emitter<WaveState> emit,
  ) async {
    final state = this.state as WaveLoaded;
    WavesMeta _featuredWavesMeta = state.featuredWavesMeta;
    WavesMeta _hotfeaturedWavesMeta = state.hotfeaturedWavesMeta;

    if (event.sortParam == TsKeywords.hotParam) {
      emit(WaveLoading());
      emit(state.copyWith(
        featureSortParam: event.sortParam,
      ));
    } else {
      emit(WaveLoading());
      emit(state.copyWith(
        featureSortParam: event.sortParam,
      ));
    }

    //emit a copyWith of the state
  }

  @override
  Future<void> close() async {
    super.close();
    print('WaveBloc disposed');
  }
}

Future<void> mentionHandler(User sender, String message, Wave wave,
    FirestoreRepository _firestoreRepository) async {
  if (message.contains('@')) {
    String subString = message.substring(message.indexOf('@'));
    String handle = subString.contains(' ')
        ? subString.substring(1, subString.indexOf(' '))
        : subString.substring(1);
    handle = '@' + handle;
    if (handle != sender.handle) {
      User? user = await _firestoreRepository.getUserFromHandle(handle);

      if (user != null) {
        UserNotification mentionNotification =
            UserNotification.genericUserNotification(
                type: UserNotificationType.mention,
                relevantUserHandle: (wave.type == Wave.yip_yap_type)
                    ? 'A minnow'
                    : sender.handle,
                relevantWaveId: wave.id,
                message: wave.message,
                imageUrl: (wave.type == Wave.yip_yap_type)
                    ? null
                    : sender.imageUrls[0],
                trailingImageUrl: wave.imageUrl);
        await _firestoreRepository.updateMentionListener(
            wave, user.id!, sender);
        await _firestoreRepository.updateUserNonStaticNotification(
            user.id!, mentionNotification);
        if (!user.newNotifications) {
          await _firestoreRepository.setNewNotifications(user.id!, true);
        }
      }
    }
  }
}
