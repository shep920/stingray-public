import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/chat/chat_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../models/chat_viewers_model.dart';
import '../../models/discovery_chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../repository/typesense_repo.dart';

part 'discovery_chat_event.dart';
part 'discovery_chat_state.dart';

class DiscoveryChatBloc extends Bloc<DiscoveryChatEvent, DiscoveryChatState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;

  DiscoveryChatBloc({
    required FirestoreRepository firestoreRepository,
    required TypesenseRepository typesenseRepository,
  })  : _firestoreRepository = firestoreRepository,
        _typesenseRepository = typesenseRepository,
        super(DiscoveryChatLoading()) {
    on<LoadDiscoveryChat>(_onLoadDiscoveryChat);
    on<UpdateDiscoveryChat>(_onUpdateDiscoveryChat);
    on<CloseDiscoveryChat>(_onCloseDiscoveryChat);
    on<PaginateChats>(_paginateChats);
    on<AddLocalMessage>(_addLocalMessage);
    on<AddLocalMessageFromJudgeable>(_addLocalMessageFromJudgeable);

    // on<PaginateChats>(_paginateChats);

    on<RefreshLoads>(_refreshLoads);
    on<ViewDiscoveryChat>(_viewDiscoveryChat);
  }

  Future<void> _onLoadDiscoveryChat(
    LoadDiscoveryChat event,
    Emitter<DiscoveryChatState> emit,
  ) async {
    List<User?> userPool = [];
    if (state is DiscoveryChatLoaded) {
      userPool = (state as DiscoveryChatLoaded).userPool;
    }

    final List<DiscoveryChat?> _chats =
        await _typesenseRepository.getDiscoveryChats(event.user.id!);
    bool hasMore = _chats.length == 10;

    List<String> senderIds = _chats
        .where((chat) => chat!.senderId != event.user.id!)
        .map((chat) => chat!.senderId!)
        .toList();
    List<String> receiverIds = _chats
        .where((chat) => chat!.receiverId != event.user.id!)
        .map((chat) => chat!.receiverId!)
        .toList();
    List<String> userIds =
        //each unique user id
        [...senderIds, ...receiverIds].toSet().toList();

    //remove userIds that are already in the user pool
    userIds.removeWhere((id) => userPool.any((user) => user!.id == id));

    //remove duplicates from user ids

    final List<User?> _chatUsers =
        await _typesenseRepository.getChatUsers(event.user.id!, userIds);

    //add chat users to user pool
    userPool.addAll(_chatUsers);

    _chats.removeWhere((chat) {
      if (chat!.senderId == event.user.id!) {
        return !userPool.any((user) => user!.id == chat.receiverId);
      } else {
        return !userPool.any((user) => user!.id == chat.senderId);
      }
    });

    //remove any judgeable chat that holds a sender id or receiver id that is not found in the user pool

    add(UpdateDiscoveryChat(
      chats: _chats,
      chatUsers: _chatUsers,
      userPool: userPool,
      hasMore: hasMore,
    ));
  }

  void _onUpdateDiscoveryChat(
    UpdateDiscoveryChat event,
    Emitter<DiscoveryChatState> emit,
  ) {
    final chats = event.chats;

    // _isarBloc.add(SyncDiscoveryChats(chats: chats));

    emit(DiscoveryChatLoaded(
      chats: chats,
      chatHasMore: event.hasMore,
      chatLoading: false,
      userPool: event.userPool,
    ));
  }

  // void _startStream(CloseDiscoveryChat event, Emitter<DiscoveryChatState> emit) {

  // }

  Future<void> _refreshLoads(
    RefreshLoads event,
    Emitter<DiscoveryChatState> emit,
  ) async {
    final state = this.state as DiscoveryChatLoaded;
    //get the client
    Client _client = (Provider.of<SearchBloc>(event.context, listen: false)
            .state as QueryLoaded)
        .client;

    DiscoveryChat? test;
    List<User?> _userPool = state.userPool;

    List<DiscoveryChat?> testChat =
        await _typesenseRepository.getTestChat(_client, event.user.id!);
    if (testChat.isNotEmpty) {
      test = testChat.first;
    }
    //check if test is the same as the one in state
    if (state.chats.isNotEmpty && test != state.chats[0]) {
      add(LoadDiscoveryChat(
        user: event.user,
        context: event.context,
      ));
    } else {
      emit(state);
    }
  }

  //paginate chats
  Future<void> _paginateChats(
    PaginateChats event,
    Emitter<DiscoveryChatState> emit,
  ) async {
    final state = this.state as DiscoveryChatLoaded;
    emit(state.copyWith(chatLoading: true));
    //get the client
    Client _client = (Provider.of<SearchBloc>(event.context, listen: false)
            .state as QueryLoaded)
        .client;

    //make a list of strings called ignoreIds that is the last id of each chat currently in the state
    List<String> ignoreIds = state.chats.map((chat) => chat!.chatId).toList();

    List<DiscoveryChat?> _chats = await _typesenseRepository
        .paginateDiscoveryChats(event.userId, _client, ignoreIds);

    List<String> senderIds = _chats
        .where((chat) => chat!.senderId != event.userId)
        .map((chat) => chat!.senderId!)
        .toList();
    List<String> receiverIds = _chats
        .where((chat) => chat!.receiverId != event.userId)
        .map((chat) => chat!.receiverId!)
        .toList();
    List<String> userIds =
        //each unique user id
        [...senderIds, ...receiverIds].toSet().toList();

    //remove userIds that are already in the user pool
    userIds.removeWhere((id) => state.userPool.any((user) => user!.id == id));

    //remove duplicates from user ids

    final List<User?> _chatUsers =
        await _typesenseRepository.getChatUsers(event.userId, userIds);

    //add chat users to user pool
    List<User?> _userPool = state.userPool;
    _userPool.addAll(_chatUsers);

    //remove any chat that holds a sender id or receiver id that is not found in the user pool
    _chats.removeWhere((chat) {
      if (chat!.senderId == event.userId) {
        return !_userPool.any((user) => user!.id == chat.receiverId);
      } else {
        return !_userPool.any((user) => user!.id == chat.senderId);
      }
    });

    //add the new chats to the state chats
    List<DiscoveryChat?> _newChats = state.chats;
    _newChats.addAll(_chats);

    //remove any judgeable chat that holds a sender id or receiver id that is not found in the user pool

    add(UpdateDiscoveryChat(
      chats: _newChats,
      chatUsers: _chatUsers,
      userPool: _userPool,
      hasMore: _chats.length == 10,
    ));
  }

  void _onCloseDiscoveryChat(
    CloseDiscoveryChat event,
    Emitter<DiscoveryChatState> emit,
  ) {
    print('DiscoveryChatBloc disposed');

    emit(DiscoveryChatLoading());
  }

  void _addLocalMessage(
    AddLocalMessage event,
    Emitter<DiscoveryChatState> emit,
  ) {
    if (state is DiscoveryChatLoaded) {
      final state = this.state as DiscoveryChatLoaded;
      List<DiscoveryChat?> _chats = state.chats;
      DiscoveryChat? _chat =
          _chats.firstWhere((chat) => chat!.chatId == event.message!.chatId);

      DiscoveryChat _newChat = _chat!.copyWith(
        lastMessageSent: event.message!.message,
        lastMessageSentDateTime: event.message!.dateTime,
        seenBy: [event.message!.senderId],
      );

      _chats.removeWhere((chat) => chat!.chatId == event.message!.chatId);
      _chats.insert(0, _newChat);

      emit(DiscoveryChatLoading());

      emit(state.copyWith(chats: _chats));
    }
  }

  // make _viewDiscoveryChat
  void _viewDiscoveryChat(
    ViewDiscoveryChat event,
    Emitter<DiscoveryChatState> emit,
  ) {
    if (!event.chat.pending) {
      final state = this.state as DiscoveryChatLoaded;
      List<dynamic> _seenBy = event.chat.seenBy;
      _seenBy.add(event.user.id!);

      DiscoveryChat _oldChat = event.chat;
      DiscoveryChat _newChat = _oldChat.copyWith(
        seenBy: _seenBy,
      );

      List<DiscoveryChat?> _chats = state.chats;
      _chats.removeWhere((chat) => chat!.chatId == event.chat.chatId);
      _chats.insert(0, _newChat);

      emit(DiscoveryChatLoading());
      emit(state.copyWith(chats: _chats));
      _firestoreRepository.viewDiscoveryChat(
          discoveryChatId: _newChat.chatId, userId: event.user.id!);
    }
  }

  //_addLocalMessageFromJudgeable
  void _addLocalMessageFromJudgeable(
    AddLocalMessageFromJudgeable event,
    Emitter<DiscoveryChatState> emit,
  ) {
    if (state is DiscoveryChatLoaded) {
  final state = this.state as DiscoveryChatLoaded;
  List<DiscoveryChat?> _chats = state.chats;
  List<User?> _userPool = state.userPool;
  DiscoveryChat _chat = DiscoveryChat.genericDiscoveryChat(
      chatId: event.message!.chatId,
      receiverId: event.message!.receiverId,
      senderId: event.message!.senderId!);
  
  DiscoveryChat _newChat = _chat.copyWith(
    lastMessageSent: event.message!.message,
    lastMessageSentDateTime: event.message!.dateTime,
    seenBy: [event.message!.senderId],
  );
  
  _chats.insert(0, _newChat);
  
  _userPool.add(event.matchedUser);
  
  emit(DiscoveryChatLoading());
  
  emit(state.copyWith(chats: _chats, userPool: _userPool));
}
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
