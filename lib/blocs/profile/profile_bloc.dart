import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:hero/models/backpack_item_model.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';

import '../../models/chat_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc? _authBloc;
  final FirestoreRepository _firestoreRepository;
  late StreamSubscription _profileSebscription;

  StreamSubscription? _authSubscription;

  ProfileBloc({
    AuthBloc? authBloc,
    required FirestoreRepository databaseRepository,
  })  : _authBloc = authBloc,
        _firestoreRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);

    on<DeleteProfile>(_onDeleteProfile);
    on<LoadDiscovery>(_onLoadDiscovery);
    on<EditProfile>(_onEditProfile);
    on<CloseProfile>(_onCloseProfile);
    on<ViewingTutorial>(_onViewingTutorial);
    on<CloseTutorial>(_onCloseTutorial);
    on<BlockUserHandle>(_onBlockUserHandle);
    on<UnblockUserHandle>(_onUnblockUserHandle);
    //UpdateBackpack
    on<UpdateBackpack>(_onUpdateBackpack);
    //DropStingray
    on<DropStingray>(_onDropStingray);

    if (_authBloc != null) {
      _authSubscription = _authBloc!.stream.listen((state) {
        if (state.user != null) {
          add(LoadProfile(userId: state.user!.uid));
        }
      });
    }
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) {
    _profileSebscription =
        _firestoreRepository.getUser(event.userId).listen((user) {
      if (state is ProfileLoading) {}
      add(
        UpdateProfile(user: user),
      );
    });
  }

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) {
    final state = this.state;

    if (state is ProfileLoaded) {
      emit(state.copyWith(user: event.user));
    } else {
      emit(ProfileLoaded(user: event.user));
    }
  }

  Future<void> _onDeleteProfile(
    DeleteProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _firestoreRepository.deleteUser(event.user);
      _firestoreRepository.deleteWaves(event.user.id!);
      _firestoreRepository.deleteDiscoveryChats(event.user.id!);

      StorageRepository().deleteUser(event.user);
      if (event.user.isStingray) {
        _firestoreRepository.deleteStingray(event.user);
      }

      emit(ProfileLoading());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> _onLoadDiscovery(
    LoadDiscovery event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    User user = (state as ProfileLoaded).user;

    final seendIds = await _firestoreRepository.getSeenIds(user.id);
    BlocProvider.of<SearchBloc>(event.context).add(QueryDiscoverableUsers(
        userId: user.id!,
        seenIds: seendIds,
        context: event.context,
        user: user));
  }

  Future<void> _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    User user = (state as ProfileLoaded).user;
    User edits = event.editedUser;

    String bio = edits.bio;

    bio.trim();
    //shave off any whitespace in the bio

    bool _stupidTime = await _firestoreRepository.stupidTime();

    _firestoreRepository
        .editUser(edits.copyWith(bio: bio, isStingray: _stupidTime)!);

    if (_stupidTime) {
      _firestoreRepository.setStingray(Stingray.generateStingrayFromUser(
          edits.copyWith(bio: bio, isStingray: _stupidTime)!));
    }
  }

  Future<void> _onCloseProfile(
    CloseProfile event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    User user = (state as ProfileLoaded).user;

    //close the profile
    _profileSebscription.cancel();
  }

  Future<void> _onViewingTutorial(
    ViewingTutorial event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    final state = this.state as ProfileLoaded;
    emit(state.copyWith(isViewingTutorial: true));
  }

  Future<void> _onCloseTutorial(
    CloseTutorial event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    final state = this.state as ProfileLoaded;
    if (!state.user.seenTutorial) {
      _firestoreRepository.updateSeenTutorial(state.user.id!);
    }
    emit(state.copyWith(isViewingTutorial: true));
  }

  Future<void> _onBlockUserHandle(
    BlockUserHandle event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    final state = this.state as ProfileLoaded;
    //blocProvider of stingray bloc add CloseStingray
    _firestoreRepository.blockUserHandle(event.user, state.user.id!);
    //wait 5 seconds

    BlocProvider.of<StingrayBloc>(event.context).add(CloseStingray());
  }

  Future<void> _onUnblockUserHandle(
    UnblockUserHandle event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user from the ProfileLoaded state
    final state = this.state as ProfileLoaded;
    _firestoreRepository.unblockUserHandle(event.blockedHandle, state.user.id!);

    BlocProvider.of<StingrayBloc>(event.context).add(CloseStingray());
  }

  Future<void> _onUpdateBackpack(
    UpdateBackpack event,
    Emitter<ProfileState> emit,
  ) async {
    final state = this.state as ProfileLoaded;
    BackpackItem _item = BackpackItem.fromPrize(event.prize, state.user.id!);
    _firestoreRepository.setBackPack(item: _item);

    String tokenType = getTokenType(event.prize);

    _firestoreRepository.adjustTokenCount(
        userId: state.user.id!, tokenType: tokenType, amount: -1);
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }

  //_onDropStingray
  void _onDropStingray(
    DropStingray event,
    Emitter<ProfileState> emit,
  ) {
    final state = this.state as ProfileLoaded;
    _firestoreRepository.dropStingray(userId: state.user.id!);
    _firestoreRepository.disableStingrayStatus(userId: state.user.id!);
  }

  String getTokenType(Prize prize) {
    switch (prize.prizeValue) {
      case Prize.goldValue:
        return Prize.goldToken;
      case Prize.silverValue:
        return Prize.silverToken;
      case Prize.bronzeValue:
        return Prize.bronzeToken;
      case Prize.ironValue:
        return Prize.ironToken;
      default:
        return '';
    }
  }
}
