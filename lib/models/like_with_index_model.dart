import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';

import 'chat_model.dart';

class UserLikedWithIndex extends Equatable {
  final int stingrayIndex;
  final UserLiked? userLiked;

  UserLikedWithIndex({
    required this.stingrayIndex,
    required this.userLiked,
  });

  @override
  List<Object?> get props => [stingrayIndex, userLiked];
}
