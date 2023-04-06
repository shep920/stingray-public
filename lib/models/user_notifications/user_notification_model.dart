import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:uuid/uuid.dart';

class UserNotification extends Equatable {
  final String notificationId;
  final String type;
  final DateTime createdAt;
  final String? message;
  final String? relevantWaveId;

  final String? imageUrl;
  final String? relevantUserHandle;
  final String? trailingImageUrl;

  UserNotification({
    required this.notificationId,
    required this.type,
    required this.createdAt,
    required this.message,
    required this.relevantWaveId,
    required this.imageUrl,
    required this.relevantUserHandle,
    required this.trailingImageUrl,
  });

  @override
  List<Object?> get props => [
        notificationId,
        type,
        createdAt,
        message,
        relevantWaveId,
        imageUrl,
        relevantUserHandle,
        trailingImageUrl,
      ];

  static Map<String, dynamic> toJson(UserNotification? notification) => {
        'id': notification?.notificationId,
        'type': notification?.type,
        'createdAt': notification?.createdAt,
        'message': notification?.message,
        'relevantWaveId': notification?.relevantWaveId,
        'imageUrl': notification?.imageUrl,
        'relevantUserHandle': notification?.relevantUserHandle,
        'trailingImageUrl': notification?.trailingImageUrl,
      };

  static List<Map<String, dynamic>> notificationListToJson(
      List<UserNotification?> notifications) {
    List<Map<String, dynamic>> notificationList = [];
    for (UserNotification? notification in notifications) {
      notificationList.add(UserNotification.toJson(notification));
    }
    return notificationList;
  }

  static UserNotification notificationFromMap(dynamic notification) {
    return UserNotification(
      notificationId: notification['id'],
      type: notification['type'],
      createdAt: notification['createdAt'].toDate() ?? DateTime.now(),
      message: notification['message'],
      relevantWaveId: notification['relevantWaveId'],
      imageUrl: notification['imageUrl'],
      relevantUserHandle: notification['relevantUserHandle'],
      trailingImageUrl: notification['trailingImageUrl'],
    );
  }

  static List<UserNotification> notificationListFromMap(
      List<dynamic> notifications) {
    List<UserNotification> notificationList = [];
    for (dynamic notification in notifications) {
      notificationList.add(UserNotification.notificationFromMap(notification));
    }
    return notificationList;
  }

  //genericUserNotification
  static UserNotification genericUserNotification(
      {required String type,
      String? message,
      String? relevantWaveId,
      String? imageUrl,
      String? relevantUserHandle,
      String? trailingImageUrl}) {
    return UserNotification(
      notificationId: Uuid().v4(),
      type: type,
      createdAt: DateTime.now(),
      message: message,
      relevantWaveId: relevantWaveId,
      imageUrl: imageUrl,
      relevantUserHandle: relevantUserHandle,
      trailingImageUrl: trailingImageUrl,
    );
  }
}
