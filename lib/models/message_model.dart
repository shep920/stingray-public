import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:intl/intl.dart';

class Message extends Equatable {
  final String id;
  final String? senderId;
  final String receiverId;
  final String message;
  final DateTime dateTime;
  final String timeString;
  final String chatId;
  final int likes;
  final int commentCount;
  final List<dynamic> userIdsWhoLiked;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.dateTime,
    required this.timeString,
    required this.likes,
    required this.chatId,
    required this.commentCount,
    required this.userIdsWhoLiked,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        message,
        dateTime,
        timeString,
        likes,
        chatId,
        commentCount,
        userIdsWhoLiked
      ];

  static Map<String, dynamic> toJson(Message? message) => {
        'id': message?.id,
        'senderId': message?.senderId,
        'receiverId': message?.receiverId,
        'message': message?.message,
        'dateTime': message?.dateTime,
        'timeString': message?.timeString,
        'likes': message?.likes,
        'chatId': message?.chatId,
        'commentCount': message?.commentCount,
        'userIdsWhoLiked': message?.userIdsWhoLiked,
      };

  static List<Map<String, dynamic>> messageListToJson(List<Message?> messages) {
    List<Map<String, dynamic>> messageList = [];
    for (Message? message in messages) {
      messageList.add(Message.toJson(message));
    }
    return messageList;
  }

  static Message messageFromMap(dynamic message) {
    return Message(
      id: message['id'],
      senderId: message['senderId'],
      message: message['message'],
      dateTime: message['dateTime'].toDate(),
      timeString: message['timeString'],
      likes: message['likes'],
      chatId: message['chatId'],
      receiverId: message['receiverId'],
      commentCount: message['commentCount'],
      userIdsWhoLiked: message['userIdsWhoLiked'],
    );
  }

  static List<Message?> messageListFromMap(dynamic mappedMessages) {
    List<Message> messageList = [];
    for (Map<String, dynamic> message in mappedMessages) {
      messageList.add(Message.messageFromMap(message));
    }
    return messageList;
  }

//   static List<Message> messages = [
//     Message(
//         id: 1,
//         senderId: 1,
//         receiverId: 2,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 2,
//         senderId: 2,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 3,
//         senderId: 1,
//         receiverId: 2,
//         message: 'I\'m good, as well. Thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 4,
//         senderId: 1,
//         receiverId: 3,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 5,
//         senderId: 3,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 6,
//         senderId: 1,
//         receiverId: 5,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 7,
//         senderId: 5,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 8,
//         senderId: 1,
//         receiverId: 6,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 9,
//         senderId: 6,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 10,
//         senderId: 1,
//         receiverId: 7,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     Message(
//         id: 11,
//         senderId: 7,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//   ];
// }
}
