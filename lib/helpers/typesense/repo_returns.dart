import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';

class TSRepoReturns {
  static List<User> returnUsers(Map<String, dynamic> doc) {
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    return hits;
  }

  static List<Wave> returnWaves(Map<String, dynamic> doc) {
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => Wave.waveFromTypesenseDoc(e))
        .toList();

    return hits;
  }
}
