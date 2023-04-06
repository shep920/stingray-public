part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat?> compiledChats;
  final List<List<Chat?>> chats;
  final String sortOrder;

  const ChatLoaded({required this.compiledChats, required this.chats, required this.sortOrder});

  @override
  List<Object> get props => [compiledChats, chats, sortOrder];
}
