import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';

import '../typesense/bloc/search_bloc.dart';
import '/models/models.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final ProfileBloc _profileBloc;
  final SearchBloc _searchBloc;

  final FirestoreRepository _firestoreRepository;
  StreamSubscription? _profileSubscription;

  SwipeBloc({
    required ProfileBloc profileBloc,
    required FirestoreRepository firestoreRepository,
    required SearchBloc searchBloc,
  })  : _profileBloc = profileBloc,
        _firestoreRepository = firestoreRepository,
        _searchBloc = searchBloc,
        super(SwipeLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadTypesenseUsers>(_onLoadTypesenseUsers);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);
    on<IncrementSwipeImageUrlIndex>(_incrementSwipeImageUrlIndex);
    on<DecrementSwipeImageUrlIndex>(_decrementSwipeImageUrlIndex);

    _profileSubscription = _profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        if (state.user.isStingray == true) {
          add(LoadUsers(userId: state.user.id!));
        }
      }
      if (state is ProfileLoading) {
        print('ProfileLoading');
      }
    });
  }

  void _onLoadUsers(
    LoadUsers event,
    Emitter<SwipeState> emit,
  ) {
    _firestoreRepository.getUsers(event.userId).listen((users) {
      print('$users');
      add(
        UpdateHome(users: users),
      );
    });
  }

  void _onLoadTypesenseUsers(
    LoadTypesenseUsers event,
    Emitter<SwipeState> emit,
  ) {
    add(
      UpdateHome(users: event.users),
    );
  }

  void _onUpdateHome(
    UpdateHome event,
    Emitter<SwipeState> emit,
  ) {
    if (event.users != null) {
      emit(SwipeLoaded(users: event.users!, imageUrlIndex: 0));
    } else {
      emit(SwipeError());
    }
  }

  void _onSwipeLeft(
    SwipeLeft event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      List<dynamic> stingrayLikes = List.from(event.user.stingrays)
        ..remove(event.stingrayId);
      _firestoreRepository.updateUserStinrayArray(event.user.id, stingrayLikes);

      List<User> users = List.from(state.users)..remove(event.user);

      if (users.length < 2) {
        //if users is empty, break out of the loop
        if (users.isEmpty) {
          emit(SwipeError());
        } else {
          _searchBloc.add(ReloadSwipeUsers(
            context: event.context,
            swiper: event.swiper,
            users: users,
            removedUserId: event.user.id!,
            remainingUserId: users[0].id!,
          ));
        }
      }

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users, imageUrlIndex: 0));
      } else {
        emit(SwipeError());
      }
    }
  }

  void _onSwipeRight(
    SwipeRight event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      _firestoreRepository.updateStingrayLikes(
          event.id, event.user, event.stingrayImageUrl, event.stingrayId);

      final state = this.state as SwipeLoaded;
      List<dynamic> stingrayLikes = List.from(event.user.stingrays)
        ..remove(event.stingrayId);
      _firestoreRepository.updateUserStinrayArray(event.user.id, stingrayLikes);

      List<User> users = List.from(state.users)..remove(event.user);

      if (users.length < 2) {
        if (users.isEmpty) {
          emit(SwipeError());
        } else {
          _searchBloc.add(ReloadSwipeUsers(
            context: event.context,
            swiper: event.swiper,
            users: users,
            removedUserId: event.user.id!,
            remainingUserId: users[0].id!,
          ));
        }
      }

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users, imageUrlIndex: 0));
      } else {
        emit(SwipeError());
      }
    }
  }

  void _incrementSwipeImageUrlIndex(
    IncrementSwipeImageUrlIndex event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      int imageUrlIndex = state.imageUrlIndex;
      if (imageUrlIndex < state.users[0].imageUrls.length - 1) {
        imageUrlIndex = imageUrlIndex + 1;
      }

      emit(SwipeLoaded(
        users: state.users,
        imageUrlIndex: imageUrlIndex,
      ));
    }
  }

  void _decrementSwipeImageUrlIndex(
    DecrementSwipeImageUrlIndex event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      int imageUrlIndex = state.imageUrlIndex;
      if (imageUrlIndex > 0) {
        imageUrlIndex = imageUrlIndex - 1;
      }

      emit(SwipeLoaded(
        users: state.users,
        imageUrlIndex: imageUrlIndex,
      ));
    }
  }

  @override
  Future<void> close() async {
    _profileSubscription?.cancel();
    super.close();
  }
}
