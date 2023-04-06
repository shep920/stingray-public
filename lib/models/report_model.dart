import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/chat_model.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/static_data/report_stuff.dart';
import 'package:uuid/uuid.dart';

import 'discovery_chat_model.dart';
import 'message_model.dart';

class Report extends Equatable {
  final String type;
  final String? reason;
  final String? reportId;
  final Chat? chat;
  final Stingray? stingray;
  final User? reporterUser;
  final User? reportedUser;
  final String? storyString;

  final String? chatId;
  final DateTime reportTime;
  final Wave? wave;

  const Report({
    required this.type,
    required this.reason,
    required this.reportId,
    this.chat,
    this.stingray,
    this.wave,
    this.reportedUser,
    required this.reporterUser,
    required this.reportTime,
    this.chatId,
    this.storyString,
  });

  @override
  List<Object?> get props => [
        type,
        reason,
        reportId,
        chat,
        stingray,
        reporterUser,
        reportTime,
        wave,
        reportedUser,
        chatId,
        storyString,
      ];

  static Map<String, dynamic> toJson(Report report) => {
        'type': report.type,
        'id': report.reportId,
        'chat': (report.chat == null) ? null : Chat.toJson(report.chat),
        'wave': (report.wave == null) ? null : Wave.toJson(report.wave),
        'stingray':
            (report.stingray == null) ? null : Stingray.toJson(report.stingray),
        'reporterUser': User.toJson(report.reporterUser),
        'reportTime': report.reportTime,
        'reason': report.reason,
        'reportedUser': (report.reportedUser == null)
            ? null
            : User.toJson(report.reportedUser),
        'chatId': report.chatId,
        'storyString': report.storyString,
      };

  static List<Map<String, dynamic>> reportListToJson(List<Report?> reports) {
    List<Map<String, dynamic>> reportList = [];
    for (Report? report in reports) {
      reportList.add(Report.toJson(report!));
    }
    return reportList;
  }

  static Report reportFromMap(dynamic report) {
    return Report(
      type: report['type'],
      reason: report['reason'],
      reportId: report['id'],
      chat: Chat.chatFromMap(report['chat']),
      stingray: Stingray.stingrayFromSnapshot(report['stingray']),
      reporterUser: User.fromSnapshot(report['reporterUser']),
      reportTime: DateTime.parse(report['reportTime']),
      wave: Wave.waveFromMap(report['wave']),
      reportedUser: User.fromSnapshot(report['reportedUser']),
      chatId: report['chatId'],
      storyString: report['storyString'],
    );
  }

  static List<Report?> reportListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map<Report?>((doc) {
      return Report(
        type: doc['type'] ?? '',
        reason: doc['reason'] ?? '',
        reportId: doc['id'] ?? '',
        chat: (doc['chat'] == null) ? null : Chat.chatFromMap(doc['chat']),
        stingray: (doc['stingray'] == null)
            ? null
            : Stingray.stingrayFromSnapshot(doc['stingray']),
        reporterUser: User.fromDynamic(doc['reporterUser']),
        reportTime: doc['reportTime'].toDate(),
        wave: (doc['wave'] == null) ? null : Wave.waveFromMap(doc['wave']),
        reportedUser: (doc['reportedUser'] == null)
            ? null
            : User.fromDynamic(doc['reportedUser']),
        chatId: doc['chatId'] ?? '',
        storyString: doc['storyString'] ?? '',
      );
    }).toList();
  }

  static Report generateUserReport(
      {required User reported,
      required String reason,
      required User reporter,
      String? chatId,
      String? storyString,
      required String type}) {
    return Report(
      type: type,
      reason: reason,
      reportId: Uuid().v4(),
      reporterUser: reporter,
      reportTime: DateTime.now(),
      reportedUser: reported,
      chatId: chatId,
      storyString: storyString,
    );
  }
}
