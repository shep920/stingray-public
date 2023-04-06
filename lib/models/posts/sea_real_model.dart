import 'package:hero/models/posts/post_model.dart';

class SeaReal extends Post {
  final String frontImageUrl;
  final String backImageUrl;

  final int likes;
  final int comments;
  final List<dynamic> likedBy;

  final int popularity;

  SeaReal({
    required String id,
    required String senderId,
    required DateTime createdAt,
    required this.frontImageUrl,
    required this.backImageUrl,
    required this.likes,
    required this.comments,
    required this.likedBy,
    required this.popularity,
  }) : super(id: id, senderId: senderId, createdAt: createdAt);

  @override
  List<Object> get props => [
        id,
        senderId,
        createdAt,
        likes,
        comments,
        likedBy,
        popularity,
        frontImageUrl,
        backImageUrl
      ];
}
