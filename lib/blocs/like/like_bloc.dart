import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';

import 'package:hero/models/models.dart';
import 'package:hero/models/user_search_view_model.dart';
import 'package:hero/repository/firestore_repository.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final FirestoreRepository _firestoreRepository;
  late StreamSubscription _likeListener;

  LikeBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(LikeLoading()) {
    on<LikeEvent>((event, emit) {});

    on<LoadLikeFromFirestore>(_loadLikeFromFirestore);
    on<UpdateLikeFromFirestore>(_updateLikeFromFirestore);
    on<CloseLike>(_onCloseLike);
    on<LoadAllLikes>(_loadAllLikes);
  }

  _loadLikeFromFirestore(
    LoadLikeFromFirestore event,
    Emitter<LikeState> emit,
  ) {
    try {
      {
        _likeListener =
            _firestoreRepository.getLikes(event.stingray.id).listen((likes) {
          add(
            UpdateLikeFromFirestore(likes: likes),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _loadAllLikes(
    LoadAllLikes event,
    Emitter<LikeState> emit,
  ) {
    try {
      {
        _likeListener =
            _firestoreRepository.getLikesQuery().listen((likesListList) {
          //create a list of UserLiked from the list of lists of userLiked
          List<UserLiked> likes = [];
          for (var likesList in likesListList) {
            for (var like in likesList) {
              likes.add(like!);
            }
          }
          //sort likes descending
          List<UserLiked> reversedLikes = likes.reversed.toList();
          add(
            UpdateLikeFromFirestore(likes: reversedLikes),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _updateLikeFromFirestore(
    UpdateLikeFromFirestore event,
    Emitter<LikeState> emit,
  ) {
    try {
      if (event.likes.isNotEmpty) {
        emit(LikeLoaded(likes: event.likes));
      } else {
        emit(LikeError());
      }
    } catch (e) {
      print(e);
    }
  }

  void _onCloseLike(
    CloseLike event,
    Emitter<LikeState> emit,
  ) {
    _likeListener.cancel();

    print('LikeBloc disposed');

    emit(LikeLoading());
  }

  Future<void> close() async {
    super.close();
  }
}
