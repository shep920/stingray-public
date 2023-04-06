import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class UserLiked extends Equatable {
  final String? userMatchId;
  final String name;
  final String imageUrl;
  final String chatId;
  final bool docExists;
  final String stingrayImageUrl;
  final String stingrayId;

  UserLiked({
    required this.userMatchId,
    required this.name,
    required this.imageUrl,
    required this.chatId,
    required this.docExists,
    required this.stingrayImageUrl,
    required this.stingrayId,
  });

  @override
  List<Object?> get props => [
        userMatchId,
        name,
        imageUrl,
        chatId,
        docExists,
        chatId,
        stingrayImageUrl,
        stingrayId
      ];

  static Map<String, dynamic> toJson(
          User? userLiked, String stingrayImageUrl, String stingrayId) =>
      {
        'userMatchedId': userLiked?.id,
        'name': userLiked?.name,
        'imageUrl': userLiked?.imageUrls[0],
        'chatId': Uuid().v4(),
        'docExists': false,
        'stingrayImageUrl': stingrayImageUrl,
        'stingrayId': stingrayId,
      };

  static Map<String, dynamic> toJsonForUpdate(UserLiked? userLiked) => {
        'userMatchedId': userLiked!.userMatchId,
        'name': userLiked.name,
        'imageUrl': userLiked.imageUrl,
        'chatId': userLiked.chatId,
        'docExists': false,
        'stingrayImageUrl': userLiked.stingrayImageUrl,
        'stingrayId': userLiked.stingrayId,
      };

  static List<Map<String, dynamic>> likesListToJson(List<UserLiked?> likes) {
    List<Map<String, dynamic>> likeList = [];
    for (UserLiked? like in likes) {
      likeList.add(UserLiked.toJsonForUpdate(like));
    }
    return likeList;
  }

  List<UserLiked?> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return UserLiked(
        name: dataMap['name'],
        imageUrl: dataMap['imageUrl'],
        userMatchId: dataMap['userMatchedId'],
        chatId: dataMap['chaitId'],
        docExists: dataMap['docExists'],
        stingrayImageUrl: dataMap['stingrayImageUrl'],
        stingrayId: dataMap['stingrayId'],
      );
    }).toList();
  }

  static List<UserLiked?> userLikedListFromDynamic(List<dynamic> mappedUsers) {
    List<UserLiked?> userList = [];
    for (Map<String, dynamic> user in mappedUsers) {
      userList.add(UserLiked(
        chatId: user['chatId'],
        name: user['name'],
        imageUrl: user['imageUrl'],
        userMatchId: user['userMatchedId'],
        docExists: user['docExists'],
        stingrayImageUrl: user['stingrayImageUrl'],
        stingrayId: user['stingrayId'],
      ));
    }
    return userList;
  }

  //static method that takes a query snapshot and returns a list of lists of userLiked
  static List<List<UserLiked?>> userLikedListFromQuerySnapshot(
      QuerySnapshot querySnapshot) {
    List<List<UserLiked?>> userList = [];
    for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;
      userList.add(UserLiked.userLikedListFromDynamic(dataMap['likes']));
    }
    return userList;
  }
}
