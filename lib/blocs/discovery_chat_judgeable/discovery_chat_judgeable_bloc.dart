import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';

import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:typesense/typesense.dart';

import '../../models/chat_viewers_model.dart';
import '../../models/discovery_chat_model.dart';
import '../../repository/typesense_repo.dart';

part 'discovery_chat_judgeable_event.dart';
part 'discovery_chat_judgeable_state.dart';

class DiscoveryChatJudgeableBloc
    extends Bloc<DiscoveryChatJudgeableEvent, DiscoveryChatJudgeableState> {
  final FirestoreRepository _firestoreRepository;
  final TypesenseRepository _typesenseRepository;

  DiscoveryChatJudgeableBloc({
    required FirestoreRepository firestoreRepository,
    required TypesenseRepository typesenseRepository,
  })  : _firestoreRepository = firestoreRepository,
        _typesenseRepository = typesenseRepository,
        super(DiscoveryChatJudgeableLoading()) {
    on<LoadDiscoveryChatJudgeable>(_onLoadDiscoveryChatJudgeable);
    on<UpdateDiscoveryChatJudgeable>(_onUpdateDiscoveryChatJudgeable);
    on<CloseDiscoveryChatJudgeable>(_onCloseDiscoveryChatJudgeable);

    on<PaginateJudgeableChats>(_paginateJudgeableChats);
    on<RefreshJudgeableLoads>(_refreshLoads);
    on<RemoveLocalJudgeableChat>(_onRemoveLocalJudgeableChat);
  }

  Future<void> _onLoadDiscoveryChatJudgeable(
    LoadDiscoveryChatJudgeable event,
    Emitter<DiscoveryChatJudgeableState> emit,
  ) async {
    List<User?> userPool = [];

    if (state is DiscoveryChatJudgeableLoaded) {
      userPool = (state as DiscoveryChatJudgeableLoaded).userPool;
    }

    DocumentSnapshot? _lastJudgeableDoc;

    //judgeable data
    final QuerySnapshot<Object?> _judgeableQuery = await _firestoreRepository
        .getJudgeableDiscoveryChats(event.user.id!, null);
    //set a null last doc to get the first page
    if (_judgeableQuery.docs.isNotEmpty) {
      _lastJudgeableDoc = _judgeableQuery.docs.last;
    }
    final List<DiscoveryChat?> _judgeableChats =
        DiscoveryChat.discoveryChatListFromSnapshot(_judgeableQuery);

    bool hasMore = _judgeableChats.length >= 10;

    //make a list of strings of all the sender ids and receiver ids of the judgeable chats
    if (!event.testing) {
      List<String> judgeableSenderIds = _judgeableChats
          .where((chat) => chat!.senderId != event.user.id!)
          .map((chat) => chat!.senderId!)
          .toList();
      List<String> judgeableReceiverIds = _judgeableChats
          .where((chat) => chat!.receiverId != event.user.id!)
          .map((chat) => chat!.receiverId!)
          .toList();
      List<String> judgeableIds =
          //each unique user id
          [...judgeableSenderIds, ...judgeableReceiverIds].toSet().toList();

      final List<User?> judgeableUsers =
          await _typesenseRepository.getChatUsers(event.user.id!, judgeableIds);

      //add judgeable users to user pool
      userPool.addAll(judgeableUsers);
    } else {
      userPool = event.testUserPool;
    }

    _judgeableChats.removeWhere((chat) {
      if (chat!.senderId == event.user.id!) {
        return !userPool.any((user) => user!.id == chat.receiverId);
      } else {
        return !userPool.any((user) => user!.id == chat.senderId);
      }
    });

    //remove any judgeable chat that holds a sender id or receiver id that is not found in the user pool

    add(UpdateDiscoveryChatJudgeable(
        judgeableChats: _judgeableChats,
        userPool: userPool,
        lastJudgeableDoc: _lastJudgeableDoc,
        hasMore: hasMore));
  }

  void _onUpdateDiscoveryChatJudgeable(
    UpdateDiscoveryChatJudgeable event,
    Emitter<DiscoveryChatJudgeableState> emit,
  ) {
    emit(DiscoveryChatJudgeableLoaded(
      judgeableChats: event.judgeableChats,
      judgeableHasMore: event.hasMore,
      judgeableLoading: false,
      userPool: event.userPool,
      lastJudgeableDoc: event.lastJudgeableDoc,
    ));
  }

  void _paginateJudgeableChats(
    PaginateJudgeableChats event,
    Emitter<DiscoveryChatJudgeableState> emit,
  ) async {
    final state = this.state as DiscoveryChatJudgeableLoaded;
    List<User?> userPool = state.userPool;

    final QuerySnapshot<Object?> _judgeableQuery = await _firestoreRepository
        .getJudgeableDiscoveryChats(event.user.id!, state.lastJudgeableDoc);
    //set a null last doc to get the first page
    DocumentSnapshot<Object?>? _lastJudgeableDoc = _judgeableQuery.docs.last;
    final List<DiscoveryChat?> _judgeableChats =
        DiscoveryChat.discoveryChatListFromSnapshot(_judgeableQuery);

    //make a list of strings of all the sender ids and receiver ids of the judgeable chats
    if (!event.testing) {
      List<String> judgeableSenderIds = _judgeableChats
          .where((chat) => chat!.senderId != event.user.id!)
          .map((chat) => chat!.senderId!)
          .toList();
      List<String> judgeableReceiverIds = _judgeableChats
          .where((chat) => chat!.receiverId != event.user.id!)
          .map((chat) => chat!.receiverId!)
          .toList();
      List<String> judgeableIds =
          //each unique user id
          [...judgeableSenderIds, ...judgeableReceiverIds].toSet().toList();

      final List<User?> judgeableUsers =
          await _typesenseRepository.getChatUsers(event.user.id!, judgeableIds);

      //add judgeable users to user pool
      userPool.addAll(judgeableUsers);
    } else {
      userPool.addAll(event.testUserPool);
    }

    bool judgeableHasMore = _judgeableChats.length == 10;

    //emit a copywith
    emit(state.copyWith(
        judgeableChats: [...state.judgeableChats, ..._judgeableChats],
        judgeableHasMore: judgeableHasMore,
        userPool: userPool,
        judgeableLastDoc: _lastJudgeableDoc,
        judgeableLoading: false));
  }

  Future<void> _refreshLoads(
    RefreshJudgeableLoads event,
    Emitter<DiscoveryChatJudgeableState> emit,
  ) async {
    final state = this.state as DiscoveryChatJudgeableLoaded;
    //get the client
    Client _client = (Provider.of<SearchBloc>(event.context, listen: false)
            .state as QueryLoaded)
        .client;

    List<User?> _userPool = state.userPool;

    //get judgeable test
    //getTestJudgeable from firestore
    DiscoveryChat? testJudgeable =
        await _firestoreRepository.getTestJudgeable(event.user.id!);

    //check if test is the same as the one in state
    if (state.judgeableChats.isEmpty ||
        testJudgeable != state.judgeableChats[0]) {
      add(LoadDiscoveryChatJudgeable(user: event.user, context: event.context));
    } else {
      emit(state);
    }
  }

  void _onCloseDiscoveryChatJudgeable(
    CloseDiscoveryChatJudgeable event,
    Emitter<DiscoveryChatJudgeableState> emit,
  ) {
    print('DiscoveryChatJudgeableBloc disposed');

    emit(DiscoveryChatJudgeableLoading());
  }

  //RemoveLocalJudgeableChat
  void _onRemoveLocalJudgeableChat(
    RemoveLocalJudgeableChat event,
    Emitter<DiscoveryChatJudgeableState> emit,
  ) {
    final state = this.state as DiscoveryChatJudgeableLoaded;
    List<DiscoveryChat?> _chats = state.judgeableChats;

    _chats.removeWhere((chat) => chat!.chatId == event.message!.chatId);

    emit(DiscoveryChatJudgeableLoading());

    emit(state.copyWith(judgeableChats: _chats));
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
