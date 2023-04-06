import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/helpers/shared_preferences/user_simple_preferences.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/static_data/report_stuff.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_model_with_index.dart';
import '../../models/like_with_index_model.dart';
import '../../models/models.dart';
import '../typesense/bloc/search_bloc.dart';

part 'stingray_event.dart';
part 'stingray_state.dart';

class StingrayBloc extends Bloc<StingrayEvent, StingrayState> {
  final FirestoreRepository _firestoreRepository;
  final StorageRepository _storeageRepository;
  StreamSubscription? _stingraySubscription;

  StingrayBloc({
    required FirestoreRepository databaseRepository,
    required StorageRepository storageRepository,
  })  : _firestoreRepository = databaseRepository,
        _storeageRepository = storageRepository,
        super(StingrayLoading()) {
    on<LoadStingray>(_onLoadStingray);
    on<UpdateStingray>(_onUpdateStingray);

    on<UpdateSelectedIndex>(_updateSelectedIndex);
    on<UpdateSelectedStingray>(_updateSelectedStingray);
    on<CloseStingray>(_closeStingray);
    on<UploadStory>(_uploadStory);
    on<ViewStory>(_viewStory);
    on<ReportStory>(_reportStory);
    on<DeleteStory>(_deleteStory);
  }

  void _onLoadStingray(
    LoadStingray event,
    Emitter<StingrayState> emit,
  ) {
    try {
      int _selectedIndex = -1;
      List<String?> sortedStingrayIds = [];
      List<Stingray?> sortedStingrays = [];
      _stingraySubscription = _firestoreRepository
          .stingrays(event.user.blockedUsers)
          .listen((stingrays) {
        if (state is StingrayLoading) {
          sortedStingrayIds = stingrays.map((e) => e!.id).toList();
          sortedStingrayIds.shuffle();

          sortStingraysByStory(stingrays, sortedStingrayIds);

          sortedStingrays = sortedStingrayIds
              .map((e) => stingrays.firstWhere((element) => element!.id == e))
              .toList();
        }
        if (state is StingrayLoaded) {
          _selectedIndex = (state as StingrayLoaded).selectedIndex;

          sortedStingrayIds = (state as StingrayLoaded).sortedStingrayIds;

          List<Stingray?> _oldStingrays = (state as StingrayLoaded).stingrays;

          deletedAddedCheck(stingrays, _oldStingrays, sortedStingrayIds);

          sortStingraysByStory(stingrays, sortedStingrayIds);

          sortedStingrays = sortedStingrayIds
              .map((e) => stingrays.firstWhere((element) => element!.id == e))
              .toList();
        }

        add(
          UpdateStingray(
            stingrays: sortedStingrays,
            sortOrder: event.sortOrder,
            selectedIndex: _selectedIndex,
            sortedStingrayIds: sortedStingrayIds,
          ),
        );
      });
    } catch (e) {
      print('the error is:');
      print(e);
    }
  }

  void sortStingraysByStory(
      List<Stingray?> stingrays, List<String?> sortedStingrayIds) {
    Map<String, List<Story>> _stories = {};

    for (Stingray? stingray in stingrays) {
      List<Story> _storiesForStingray = [];
      for (String? storyString in stingray!.stories) {
        Story story = Story.storyFromString(storyString!);
        _storiesForStingray.add(story);
      }

      _stories[stingray.id!] = _storiesForStingray;
    }

    List<String>? _seenStoryIds = UserSimplePreferences.getSeenStoryIds();
    if (_seenStoryIds == null) {
      UserSimplePreferences.setSeenStoryIds([]);
      _seenStoryIds = [];
    }

    //if there are any stories that have not been seen, set the relevant stingrayId to the front of sortedStingrayIds
    for (String? stingrayId in sortedStingrayIds) {
      List<Story> _storiesForStingray = _stories[stingrayId]!;
      for (Story story in _storiesForStingray) {
        if (!_seenStoryIds.contains(story.id)) {
          sortedStingrayIds.remove(stingrayId);
          sortedStingrayIds.insert(0, stingrayId);
          break;
        }
      }
    }
  }

  void deletedAddedCheck(List<Stingray?> stingrays,
      List<Stingray?> _oldStingrays, List<String?> sortedStingrayIds) {
    if (stingrays.length < _oldStingrays.length) {
      //a stingray has been deleted
      //find the stingray that has been deleted
      List<Stingray?> _deletedStingrays = [];
      for (Stingray? _oldStingray in _oldStingrays) {
        bool _found = false;
        for (Stingray? _newStingray in stingrays) {
          if (_oldStingray!.id == _newStingray!.id) {
            _found = true;
            break;
          }
        }
        if (!_found) {
          _deletedStingrays.add(_oldStingray);
        }
      }
      //remove the stingray that has been deleted from sortedStingrayIds
      for (Stingray? _deletedStingray in _deletedStingrays) {
        sortedStingrayIds.remove(_deletedStingray!.id);
      }
    } else if (stingrays.length > _oldStingrays.length) {
      List<Stingray?> _addedStingrays = [];
      for (Stingray? _newStingray in stingrays) {
        bool _found = false;
        for (Stingray? _oldStingray in _oldStingrays) {
          if (_newStingray!.id == _oldStingray!.id) {
            _found = true;
            break;
          }
        }
        if (!_found) {
          _addedStingrays.add(_newStingray);
        }
      }
      //add the stingray that has been added to sortedStingrayIds
      for (Stingray? _addedStingray in _addedStingrays) {
        sortedStingrayIds.add(_addedStingray!.id);
      }
    }
  }

  void _onUpdateStingray(
    UpdateStingray event,
    Emitter<StingrayState> emit,
  ) {
    Map<String, List<Story>> _stories = {};

    for (Stingray? stingray in event.stingrays) {
      List<Story> _storiesForStingray = [];
      for (String? storyString in stingray!.stories) {
        Story story = Story.storyFromString(storyString!);
        _storiesForStingray.add(story);
      }

      _stories[stingray.id!] = _storiesForStingray;
    }

    List<String>? _seenStoryIds = UserSimplePreferences.getSeenStoryIds();
    if (_seenStoryIds == null) {
      UserSimplePreferences.setSeenStoryIds([]);
      _seenStoryIds = [];
    }

    emit(StingrayLoaded(
      stingrays: event.stingrays,
      selectedIndex: event.selectedIndex,
      sortedStingrayIds: event.sortedStingrayIds,
      storiesMap: _stories,
      seenStoryIds: _seenStoryIds,
    ));
  }

  void _updateSelectedIndex(
    UpdateSelectedIndex event,
    Emitter<StingrayState> emit,
  ) {
    if (state is StingrayLoaded) {
      final state = this.state as StingrayLoaded;
      final selectedIndex = event.selectedIndex;

      emit(StingrayLoaded(
        stingrays: state.stingrays,
        selectedIndex: selectedIndex,
        sortedStingrayIds: state.sortedStingrayIds,
        storiesMap: state.storiesMap,
        seenStoryIds: state.seenStoryIds,
      ));
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }

  void _updateSelectedStingray(
    UpdateSelectedStingray event,
    Emitter<StingrayState> emit,
  ) {
    if (state is StingrayLoaded) {
      final state = this.state as StingrayLoaded;
      final Stingray stingray = state.stingrays[state.selectedIndex]!;

      //bloc provider of searh bloc add paginateUsers event
      BlocProvider.of<SearchBloc>(event.context).add(
        PaginateUsers(
          stingray: stingray,
          context: event.context,
        ),
      );
    }
  }

  //onClose, close the stingray stream
  Future<void> _closeStingray(
    CloseStingray event,
    Emitter<StingrayState> emit,
  ) async {
    //wait 5 seconds before closing the stingray stream
    await Future.delayed(Duration(seconds: 2));
    print('closing stingray stream');
    _stingraySubscription!.cancel();
    emit(StingrayLoading());
  }

  void _uploadStory(
    UploadStory event,
    Emitter<StingrayState> emit,
  ) async {
    if (state is StingrayLoaded) {
      final state = this.state as StingrayLoaded;
      String _imageUrl = '';
      await _storeageRepository.uploadStory(event.file, event.stingrayId).then(
          (value) async => _imageUrl = await _storeageRepository
              .getStoryImageUrl(event.file, event.stingrayId));

      String _dateTimeString = DateTime.now().toString();

      DateTime _deletedAt = DateTime.now().add(Duration(hours: 24));
      Timestamp _deletedAtTimestamp = Timestamp.fromDate(_deletedAt);

      String _stingrayId = event.stingrayId;
      String _id = Uuid().v4();

      //make a string, combine, that combines stingrayid, datetime.now, and the image url. Separate them with a #
      String _combine = '$_stingrayId#$_dateTimeString#$_imageUrl#$_id';
      //read _combie, and split it into a list of strings
      List<String?> _split = _combine.split('#');
      print(_split);

      _firestoreRepository.uploadStory(
          stingrayId: _stingrayId, combine: _combine);
    }
  }

  //_viewStory
  void _viewStory(
    ViewStory event,
    Emitter<StingrayState> emit,
  ) {
    if (state is StingrayLoaded) {
      final state = this.state as StingrayLoaded;
      String _id = event.story.id;
      List<String>? _seenIds = UserSimplePreferences.getSeenStoryIds();

      if (_seenIds == null) {
        _seenIds = [_id];
      } else {
        if (!_seenIds.contains(_id)) {
          _seenIds.add(_id);
        }
      }

      UserSimplePreferences.setSeenStoryIds(_seenIds);

      emit(StingrayLoading());
      emit(state.copyWith(seenStoryIds: _seenIds));
    }
  }

  //report story
  void _reportStory(
    ReportStory event,
    Emitter<StingrayState> emit,
  ) {
    String _storyString = event.story.storyToString();
    Report _report = Report.generateUserReport(
        reason: 'Reported Story',
        type: ReportStuff.story_type,
        reporter: event.reporter,
        reported: event.reportedUser,
        storyString: _storyString);
    _firestoreRepository.reportStory(report: _report);
  }

  //delete story
  void _deleteStory(
    DeleteStory event,
    Emitter<StingrayState> emit,
  ) {
    _firestoreRepository.deleteStory(story: event.story);
  }

//define a method, sortStingrays, that takes a list of stingrays and a list of strings and returns a sorted list of stingrays
  List<Stingray?> _sortStingrays(
      List<Stingray?> stingrays, List<String?> sortOrder) {
    List<Stingray?> _stingrays = [];
    for (int i = 0; i < sortOrder.length; i++) {
      for (int j = 0; j < stingrays.length; j++) {
        if (sortOrder[i] == stingrays[j]!.id) {
          _stingrays.add(stingrays[j]);
        }
      }
    }
    //if there was a stingray that was not in the sort order, add it to the end of the list
    for (int i = 0; i < stingrays.length; i++) {
      if (!_stingrays.contains(stingrays[i])) {
        _stingrays.add(stingrays[i]);
      }
    }
    return _stingrays;
  }
}
//end of stingray bloc