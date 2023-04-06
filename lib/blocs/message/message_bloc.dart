import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:hero/repository/firestore_repository.dart';

import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/stingray_model.dart';
import '../../models/user_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final FirestoreRepository _firestoreRepository;
  late StreamSubscription _listener;
  late StreamSubscription _userListener;

  MessageBloc({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(MessageLoading()) {
    on<UpdateMessage>(_onUpdateMessage);
    on<LoadMessage>(_onLoadMessage);
    on<UpdateCommentCount>(_onUpdateCommentCount);
    on<BlockUser>(_blockUser);
    on<UnblockUser>(_unblockUser);
    on<SetLoading>(_setLoading);
    on<CloseMessage>(_closeMessage);
    on<LikeMessage>(_likeMessage);
    on<UnlikeMessage>(_unlikeMessage);
  }

  void _onLoadMessage(
    LoadMessage event,
    Emitter<MessageState> emit,
  ) {
    List<dynamic> messageIdsLiked = [];
    List<dynamic> messageIdsUnliked = [];
    _listener =
        _firestoreRepository.messages(event.messageId).listen((messages) {
      _userListener = _firestoreRepository
          .getUser(event.matchedUserId)
          .listen((matchedUser) {
        if (this.state is MessageLoaded) {
          messageIdsLiked = (this.state as MessageLoaded).messageIdsLiked;
          messageIdsUnliked = (this.state as MessageLoaded).messageIdsUnliked;
        }
        add(
          UpdateMessage(
            messages: messages.messages,
            matchedUserImageUrls: event.matchedUserImageUrls,
            chat: event.chat,
            matchedUser: matchedUser,
            blocked: messages.blocked,
            blockerName: messages.blockerName,
            blockerId: messages.blockerId,
            messageIdsLiked: messageIdsLiked,
            messageIdsUnliked: messageIdsUnliked,
          ),
        );
      });
    });
  }

  void _onUpdateCommentCount(
    UpdateCommentCount event,
    Emitter<MessageState> emit,
  ) {
    if (state is MessageLoaded) {
      final state = this.state as MessageLoaded;
      List<Message?> messages = state.messages;
      Message message = event.message;
      int messageIndex = messages.indexWhere((m) => m!.id == message.id);

      int newcommentCount = event.commentCount;

      Message? newMessage = Message(
          id: message.id,
          senderId: message.senderId,
          receiverId: message.receiverId,
          message: message.message,
          dateTime: message.dateTime,
          timeString: message.timeString,
          likes: message.likes,
          chatId: message.chatId,
          commentCount: newcommentCount,
          userIdsWhoLiked: message.userIdsWhoLiked);
      messages[messageIndex] = newMessage;

      FirestoreRepository().updateStingrayMessageCommentCount(
        message,
        event.stingrayId,
        messages,
      );

      emit(MessageLoaded(
        messages: messages,
        commentCount: newcommentCount,
        matchedUserImageUrl: state.matchedUserImageUrl,
        chat: state.chat,
        matchedUser: state.matchedUser,
        blocked: state.blocked,
        blockerName: state.blockerName,
        blockerId: state.blockerId,
        messageIdsLiked: state.messageIdsLiked,
        messageIdsUnliked: state.messageIdsUnliked,
      ));
    }
  }

  void _onUpdateMessage(
    UpdateMessage event,
    Emitter<MessageState> emit,
  ) {
    List<Message?> messages = event.messages;
    messages.sort((b, a) => a!.dateTime.compareTo(b!.dateTime));

    emit(MessageLoaded(
      messages: messages,
      matchedUserImageUrl: event.matchedUserImageUrls,
      chat: event.chat,
      matchedUser: event.matchedUser,
      blocked: event.blocked,
      blockerName: event.blockerName,
      blockerId: event.blockerId,
      messageIdsLiked: event.messageIdsLiked,
      messageIdsUnliked: event.messageIdsUnliked,
    ));
  }

  void _blockUser(
    BlockUser event,
    Emitter<MessageState> emit,
  ) {
    final state = this.state as MessageLoaded;
    _firestoreRepository.blockStingrayMessage(
      state.chat,
      event.blocker,
      event.stingray,
    );

    emit(MessageLoaded(
      messages: state.messages,
      matchedUserImageUrl: state.matchedUserImageUrl,
      chat: state.chat,
      matchedUser: state.matchedUser,
      blocked: state.blocked,
      blockerName: event.blocker.name,
      blockerId: event.blocker.id,
      messageIdsLiked: state.messageIdsLiked,
      messageIdsUnliked: state.messageIdsUnliked,
    ));
  }

  void _unblockUser(
    UnblockUser event,
    Emitter<MessageState> emit,
  ) {
    final state = this.state as MessageLoaded;
    _firestoreRepository.unblockStingrayMessage(
      state.chat,
      event.blocker,
      event.stingray,
    );
    emit(MessageLoaded(
      messages: state.messages,
      matchedUserImageUrl: state.matchedUserImageUrl,
      chat: state.chat,
      matchedUser: state.matchedUser,
      blocked: state.blocked,
      blockerName: event.blocker.name,
      blockerId: event.blocker.id,
      messageIdsLiked: state.messageIdsLiked,
      messageIdsUnliked: state.messageIdsUnliked,
    ));
  }

  void _setLoading(
    SetLoading event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageLoading());
  }

  void _closeMessage(
    CloseMessage event,
    Emitter<MessageState> emit,
  ) {
    final state = this.state as MessageLoaded;
    if (state.messageIdsLiked.isNotEmpty ||
        state.messageIdsUnliked.isNotEmpty) {
      List<Message?> oldMessages = state.messages;
      List<Message?> likedMessages = [];
      List<Message?> finalMessages = [];
      List<dynamic> messageIdsLiked = state.messageIdsLiked;
      List<dynamic> messageIdsUnliked = state.messageIdsUnliked;

      if (messageIdsLiked.isNotEmpty) {
        for (Message? message in oldMessages) {
          if (state.messageIdsLiked.contains(message!.id)) {
            int likes = message.likes + 1;
            List<dynamic> userIdsWhoLiked = message.userIdsWhoLiked;
            userIdsWhoLiked.add(event.userId);
            Message newMessage = Message(
                id: message.id,
                senderId: message.senderId,
                receiverId: message.receiverId,
                message: message.message,
                dateTime: message.dateTime,
                timeString: message.timeString,
                likes: likes,
                chatId: message.chatId,
                commentCount: message.commentCount,
                userIdsWhoLiked: userIdsWhoLiked);
            likedMessages.add(newMessage);
          } else {
            likedMessages.add(message);
          }
        }
      } else {
        likedMessages = oldMessages;
      }
      if (messageIdsUnliked.isNotEmpty) {
        for (Message? message in likedMessages) {
          if (state.messageIdsUnliked.contains(message!.id)) {
            int likes = message.likes - 1;
            List<dynamic> userIdsWhoLiked = message.userIdsWhoLiked;
            userIdsWhoLiked.remove(event.userId);
            Message newMessage = Message(
                id: message.id,
                senderId: message.senderId,
                receiverId: message.receiverId,
                message: message.message,
                dateTime: message.dateTime,
                timeString: message.timeString,
                likes: likes,
                chatId: message.chatId,
                commentCount: message.commentCount,
                userIdsWhoLiked: userIdsWhoLiked);
            finalMessages.add(newMessage);
          } else {
            finalMessages.add(message);
          }
        }
      } else {
        finalMessages = likedMessages;
      }
      _firestoreRepository.updateStingrayMessageLikeCount(
        state.chat!,
        finalMessages,
      );
    }
    _listener.cancel();
    _userListener.cancel();

    print('MessageBloc disposed');

    emit(MessageLoading());
  }

  void _likeMessage(
    LikeMessage event,
    Emitter<MessageState> emit,
  ) {
    final state = this.state as MessageLoaded;
    List<dynamic> messageIdsLiked = state.messageIdsLiked;
    List<dynamic> messageIdsUnliked = state.messageIdsUnliked;
    if (!messageIdsLiked.contains(event.message.id)) {
      if (messageIdsUnliked.contains(event.message.id)) {
        messageIdsUnliked.remove(event.message.id);
      } else {
        messageIdsLiked.add(event.message.id);
      }
    }
    emit(MessageLoaded(
      messages: state.messages,
      matchedUserImageUrl: state.matchedUserImageUrl,
      chat: state.chat,
      blocked: state.blocked,
      matchedUser: state.matchedUser,
      blockerName: state.blockerName,
      blockerId: state.blockerId,
      messageIdsLiked: messageIdsLiked,
      messageIdsUnliked: state.messageIdsUnliked,
    ));
  }

  void _unlikeMessage(
    UnlikeMessage event,
    Emitter<MessageState> emit,
  ) {
    final state = this.state as MessageLoaded;
    List<dynamic> messageIdsUnliked = state.messageIdsUnliked;
    List<dynamic> messageIdsLiked = state.messageIdsLiked;

    if (!messageIdsUnliked.contains(event.message.id)) {
      if (messageIdsLiked.contains(event.message.id)) {
        messageIdsLiked.remove(event.message.id);
      } else {
        messageIdsUnliked.add(event.message.id);
      }
    }
    emit(MessageLoaded(
      messages: state.messages,
      matchedUserImageUrl: state.matchedUserImageUrl,
      chat: state.chat,
      blocked: state.blocked,
      matchedUser: state.matchedUser,
      blockerName: state.blockerName,
      blockerId: state.blockerId,
      messageIdsLiked: state.messageIdsLiked,
      messageIdsUnliked: messageIdsUnliked,
    ));
  }

  @override
  Future<void> close() async {
    _listener.cancel();
    _userListener.cancel();
    super.close();
    print('MessageBloc disposed');
  }
}
