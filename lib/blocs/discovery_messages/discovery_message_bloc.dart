import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';

import 'package:hero/repository/firestore_repository.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_model.dart';
import '../../models/discovery_message_model.dart';
import '../../models/message_model.dart';
import '../../models/stingray_model.dart';
import '../../models/user_model.dart';

part 'discovery_message_event.dart';
part 'discovery_message_state.dart';

class DiscoveryMessageBloc
    extends Bloc<DiscoveryMessageEvent, DiscoveryMessageState> {
  final FirestoreRepository _firestoreRepository;
  late StreamSubscription _listener;

  DiscoveryMessageBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(DiscoveryMessageLoading()) {
    on<UpdateDiscoveryMessage>(_onUpdateDiscoveryMessage);
    on<LoadDiscoveryMessage>(_onLoadDiscoveryMessage);
    on<LoadDiscoveryMessageFromId>(_onLoadDiscoveryMessageFromId);

    on<BlockUser>(_blockUser);
    on<UnblockUser>(_unblockUser);

    on<CloseDiscoveryMessage>(_closeDiscoveryMessage);
    on<AcceptDiscoveryChat>(_acceptDiscoveryChat);
    on<RejectDiscoveryChat>(_rejectDiscoveryChat);
  }

  Future<void> _onLoadDiscoveryMessage(
    LoadDiscoveryMessage event,
    Emitter<DiscoveryMessageState> emit,
  ) async {
    final User matchedUser = event.matchedUser;

    _listener = _firestoreRepository
        .discoveryMessages(event.chatId)
        .listen((messageDoc) {
      add(
        UpdateDiscoveryMessage(
          discoveryMessageDocument: messageDoc,
          matchedUser: matchedUser,
        ),
      );
    });
  }

  Future<void> _onLoadDiscoveryMessageFromId(
    LoadDiscoveryMessageFromId event,
    Emitter<DiscoveryMessageState> emit,
  ) async {
    final User matchedUser =
        await _firestoreRepository.getFutureUser(event.userId);

    _listener = _firestoreRepository
        .discoveryMessages(event.chatId)
        .listen((messageDoc) {
      add(
        UpdateDiscoveryMessage(
          discoveryMessageDocument: messageDoc,
          matchedUser: matchedUser,
        ),
      );
    });
  }

  void _onUpdateDiscoveryMessage(
    UpdateDiscoveryMessage event,
    Emitter<DiscoveryMessageState> emit,
  ) {
    List<DiscoveryMessage?> messages = event.discoveryMessageDocument!.messages;
    messages.sort((b, a) => a!.dateTime.compareTo(b!.dateTime));

    emit(DiscoveryMessageLoaded(
      matchedUser: event.matchedUser,
      discoveryMessages: messages,
      discoveryMessageDocument: event.discoveryMessageDocument,
    ));
  }

  void _blockUser(
    BlockUser event,
    Emitter<DiscoveryMessageState> emit,
  ) {
    final state = this.state as DiscoveryMessageLoaded;
    // _firestoreRepository.blockDiscoveryMessage(
    //   state.chat,
    //   event.blocker,
    //   event.stingray,
    // );

    emit(DiscoveryMessageLoaded(
      matchedUser: state.matchedUser,
      discoveryMessageDocument: state.discoveryMessageDocument,
      discoveryMessages: state.discoveryMessages,
    ));
  }

  void _unblockUser(
    UnblockUser event,
    Emitter<DiscoveryMessageState> emit,
  ) {
    final state = this.state as DiscoveryMessageLoaded;
    // _firestoreRepository.unblockDiscoveryMessage(
    //   state.chat,
    //   event.blocker,
    //   event.stingray,
    // );
    emit(DiscoveryMessageLoaded(
      discoveryMessageDocument: state.discoveryMessageDocument,
      matchedUser: state.matchedUser,
      discoveryMessages: state.discoveryMessages,
    ));
  }

  void _closeDiscoveryMessage(
    CloseDiscoveryMessage event,
    Emitter<DiscoveryMessageState> emit,
  ) {
    _listener.cancel();

    emit(DiscoveryMessageLoading());
  }

  void _acceptDiscoveryChat(
    AcceptDiscoveryChat event,
    Emitter<DiscoveryMessageState> emit,
  ) {
    final state = this.state as DiscoveryMessageLoaded;
    DiscoveryMessage message = DiscoveryMessage(
      message: '',
      senderId: event.sender.id,
      receiverId: state.matchedUser.id!,
      dateTime: DateTime.now(),
      id: Uuid().v4(),
      chatId: state.discoveryMessageDocument!.chatId,
      imageUrl: '',
    );

    _firestoreRepository.acceptDiscoveryMessage(message);
    _firestoreRepository.updateDiscoveryChatLastMessage(message);

    BlocProvider.of<DiscoveryChatBloc>(event.context).add(
      AddLocalMessageFromJudgeable(
        matchedUser: state.matchedUser,
        message: message,
      ),
    );

    BlocProvider.of<DiscoveryChatJudgeableBloc>(event.context).add(
      RemoveLocalJudgeableChat(
        message: message,
      ),
    );

    print('chat accepted');
  }

  void _rejectDiscoveryChat(
    RejectDiscoveryChat event,
    Emitter<DiscoveryMessageState> emit,
  ) {
    final state = this.state as DiscoveryMessageLoaded;
    DiscoveryMessage message = DiscoveryMessage(
      message: '',
      senderId: event.sender.id,
      receiverId: state.matchedUser.id!,
      dateTime: DateTime.now(),
      id: Uuid().v4(),
      chatId: state.discoveryMessageDocument!.chatId,
      imageUrl: '',
    );

    _firestoreRepository.deleteDiscoveryMessage(message);
    _firestoreRepository.removeDiscoveryChat(message);

    BlocProvider.of<DiscoveryChatJudgeableBloc>(event.context).add(
      RemoveLocalJudgeableChat(
        message: message,
      ),
    );

    print('chat rejected');
  }

  @override
  Future<void> close() async {
    _listener.cancel();

    super.close();
    print('DiscoveryMessageBloc disposed');
  }
}
