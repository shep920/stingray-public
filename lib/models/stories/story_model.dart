
import 'package:equatable/equatable.dart';


class Story extends Equatable {
  final String imageUrl;
  final DateTime postedAt;
  final String posterId;
  final String id;

  Story({
    required this.imageUrl,
    required this.postedAt,
    required this.posterId,
    required this.id,
  });

  @override
  List<Object?> get props => [
        imageUrl,
        postedAt,
        posterId,
        id,
      ];

  static Story storyFromString(String storyString) {
    String id = storyString.split('#')[3];
    String imageUrl = storyString.split('#')[2];
    String dateString = storyString.split('#')[1];
    String posterId = storyString.split('#')[0];

    //convert dateString to DateTime
    DateTime postedAt = DateTime.parse(dateString);

    return Story(
        imageUrl: imageUrl, postedAt: postedAt, posterId: posterId, id: id);
  }

  //story to string
  String storyToString() {
    return '$posterId#$postedAt#$imageUrl#$id';
  }
}
