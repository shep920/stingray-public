import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:intl/intl.dart';

class DiscoveryMessage extends Equatable {
  final String id;
  final String? senderId;
  final String receiverId;
  final String message;
  final DateTime dateTime;

  final String chatId;
  final String imageUrl;

  DiscoveryMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.dateTime,
    required this.chatId,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        message,
        dateTime,
        chatId,
        imageUrl,
      ];

  static Map<String, dynamic> toJson(DiscoveryMessage? message) => {
        'id': message?.id,
        'senderId': message?.senderId,
        'receiverId': message?.receiverId,
        'message': message?.message,
        'dateTime': message?.dateTime,
        'chatId': message?.chatId,
        'imageUrl': message?.imageUrl,
      };

  static List<Map<String, dynamic>> messageListToJson(
      List<DiscoveryMessage?> messages) {
    List<Map<String, dynamic>> messageList = [];
    for (DiscoveryMessage? message in messages) {
      messageList.add(DiscoveryMessage.toJson(message));
    }
    return messageList;
  }

  static DiscoveryMessage messageFromMap(dynamic message) {
    return DiscoveryMessage(
      id: message['id'],
      senderId: message['senderId'],
      message: message['message'],
      dateTime: message['dateTime'].toDate(),
      chatId: message['chatId'],
      receiverId: message['receiverId'],
      imageUrl: message['imageUrl'] ?? '',
    );
  }

  static List<DiscoveryMessage?> messageListFromMap(
      dynamic mappedDiscoveryMessages) {
    List<DiscoveryMessage> messageList = [];
    for (Map<String, dynamic> message in mappedDiscoveryMessages) {
      messageList.add(DiscoveryMessage.messageFromMap(message));
    }
    return messageList;
  }

//   static List<DiscoveryMessage> messages = [
//     DiscoveryMessage(
//         id: 1,
//         senderId: 1,
//         receiverId: 2,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 2,
//         senderId: 2,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 3,
//         senderId: 1,
//         receiverId: 2,
//         message: 'I\'m good, as well. Thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 4,
//         senderId: 1,
//         receiverId: 3,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 5,
//         senderId: 3,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 6,
//         senderId: 1,
//         receiverId: 5,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 7,
//         senderId: 5,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 8,
//         senderId: 1,
//         receiverId: 6,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 9,
//         senderId: 6,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 10,
//         senderId: 1,
//         receiverId: 7,
//         message: 'Hey, how are you?',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//     DiscoveryMessage(
//         id: 11,
//         senderId: 7,
//         receiverId: 1,
//         message: 'I\'m good, thank you.',
//         dateTime: DateTime.now(),
//         timeString: DateFormat('jm').format(DateTime.now())),
//   ];
// }
}
