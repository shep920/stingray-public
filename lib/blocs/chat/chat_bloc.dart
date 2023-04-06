import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/blocs/auth/auth_bloc.dart';

import 'package:hero/models/chat_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:provider/provider.dart';

import '../../models/chat_viewers_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirestoreRepository _firestoreRepository;
  
  late StreamSubscription _chatListener;

  ChatBloc({
    required FirestoreRepository firestoreRepository,
    
  })  : _firestoreRepository = firestoreRepository,
        
        super(ChatLoading()) {
    on<LoadChat>(_onLoadChat);
    on<UpdateChat>(_onUpdateChat);
    on<CloseChat>(_onCloseChat);
  }

  void _onLoadChat(
    LoadChat event,
    Emitter<ChatState> emit,
  ) {
    _chatListener = _firestoreRepository.chats.listen((chats) {
      add(
        UpdateChat(
          chats: chats,
          sortOrder: event.sortOrder,
        ),
      );
    });
  }

  void _onUpdateChat(
    UpdateChat event,
    Emitter<ChatState> emit,
  ) {
    String sortOrder = '';
    if (event.sortOrder != null) {
      sortOrder = event.sortOrder!;
    } else {
      if (state is ChatLoaded) {
        sortOrder = (state as ChatLoaded).sortOrder;
      }
    }

    List<Chat?>? compiledChats = [];
    for (List<Chat?> chatList in event.chats) {
      for (Chat? chat in chatList) {
        if (chat != null) {
          compiledChats.add(chat);
        }
      }
    }
    

    //generate compiledChatViewers from event.chatViewers

    if (sortOrder == 'Recent') {
      compiledChats.sort((a, b) =>
          b!.lastMessageSentDateTime!.compareTo(a!.lastMessageSentDateTime!));
    }
    if (sortOrder == 'Popular') {
      compiledChats.sort((a, b) => b!.views.compareTo(a!.views));
    }
    emit(ChatLoaded(
        compiledChats: compiledChats,
        chats: event.chats,
        sortOrder: sortOrder));
  }

  void _onCloseChat(
    CloseChat event,
    Emitter<ChatState> emit,
  ) {
    _chatListener.cancel();

    print('ChatBloc disposed');

    emit(ChatLoading());
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
