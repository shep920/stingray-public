import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';

import 'message_model.dart';

class ChatViewers extends Equatable {
  final String chatId;
  final List<dynamic> viewerIds;

  ChatViewers({
    required this.chatId,
    required this.viewerIds,
  });

  @override
  List<Object?> get props => [
        chatId,
        viewerIds,
      ];

  static Map<String, dynamic> toJson(ChatViewers? chat) => {
        'chatId': chat?.chatId,
        'viewerIds': chat?.viewerIds,
      };

  static List<Map<String, dynamic>> chatListToJson(List<ChatViewers?> chats) {
    List<Map<String, dynamic>> chatList = [];
    for (ChatViewers? chat in chats) {
      chatList.add(ChatViewers.toJson(chat));
    }
    return chatList;
  }

  static ChatViewers chatFromMap(dynamic chat) {
    return ChatViewers(
      chatId: chat['chatId'],
      viewerIds: chat['viewerIds'],
    );
  }

  static List<ChatViewers?> chatListFromMap(dynamic mappedChats) {
    List<ChatViewers> chatList = [];
    for (Map<String, dynamic> chat in mappedChats) {
      chatList.add(ChatViewers.chatFromMap(chat));
    }
    return chatList;
  }

  static List<List<ChatViewers?>> chatViewersListFromQuerySnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map<List<ChatViewers?>>((doc) {
      return ChatViewers.chatListFromMap(doc['viewers']);
      // final viewer =
      //     doc.data() as Map<String, dynamic>?;

      // return ChatViewers(
      //   chatId: viewer!['chatId'],
      //   viewerIds: viewer['viewerIds'],
      // );
    }).toList();
  }

  static List<ChatViewers?> fromSnapshot(DocumentSnapshot doc) {
    return chatListFromMap(doc['viewers']);
  }

  static List<ChatViewers?> chatViewerListFromMap(dynamic mappedChatViewers) {
    List<ChatViewers> chatViewerList = [];
    for (Map<String, dynamic> leaderboardUser in mappedChatViewers) {
      chatViewerList.add(ChatViewers.chatViewerUserFromMap(leaderboardUser));
    }
    return chatViewerList;
  }

  static ChatViewers chatViewerUserFromMap(dynamic chatViewerUser) {
    return ChatViewers(
      chatId: chatViewerUser['chatId'],
      viewerIds: chatViewerUser['viewerIds'],
    );
  }

  static ChatViewers generateChatViewers(
      String chatId, List<dynamic> viewerIds) {
    return ChatViewers(
      chatId: chatId,
      viewerIds: viewerIds,
    );
  }
}
