import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';

import 'message_model.dart';

class Chat extends Equatable {
  final String chatId;
  final String? stingrayId;
  final String? matchedUserId;
  final String? matchedUserImageUrl;
  final String? matchedUserName;
  final String? lastMessageSent;
  final DateTime? lastMessageSentDateTime;
  final int views;

  Chat({
    required this.chatId,
    required this.stingrayId,
    required this.matchedUserId,
    required this.matchedUserImageUrl,
    required this.matchedUserName,
    required this.lastMessageSent,
    required this.lastMessageSentDateTime,
    required this.views,
  });

  @override
  List<Object?> get props => [
        chatId,
        stingrayId,
        matchedUserId,
        matchedUserImageUrl,
        matchedUserName,
        lastMessageSent,
        lastMessageSentDateTime,
        views,
      ];

  static Map<String, dynamic> toJson(Chat? chat) => {
        'id': chat?.chatId,
        'stingrayId': chat?.stingrayId,
        'matchedUserId': chat?.matchedUserId,
        'matchedUserImageUrl': chat?.matchedUserImageUrl,
        'matchedUserName': chat?.matchedUserName,
        'lastMessageSent': chat?.lastMessageSent,
        'lastMessageSentDateTime': chat?.lastMessageSentDateTime,
        'views': chat?.views,
      };

  static List<Map<String, dynamic>> chatListToJson(List<Chat?> chats) {
    List<Map<String, dynamic>> chatList = [];
    for (Chat? chat in chats) {
      chatList.add(Chat.toJson(chat));
    }
    return chatList;
  }

  static Chat chatFromMap(dynamic chat) {
    return Chat(
      chatId: chat['id'],
      stingrayId: chat['stingrayId'],
      matchedUserId: chat['matchedUserId'],
      matchedUserImageUrl: chat['matchedUserImageUrl'],
      matchedUserName: chat['matchedUserName'],
      lastMessageSent: chat['lastMessageSent'],
      lastMessageSentDateTime: chat['lastMessageSentDateTime'].toDate(),
      views: chat['views'],
    );
  }

  static List<Chat?> chatListFromMap(dynamic mappedChats) {
    List<Chat> chatList = [];
    for (Map<String, dynamic> chat in mappedChats) {
      chatList.add(Chat.chatFromMap(chat));
    }
    return chatList;
  }

  static Chat generateChat(
      String matchedUserId,
      Stingray? stingray,
      String chatId,
      String matchedUserImageUrl,
      String matchedUserName,
      String lastMessageSent) {
    return Chat(
      matchedUserImageUrl: matchedUserImageUrl,
      chatId: chatId,
      stingrayId: stingray!.id,
      matchedUserId: matchedUserId,
      matchedUserName: matchedUserName,
      lastMessageSent: '',
      lastMessageSentDateTime: DateTime.now(),
      views: 0,
    );
  }

  static List<List<Chat?>> chatListListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map<List<Chat?>>((doc) {
      return Chat.chatListFromSnapshot(doc);
    }).toList();
  }

  static List<Chat?> chatListFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot['chats'].map<Chat?>((chat) {
      return Chat.chatFromMap(chat);
    }).toList();
  }

  static Chat? chatFromSnapshot(DocumentSnapshot snapshot) {
    //create a chat object from the snapshot
    return Chat(
      chatId: snapshot.id,
      stingrayId: snapshot['stingrayId'],
      matchedUserId: snapshot['matchedUserId'],
      matchedUserImageUrl: snapshot['matchedUserImageUrl'],
      matchedUserName: snapshot['matchedUserName'],
      lastMessageSent: snapshot['lastMessageSent'],
      lastMessageSentDateTime: snapshot['lastMessageSentDateTime'].toDate(),
      views: snapshot['views'],
    );
  }
}
