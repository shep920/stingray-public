import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';

import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_viewers_model.dart';
import '../../models/discovery_chat_model.dart';
import '../../repository/typesense_repo.dart';
import '../discovery_messages/discovery_message_bloc.dart';

part 'discovery_chat_pending_event.dart';
part 'discovery_chat_pending_state.dart';

class DiscoveryChatPendingBloc
    extends Bloc<DiscoveryChatPendingEvent, DiscoveryChatPendingState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;

  DiscoveryChatPendingBloc({
    required FirestoreRepository firestoreRepository,
    required TypesenseRepository typesenseRepository,
  })  : _firestoreRepository = firestoreRepository,
        _typesenseRepository = typesenseRepository,
        super(DiscoveryChatPendingLoading()) {
    on<LoadDiscoveryChatPending>(_onLoadDiscoveryChatPending);
    on<UpdateDiscoveryChatPending>(_onUpdateDiscoveryChatPending);
    on<CloseDiscoveryChatPending>(_onCloseDiscoveryChatPending);
    on<PaginatePending>(_paginatePending);

    on<RefreshPendingLoads>(_refreshLoads);

    on<SendDirectMessage>(_sendDirectMessage);
  }

  Future<void> _onLoadDiscoveryChatPending(
    LoadDiscoveryChatPending event,
    Emitter<DiscoveryChatPendingState> emit,
  ) async {
    List<User?> userPool = [];
    if (state is DiscoveryChatPendingLoaded) {
      userPool = (state as DiscoveryChatPendingLoaded).userPool;
    }
    Client _client = (Provider.of<SearchBloc>(event.context, listen: false)
            .state as QueryLoaded)
        .client;

    DocumentSnapshot? _lastPendingDoc = null;

    //pending data
    final QuerySnapshot<Object?> _pendingQuery = await _firestoreRepository
        .getPendingDiscoveryChats(event.user.id!, null);
    //set a null last doc to get the first page
    if (_pendingQuery.docs.isNotEmpty) {
      _lastPendingDoc = _pendingQuery.docs.last;
    }
    final List<DiscoveryChat?> _pendingChats =
        DiscoveryChat.discoveryChatListFromSnapshot(_pendingQuery);

    bool _hasMore = _pendingQuery.docs.length >= 10;

    //make a list of strings of all the user ids and receiver ids of the pending chats
    List<String> pendingSenderIds = _pendingChats
        .where((chat) => chat!.senderId != event.user.id!)
        .map((chat) => chat!.senderId!)
        .toList();
    List<String> pendingReceiverIds = _pendingChats
        .where((chat) => chat!.receiverId != event.user.id!)
        .map((chat) => chat!.receiverId!)
        .toList();
    List<String> pendingIds =
        //each unique user id
        [...pendingSenderIds, ...pendingReceiverIds].toSet().toList();

    final List<User?> pendingUsers =
        await _typesenseRepository.getChatUsers(event.user.id!, pendingIds);

    //add pending users to user pool
    userPool.addAll(pendingUsers);

    _pendingChats.removeWhere((chat) {
      if (chat!.senderId == event.user.id!) {
        return !userPool.any((user) => user!.id == chat.receiverId);
      } else {
        return !userPool.any((user) => user!.id == chat.senderId);
      }
    });

    //remove any judgeable chat that holds a sender id or receiver id that is not found in the user pool

    add(UpdateDiscoveryChatPending(
      pending: _pendingChats,
      pendingUsers: pendingUsers,
      userPool: userPool,
      lastPendingDoc: _lastPendingDoc,
      hasMore: _hasMore,
    ));
  }

  void _onUpdateDiscoveryChatPending(
    UpdateDiscoveryChatPending event,
    Emitter<DiscoveryChatPendingState> emit,
  ) {
    emit(DiscoveryChatPendingLoaded(
      pending: event.pending,
      pendingHasMore: event.hasMore,
      pendingLoading: false,
      userPool: event.userPool,
      lastPendingDoc: event.lastPendingDoc,
    ));
  }

  void _paginatePending(
    PaginatePending event,
    Emitter<DiscoveryChatPendingState> emit,
  ) async {
    final state = this.state as DiscoveryChatPendingLoaded;
    List<User?> userPool = state.userPool;
    Client _client = (Provider.of<SearchBloc>(event.context, listen: false)
            .state as QueryLoaded)
        .client;
    final QuerySnapshot<Object?> _pendingQuery = await _firestoreRepository
        .getPendingDiscoveryChats(event.user.id!, state.lastPendingDoc);
    //set a null last doc to get the first page
    DocumentSnapshot<Object?>? _lastPendingDoc = _pendingQuery.docs.last;
    final List<DiscoveryChat?> _pendingChats =
        DiscoveryChat.discoveryChatListFromSnapshot(_pendingQuery);

    //make a list of strings of all the sender ids and receiver ids of the pending chats
    List<String> pendingSenderIds = _pendingChats
        .where((chat) => chat!.senderId != event.user.id!)
        .map((chat) => chat!.senderId!)
        .toList();
    List<String> pendingReceiverIds = _pendingChats
        .where((chat) => chat!.receiverId != event.user.id!)
        .map((chat) => chat!.receiverId!)
        .toList();
    List<String> pendingIds =
        //each unique user id
        [...pendingSenderIds, ...pendingReceiverIds].toSet().toList();

    final List<User?> pendingUsers =
        await _typesenseRepository.getChatUsers(event.user.id!, pendingIds);

    //add pending users to user pool
    userPool.addAll(pendingUsers);

    bool pendingHasMore = _pendingChats.length == 10;

    //emit a copywith
    emit(state.copyWith(
        pending: [...state.pending, ..._pendingChats],
        pendingHasMore: pendingHasMore,
        userPool: userPool,
        pendingLastDoc: _lastPendingDoc,
        pendingLoading: false));
  }

  // void _startStream(CloseDiscoveryChatPending event, Emitter<DiscoveryChatPendingState> emit) {

  // }

  Future<void> _refreshLoads(
    RefreshPendingLoads event,
    Emitter<DiscoveryChatPendingState> emit,
  ) async {
    final state = this.state as DiscoveryChatPendingLoaded;
    //get the client
    Client _client = (Provider.of<SearchBloc>(event.context, listen: false)
            .state as QueryLoaded)
        .client;

    List<User?> _userPool = state.userPool;

    //get pending test
    //getTestPending from firestore
    DiscoveryChat? testPending =
        await _firestoreRepository.getTestPending(event.user.id!);

    //check if test is the same as the one in state
    if (state.pending.isEmpty || testPending != state.pending[0]) {
      add(LoadDiscoveryChatPending(user: event.user, context: event.context));
    } else {
      emit(state);
    }

    //get judgeable test

    //emit a copywith
  }

  Future<List<User?>> getUsers(List<DiscoveryChat?> _pending,
      RefreshPendingLoads event, List<User?> _userPool, Client _client) async {
    List<String> senderIds = _pending
        .where((chat) => chat!.senderId != event.user.id)
        .map((chat) => chat!.senderId!)
        .toList();
    List<String> receiverIds = _pending
        .where((chat) => chat!.receiverId != event.user.id)
        .map((chat) => chat!.receiverId!)
        .toList();
    List<String> userIds =
        //each unique user id
        [...senderIds, ...receiverIds].toSet().toList();

    //remove any userIds that are in the userPool
    userIds.removeWhere((id) => _userPool.any((user) => user!.id == id));

    final List<User?> _pendingUsers =
        await _typesenseRepository.getChatUsers(event.user.id!, userIds);
    return _pendingUsers;
  }

  void _onCloseDiscoveryChatPending(
    CloseDiscoveryChatPending event,
    Emitter<DiscoveryChatPendingState> emit,
  ) {
    print('DiscoveryChatPendingBloc disposed');

    emit(DiscoveryChatPendingLoading());
  }

  //_sendDirectMessage
  void _sendDirectMessage(
    SendDirectMessage event,
    Emitter<DiscoveryChatPendingState> emit,
  ) async {
    DiscoveryChat? _chat;
    bool _newChat = false;

    //check if chat exists
    _chat = await _firestoreRepository.getDiscoveryChatForSender(
      id: event.user.id!,
      matchedUserId: event.matchedUser.id!,
    );

    if (_chat == null) {
      _chat = await _firestoreRepository.getDiscoveryChatForReceiver(
        id: event.user.id!,
        matchedUserId: event.matchedUser.id!,
      );
    }

    if (_chat == null) {
      _chat = DiscoveryChat.genericDiscoveryChat(
        chatId: event.chatId,
        lastMessageSentDateTime: DateTime.now(),
        receiverId: event.matchedUser.id!,
        senderId: event.user.id!,
        pending: true,
      );

      _newChat = true;
    }

    final DiscoveryMessage message = DiscoveryMessage(
      chatId: _chat.chatId,
      message: event.message,
      senderId: event.user.id!,
      receiverId: event.matchedUser.id!,
      dateTime: DateTime.now(),
      id: Uuid().v4(),
      imageUrl: event.imageUrl,
    );

    final DiscoveryMessageDocument messageDoc = DiscoveryMessageDocument(
      messages: (event.message == '') ? [] : [message],
      pending: true,
      blockerName: '',
      blockerId: '',
      blocked: false,
      judgeId: event.matchedUser.id!,
      chatId: _chat.chatId,
    );

    if (_newChat) {
      _firestoreRepository.initializeDiscoveryChats(_chat).then((value) =>
          _firestoreRepository.updateDiscoverysSeen(
              event.matchedUser, event.user));

      _firestoreRepository.intializeDiscoveryMessages(messageDoc);
    } else {
      _firestoreRepository.updateDiscoveryMessage(
        message,
      );

      _firestoreRepository.updateDiscoveryChatLastMessage(message);
      _firestoreRepository.updateDiscoveryMessageListener(
          event.user, event.matchedUser, message.message, event.chatId);
      if (!event.matchedUser.newMessages) {
        _firestoreRepository.setNewMessages(event.matchedUser.id!, true);
      }
    }

    _firestoreRepository.updatePendingListener(
        event.user, event.matchedUser, _chat.chatId);

    _firestoreRepository.updatedailyDmsRemaining(event.user);

    if (!event.matchedUser.newMessages) {
      _firestoreRepository.setNewMessages(event.matchedUser.id!, true);
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
