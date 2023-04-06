import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'message_model.dart';

class MessagesWithBlock extends Equatable {
  final List<Message?> messages;
  final bool blocked;
  final String blockerName;
  final String blockerId;

  MessagesWithBlock({
    required this.messages,
    required this.blocked,
    required this.blockerName,
    required this.blockerId,
  });

  @override
  List<Object?> get props => [
        messages,
        blocked,
        blockerName,
        blockerId,
      ];

  static MessagesWithBlock fromSnapshot(DocumentSnapshot doc) {
    return MessagesWithBlock(
      messages: Message.messageListFromMap(doc['messages']),
      blocked: doc['blocked'],
      blockerName: doc['blockerName'],
      blockerId: doc['blockerId'] ?? '',
    );
  }
}
