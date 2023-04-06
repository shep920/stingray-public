import 'package:equatable/equatable.dart';

import 'chat_model.dart';

class ChatListList extends Equatable {
  final List<List<Chat?>> chats;

  ChatListList({
    required this.chats,
  
  });

  @override
  List<Object?> get props => [chats];
}
