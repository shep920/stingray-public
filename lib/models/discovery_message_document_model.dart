import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'discovery_message_model.dart';
import 'message_model.dart';

class DiscoveryMessageDocument extends Equatable {
  final List<DiscoveryMessage?> messages;
  final bool blocked;
  final String blockerName;
  final String blockerId;
  final String judgeId;
  final bool pending;
  final String chatId;

  DiscoveryMessageDocument({
    required this.messages,
    required this.blocked,
    required this.blockerName,
    required this.blockerId,
    required this.pending,
    required this.judgeId,
    required this.chatId,
  });

  @override
  List<Object?> get props => [
        messages,
        blocked,
        blockerName,
        blockerId,
        pending,
        judgeId,
        chatId,
      ];

  static DiscoveryMessageDocument fromSnapshot(DocumentSnapshot doc) {
    return DiscoveryMessageDocument(
      messages: DiscoveryMessage.messageListFromMap(doc['messages']),
      blocked: doc['blocked'] ?? false,
      blockerName: doc['blockerName'],
      blockerId: doc['blockerId'] ?? '',
      pending: doc['pending'] ?? false,
      judgeId: doc['judgeId'] ?? '',
      chatId: doc['chatId'] ?? '',
    );
  }

  static Map<String, dynamic> toJson(DiscoveryMessageDocument doc) => {
        'messages': DiscoveryMessage.messageListToJson(doc.messages),
        'blocked': doc.blocked,
        'blockerName': doc.blockerName,
        'blockerId': doc.blockerId,
        'pending': doc.pending,
        'judgeId': doc.judgeId,
        'chatId': doc.chatId,
      };
}
