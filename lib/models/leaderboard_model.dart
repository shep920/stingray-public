import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class LeaderboardUser extends Equatable {
  final String? id;
  final String name;
  final String handle;
  final int votes;
  final String imageUrl;

  LeaderboardUser(
      {required this.id,
      required this.name,
      required this.handle,
      required this.votes,
      required this.imageUrl});

  @override
  List<Object?> get props => [id, name, imageUrl, handle, votes];

  static Map<String, dynamic> toJson(User? user) => {
        'id': user?.id,
        'name': user?.name,
        'imageUrl': user?.imageUrls[0],
        'handle': user?.handle,
        'votes': user?.votes,
      };

  static Map<String, dynamic> leaderboardUsertoJson(LeaderboardUser? user) => {
        'id': user?.id,
        'name': user?.name,
        'imageUrl': user?.imageUrl,
        'handle': user?.handle,
        'votes': user?.votes,
      };

  static List<Map<String, dynamic>> leaderboardToJson(
      List<LeaderboardUser?> leaderboard) {
    List<Map<String, dynamic>> leaderboardJson = [];
    for (LeaderboardUser? leaderboardUser in leaderboard) {
      leaderboardJson
          .add(LeaderboardUser.leaderboardUsertoJson(leaderboardUser));
    }
    return leaderboardJson;
  }

  static LeaderboardUser leaderboardUserFromMap(dynamic leaderboardUser) {
    return LeaderboardUser(
      id: leaderboardUser['id'],
      name: leaderboardUser['name'],
      handle: leaderboardUser['handle'],
      votes: leaderboardUser['votes'],
      imageUrl: leaderboardUser['imageUrl'],
    );
  }

  static List<LeaderboardUser?> leaderboardUserListFromMap(
      dynamic mappedLeaderboardUsers) {
    List<LeaderboardUser> leaderboardUserList = [];
    for (Map<String, dynamic> leaderboardUser in mappedLeaderboardUsers) {
      leaderboardUserList
          .add(LeaderboardUser.leaderboardUserFromMap(leaderboardUser));
    }
    return leaderboardUserList;
  }

  static LeaderboardUser? generateLeaderboardUser(User user) {
    return LeaderboardUser(
      id: user.id,
      name: user.name,
      handle: user.handle,
      votes: user.votes,
      imageUrl: user.imageUrls[0],
    );
  }
}
