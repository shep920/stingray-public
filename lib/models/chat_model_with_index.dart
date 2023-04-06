import 'package:equatable/equatable.dart';

import 'chat_model.dart';

class ChatWithIndex extends Equatable {
  final int stingrayIndex;
  final Chat? chat;

  ChatWithIndex({
    required this.stingrayIndex,
    required this.chat,
  });

  @override
  List<Object?> get props => [stingrayIndex, chat];
}
