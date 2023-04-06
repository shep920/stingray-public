import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';

import 'message_model.dart';

class DiscoveryChat extends Equatable {
  final String chatId;

  final String? receiverId;

  final String? senderId;

  final String? lastMessageSent;
  final String judgeId;
  final DateTime? lastMessageSentDateTime;
  final bool pending;
  final List<dynamic> seenBy;
  final String? imageUrl;

  DiscoveryChat({
    required this.chatId,
    required this.receiverId,
    required this.lastMessageSent,
    required this.lastMessageSentDateTime,
    required this.judgeId,
    required this.pending,
    required this.senderId,
    required this.seenBy,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        chatId,
        receiverId,
        lastMessageSent,
        lastMessageSentDateTime,
        judgeId,
        pending,
        senderId,
        seenBy,
        imageUrl,
      ];

  static Map<String, dynamic> toJson(DiscoveryChat? chat) => {
        'id': chat?.chatId,
        'receiverId': chat?.receiverId,
        'lastMessageSent': chat?.lastMessageSent,
        'lastMessageSentDateTime': chat?.lastMessageSentDateTime,
        'judgeId': chat?.judgeId,
        'pending': chat?.pending,
        'senderId': chat?.senderId,
        'seenBy': chat?.seenBy,
        'imageUrl': chat?.imageUrl,
      };

  static List<Map<String, dynamic>> chatListToJson(List<DiscoveryChat?> chats) {
    List<Map<String, dynamic>> chatList = [];
    for (DiscoveryChat? chat in chats) {
      chatList.add(DiscoveryChat.toJson(chat));
    }
    return chatList;
  }

  static DiscoveryChat chatFromMap(dynamic chat) {
    return DiscoveryChat(
      chatId: chat['id'],
      receiverId: chat['receiverId'],
      lastMessageSent: chat['lastMessageSent'],
      lastMessageSentDateTime: chat['lastMessageSentDateTime'].toDate(),
      judgeId: chat['judgeId'] ?? '',
      pending: chat['pending'] ?? false,
      senderId: chat['senderId'],
      seenBy: chat['seenBy'] ?? [],
      imageUrl: chat['imageUrl'] ?? '',
    );
  }

  static List<DiscoveryChat?> chatListFromMap(dynamic mappedDiscoveryChats) {
    List<DiscoveryChat> chatList = [];
    for (Map<String, dynamic> chat in mappedDiscoveryChats) {
      chatList.add(DiscoveryChat.chatFromMap(chat));
    }
    return chatList;
  }

  static List<List<DiscoveryChat?>> chatListListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map<List<DiscoveryChat?>>((doc) {
      return DiscoveryChat.chatListFromSnapshot(doc);
    }).toList();
  }

  static List<DiscoveryChat?> chatListFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot['chats'].map<DiscoveryChat?>((chat) {
      return DiscoveryChat.chatFromMap(chat);
    }).toList();
  }

  static DiscoveryChat? chatFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? map = snapshot.data() as Map<String, dynamic>?;
    //create a chat object from the snapshot
    return DiscoveryChat(
      chatId: snapshot.id,
      receiverId: snapshot['receiverId'],
      lastMessageSent: snapshot['lastMessageSent'],
      lastMessageSentDateTime: snapshot['lastMessageSentDateTime'].toDate(),
      judgeId: snapshot['judgeId'],
      pending: snapshot['pending'],
      senderId: snapshot['senderId'],
      seenBy: map?['seenBy'] ?? [],
      imageUrl: map?['imageUrl'] ?? '',
    );
  }

  static DiscoveryChat discoveryChatFromTypesenseDoc(
      Map<dynamic, dynamic> doc) {
    Map<dynamic, dynamic>? map = doc;
    return DiscoveryChat(
      chatId: map['chatId'] as String,
      lastMessageSent: map['lastMessageSent'] as String,
      lastMessageSentDateTime: DateTime.fromMillisecondsSinceEpoch(
          (map['lastMessageSentDateTime'] as int) * 1000),
      judgeId: map['judgeId'] as String,
      pending: map['pending'] as bool,
      receiverId: map['receiverId'] as String,
      senderId: map['senderId'] as String,
      seenBy: (map['seenBy'] != null) ? map['seenBy'] as List<dynamic> : [],
      imageUrl: (map['imageUrl'] != null) ? map['imageUrl'] as String : '',
    );
  }

  //a methid that takes in a query snapshot and returns a list of discovery chats using the chatFromSnapshot method
  static List<DiscoveryChat?> discoveryChatListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map<DiscoveryChat?>((doc) {
      return DiscoveryChat.chatFromSnapshot(doc);
    }).toList();
  }

  //make a copyWith
  DiscoveryChat copyWith({
    String? chatId,
    String? receiverId,
    String? lastMessageSent,
    DateTime? lastMessageSentDateTime,
    String? judgeId,
    bool? pending,
    String? senderId,
    List<dynamic>? seenBy,
    String? imageUrl,
  }) {
    return DiscoveryChat(
      chatId: chatId ?? this.chatId,
      receiverId: receiverId ?? this.receiverId,
      lastMessageSent: lastMessageSent ?? this.lastMessageSent,
      lastMessageSentDateTime:
          lastMessageSentDateTime ?? this.lastMessageSentDateTime,
      judgeId: judgeId ?? this.judgeId,
      pending: pending ?? this.pending,
      senderId: senderId ?? this.senderId,
      seenBy: seenBy ?? this.seenBy,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  //write a method, genericDiscoveryChst, thaT RETURNs A DISCOVERY CHAT with the lowest values
  static DiscoveryChat genericDiscoveryChat(
      {required String chatId,
      required String receiverId,
      required String senderId,
      bool? pending,
      List<String>? seenBy,
      String? lastMessageSent,
      DateTime? lastMessageSentDateTime,
      String? imageUrl}) {
    return DiscoveryChat(
      chatId: chatId,
      receiverId: receiverId,
      lastMessageSent: lastMessageSent ?? '',
      lastMessageSentDateTime: DateTime.now(),
      judgeId: receiverId,
      pending: pending ?? false,
      senderId: senderId,
      seenBy: seenBy ?? [],
      imageUrl: imageUrl ?? '',
    );
  }
}
