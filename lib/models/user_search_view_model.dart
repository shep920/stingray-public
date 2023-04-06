import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class UserSearchView extends Equatable {
  final String? id;
  final String name;
  final String handle;
  final int votes;
  final List<dynamic> imageUrls;

  UserSearchView(
      {required this.id, required this.name,
      required this.handle, required this.votes,
       required this.imageUrls});

  @override
  List<Object?> get props => [id, name, imageUrls, handle, votes];

  static Map<String, dynamic> toJson(User? userLiked) => {
        'id': userLiked?.id,
        'name': userLiked?.name,
        'imageUrls': userLiked?.imageUrls[0],
        'handle': userLiked?.handle,
        'votes': userLiked?.votes,
      };

  List<UserSearchView?> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return UserSearchView(

        name: dataMap['name'],
        imageUrls: dataMap['imageUrls'],
        id: dataMap['id'],
        handle: dataMap['handle'],
        votes: dataMap['votes'],
      );
    }).toList();
  }
}
