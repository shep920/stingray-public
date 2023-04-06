part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChat extends ChatEvent {
  final String? sortOrder;
  const LoadChat({this.sortOrder});

  @override
  List<Object?> get props => [sortOrder];
}

class CloseChat extends ChatEvent {
  const CloseChat();

  @override
  List<Object?> get props => [];
}

class UpdateChat extends ChatEvent {
  final List<List<Chat?>> chats;
  
  final String? sortOrder;

  const UpdateChat(
      {required this.chats, this.sortOrder});

  @override
  List<Object?> get props => [chats, sortOrder];
}
