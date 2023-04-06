import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class UserSearchable extends Equatable {
  final String? id;
  final String name;
  final List<dynamic> imageUrls;

  UserSearchable(
      {required this.id, required this.name, required this.imageUrls});

  @override
  List<Object?> get props => [id, name, imageUrls];

  static Map<String, dynamic> toJson(User? userLiked) => {
        'id': userLiked?.id,
        'name': userLiked?.name,
        'imageUrls': userLiked?.imageUrls[0],
      };

  List<UserSearchable?> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return UserSearchable(
        name: dataMap['name'],
        imageUrls: dataMap['imageUrls'],
        id: dataMap['id'],
      );
    }).toList();
  }
}
