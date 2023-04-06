import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Comment extends Equatable {
  final String id;
  final String? senderId;
  final String message;
  final DateTime dateTime;
  final String timeString;
  final int likes;
  final String posterName;
  final String posterImageUrl;
  final List<dynamic> userIdsWhoLiked;
  Comment({
    required this.id,
    required this.senderId,
    required this.message,
    required this.dateTime,
    required this.timeString,
    required this.likes,
    required this.posterName,
    required this.posterImageUrl,
    required this.userIdsWhoLiked,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        message,
        dateTime,
        timeString,
        likes,
        posterName,
        posterImageUrl,
        userIdsWhoLiked,
      ];

  static Map<String, dynamic> toJson(Comment? comment) => {
        'id': comment?.id,
        'senderId': comment?.senderId,
        'message': comment?.message,
        'dateTime': comment?.dateTime,
        'timeString': comment?.timeString,
        'likes': comment?.likes,
        'posterName': comment?.posterName,
        'posterImageUrl': comment?.posterImageUrl,
        'userIdsWhoLiked': comment?.userIdsWhoLiked,
      };

  static Comment commentFromMap(dynamic comment) {
    return Comment(
      id: comment['id'],
      senderId: comment['senderId'],
      message: comment['message'],
      dateTime: comment['dateTime'].toDate(),
      timeString: comment['timeString'],
      likes: comment['likes'],
      posterName: comment['posterName'],
      posterImageUrl: comment['posterImageUrl'],
      userIdsWhoLiked: comment['userIdsWhoLiked'],
    );
  }

  static List<Comment?> commentListFromMap(List<dynamic> mappedComments) {
    List<Comment> userList = [];
    for (Map<String, dynamic> comment in mappedComments) {
      userList.add(commentFromMap(comment));
    }
    return userList;
  }

  static List<Map<String, dynamic>> commentListToJson(List<Comment?> comments) {
    List<Map<String, dynamic>> commentList = [];
    for (Comment? comment in comments) {
      commentList.add(Comment.toJson(comment));
    }
    return commentList;
  }

  static Comment? generateComment(
      User user, Stingray? stingray, String comment) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return Comment(
      message: comment,
      dateTime: now,
      senderId: user.id,
      likes: 0,
      timeString: formattedDate,
      id: Uuid().v4(),
      posterName: user.name,
      posterImageUrl: user.imageUrls[0],
      userIdsWhoLiked: [],
    );
  }
}
