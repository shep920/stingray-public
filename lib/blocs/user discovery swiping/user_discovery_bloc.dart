import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:uuid/uuid.dart';

import '/models/models.dart';

part 'user_discovery_event.dart';
part 'user_discovery_state.dart';

class UserDiscoveryBloc extends Bloc<UserDiscoveryEvent, UserDiscoveryState> {
  final ProfileBloc _profileBloc;

  final FirestoreRepository _firestoreRepository;
  final SearchBloc _searchBloc;

  UserDiscoveryBloc({
    required ProfileBloc profileBloc,
    required SearchBloc searchBloc,
    required FirestoreRepository firestoreRepository,
  })  : _profileBloc = profileBloc,
        _searchBloc = searchBloc,
        _firestoreRepository = firestoreRepository,
        super(UserDiscoveryLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<UserDiscoverySwipeLeft>(_onUserDiscoverySwipeLeft);

    on<IncrementUserDiscoveryImageUrlIndex>(
        _incrementUserDiscoveryImageUrlIndex);
    on<DecrementUserDiscoveryImageUrlIndex>(
        _decrementUserDiscoveryImageUrlIndex);
    on<UserDiscoverySendMessage>(_onUserDiscoverySendMessage);
    on<CancelMessage>(_onCancelMessage);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserDiscoveryState> emit,
  ) async {
    if (_profileBloc.state is ProfileLoaded) {
      final user = (_profileBloc.state as ProfileLoaded).user;

      //a list of user from the search bloc state.discoverableusers
      final List<User>? users = event.users;

      add(UpdateHome(users: users));
    }
  }

  void _onUpdateHome(
    UpdateHome event,
    Emitter<UserDiscoveryState> emit,
  ) {
    if (event.users != null) {
      if (event.users!.isEmpty) {
        emit(UserDiscoveryEmpty());
      } else {
        emit(UserDiscoveryLoaded(users: event.users!, imageUrlIndex: 0));
      }
    } else {
      emit(UserDiscoveryEmpty());
    }
  }

  void _onUserDiscoverySwipeLeft(
    UserDiscoverySwipeLeft event,
    Emitter<UserDiscoveryState> emit,
  ) {
    if (state is UserDiscoveryLoaded) {
      final state = this.state as UserDiscoveryLoaded;

      _firestoreRepository
          .updateDiscoverysSeen(event.receiver, event.sender)
          .then((value) =>
              _firestoreRepository.updateDiscoveriesUsable(event.sender));
      _firestoreRepository.updateDiscoveriesUsable(event.sender);

      List<User> users = List.from(state.users)..remove(event.receiver);

      if (users.isNotEmpty) {
        emit(UserDiscoveryLoaded(users: users, imageUrlIndex: 0));
      } else {
        emit(UserDiscoveryEmpty());
      }
    }
  }

  void _incrementUserDiscoveryImageUrlIndex(
    IncrementUserDiscoveryImageUrlIndex event,
    Emitter<UserDiscoveryState> emit,
  ) {
    if (state is UserDiscoveryLoaded) {
      final state = this.state as UserDiscoveryLoaded;
      int imageUrlIndex = state.imageUrlIndex;
      if (imageUrlIndex < state.users[0].imageUrls.length - 1) {
        imageUrlIndex = imageUrlIndex + 1;
      }

      emit(UserDiscoveryLoaded(
        users: state.users,
        imageUrlIndex: imageUrlIndex,
      ));
    }
  }

  void _decrementUserDiscoveryImageUrlIndex(
    DecrementUserDiscoveryImageUrlIndex event,
    Emitter<UserDiscoveryState> emit,
  ) {
    if (state is UserDiscoveryLoaded) {
      final state = this.state as UserDiscoveryLoaded;
      int imageUrlIndex = state.imageUrlIndex;
      if (imageUrlIndex > 0) {
        imageUrlIndex = imageUrlIndex - 1;
      }

      emit(UserDiscoveryLoaded(
        users: state.users,
        imageUrlIndex: imageUrlIndex,
      ));
    }
  }

  void _onUserDiscoverySendMessage(
    UserDiscoverySendMessage event,
    Emitter<UserDiscoveryState> emit,
  ) {
    if (state is UserDiscoveryLoaded) {
      final state = this.state as UserDiscoveryLoaded;

      final DiscoveryChat chat = DiscoveryChat.genericDiscoveryChat(
        chatId: Uuid().v4(),
        lastMessageSentDateTime: DateTime.now(),
        receiverId: event.receiver.id!,
        senderId: event.sender.id!,
        pending: true,
      );

      final DiscoveryMessage message = DiscoveryMessage(
        chatId: chat.chatId,
        message: event.message,
        senderId: event.sender.id!,
        receiverId: event.receiver.id!,
        dateTime: DateTime.now(),
        id: Uuid().v4(),
        imageUrl: '',
      );

      final DiscoveryMessageDocument messageDoc = DiscoveryMessageDocument(
        messages: (event.message == '') ? [] : [message],
        pending: true,
        blockerName: '',
        blockerId: '',
        blocked: false,
        judgeId: event.receiver.id!,
        chatId: chat.chatId,
      );

      _firestoreRepository.initializeDiscoveryChats(chat).then((value) =>
          _firestoreRepository.updateDiscoverysSeen(
              event.receiver, event.sender));

      _firestoreRepository.intializeDiscoveryMessages(messageDoc);
      _firestoreRepository.updatePendingListener(
          event.sender, event.receiver, chat.chatId);

      _firestoreRepository.updateDiscoveriesUsable(event.sender);

      if (!event.receiver.newMessages) {
        _firestoreRepository.setNewMessages(event.receiver.id!, true);
      }

      List<User> users = List.from(state.users)..remove(event.receiver);

      if (state.users.isNotEmpty) {
        emit(UserDiscoveryLoaded(users: users, imageUrlIndex: 0));
      } else {
        emit(UserDiscoveryEmpty());
      }
    }
  }

  void _onCancelMessage(
    CancelMessage event,
    Emitter<UserDiscoveryState> emit,
  ) {
    final state = this.state as UserDiscoveryLoaded;
    _firestoreRepository.updateDiscoverysSeen(event.receiver, event.sender);
    _firestoreRepository.updateDiscoveriesUsable(event.sender);
    if (state.users.isNotEmpty) {
      emit(UserDiscoveryLoaded(users: state.users, imageUrlIndex: 0));
    } else {
      emit(UserDiscoveryEmpty());
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
