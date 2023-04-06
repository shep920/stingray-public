//make a class, TypesenseRepository
//
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/helpers/typesense/repo_returns.dart';
import 'package:hero/helpers/typesense/static_strings.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:typesense/typesense.dart';

import '../blocs/typesense/bloc/search_bloc.dart';
import '../models/discovery_chat_model.dart';
import '../models/user_model.dart';
import '../models/posts/wave_model.dart';

class TypesenseRepository {
  final Client tsClient = Client(
    Configuration(
      '9rHIq6T6IPos3KZwhWtUNFbAhS8NqKZb',
      nodes: {
        Node(Protocol.https, , port: 443)
      },
      numRetries: 3,
    ),
  );

  Future<List<DiscoveryChat?>> getDiscoveryChats(String userId) async {
    final List<DiscoveryChat?> _chats = [];
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '10',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by':
              '(senderId:$userId || receiverId:$userId) && pending:false',
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<User?>> getDiscoveryChatUsers(
      Client client, String userId, List<String> chatIds) async {
    String allIds = '';

    for (String chatId in chatIds) {
      //if chatId is not the last element in the list, add ' || '
      if (chatId != chatIds.last) {
        allIds += 'typsenseId:$chatId || ';
      } else {
        //if chatId is the last element in the list, do not add ' || '
        allIds += 'typsenseId:$chatId';
      }
    }

    if (allIds == '') {
      return [];
    }

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '10',
          'sort_by': '',
          'filter_by': '($allIds)'
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    //if there are no results, return an empty list

    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<DiscoveryChat?>> getPendingDiscoveryChats(
      String userId, Client client) async {
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '10',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by': 'senderId:$userId && pending:true',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<User?>> getChatUsers(String userId, List<String> chatIds) async {
    String allIds = '';
    //for each chatId, add it to a string that follows the form 'typsenseId:chatId || '

    for (String chatId in chatIds) {
      //if chatId is not the last element in the list, add ' || '
      if (chatId != chatIds.last) {
        allIds += 'typsenseId:$chatId || ';
      } else {
        //if chatId is the last element in the list, do not add ' || '
        allIds += 'typsenseId:$chatId';
      }

      //add to string
    }

    if (allIds == '') {
      return [];
    }

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '10',
          'sort_by': '',
          'filter_by': '$allIds',
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<DiscoveryChat?>> paginatePendingDiscoveryChats(
      String userId, Client client, List<String> ignoreIds) async {
    String ignore = '';
    //for each chatId, add it to a string that follows the form 'typsenseId:chatId || '
    for (String chatId in ignoreIds) {
      //if chatId is not the last element in the list, add ' || '
      if (chatId != ignoreIds.last) {
        ignore += 'chatId:!=$chatId && ';
      } else {
        //if chatId is the last element in the list, do not add ' || '
        ignore += 'chatId:!=$chatId';
      }
    }
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '10',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by': 'senderId:$userId && pending:true && ($ignore)',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<DiscoveryChat?>> paginateJudgeableDiscoveryChats(
      String userId, Client client, List<String> ignoreIds) async {
    String ignore = '';
    //for each chatId, add it to a string that follows the form 'typsenseId:chatId || '
    for (String chatId in ignoreIds) {
      //if chatId is not the last element in the list, add ' || '
      if (chatId != ignoreIds.last) {
        ignore += 'chatId:!=$chatId && ';
      } else {
        //if chatId is the last element in the list, do not add ' || '
        ignore += 'chatId:!=$chatId';
      }
    }
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '10',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by': 'judgeId:$userId && pending:true && ($ignore)',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<User?>> paginateUsers(
      Client client, String userId, List<String> userIds) async {
    String allIds = '';

    for (String userId in userIds) {
      if (userId != userIds.last) {
        allIds += 'typsenseId:$userId || ';
      } else {
        allIds += 'typsenseId:$userId';
      }
    }

    if (allIds == '') {
      return [];
    }

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '10',
          'sort_by': '',
          'filter_by': '$allIds',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<DiscoveryChat?>> paginateDiscoveryChats(
      String userId, Client client, List<String> ignoreIds) async {
    String ignore = '';
    //for each chatId, add it to a string that follows the form 'typsenseId:chatId || '
    for (String chatId in ignoreIds) {
      //if chatId is not the last element in the list, add ' || '
      if (chatId != ignoreIds.last) {
        ignore += 'chatId:!=$chatId && ';
      } else {
        //if chatId is the last element in the list, do not add ' || '
        ignore += 'chatId:!=$chatId';
      }
    }
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '10',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by':
              '(senderId:$userId || receiverId:$userId) && pending:false && ($ignore)',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<User?>> paginateDiscoveryChatUsers(
      Client client, String userId, List<String> chatIds) async {
    String allIds = '';
    //for each chatId, add it to a string that follows the form 'typsenseId:chatId || '

    for (String chatId in chatIds) {
      //if chatId is not the last element in the list, add ' || '
      if (chatId != chatIds.last) {
        allIds += 'typsenseId:$chatId || ';
      } else {
        //if chatId is the last element in the list, do not add ' || '
        allIds += 'typsenseId:$chatId';
      }

      //add to string
    }

    if (allIds == '') {
      return [];
    }

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '10',
          'sort_by': '',
          'filter_by': '$allIds',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<DiscoveryChat?>> getJudgeableDiscoveryChats(
      Client client, String userId) async {
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '10',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by': 'pending:true && judgeId:$userId',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<DiscoveryChat>> getTestChat(Client client, String userId) async {
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '1',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by':
              '(senderId:$userId || receiverId:$userId) && pending:false',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  //get test judgable chat
  Future<List<DiscoveryChat>> getTestJudgableChat(
      Client client, String userId) async {
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '1',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by': 'pending:true && judgeId:$userId',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  //get test pending chat
  Future<List<DiscoveryChat>> getTestPendingChat(
      Client client, String userId) async {
    final search = {
      'searches': [
        {
          'collection': 'discoveryChats',
          'q': '*',
          'query_by': 'lastMessageSent',
          'page': '1',
          'per_page': '1',
          'sort_by': 'lastMessageSentDateTime:desc',
          'filter_by': 'pending:true && senderId:$userId',
        }
      ]
    };

    final doc = await client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) =>
            DiscoveryChat.discoveryChatFromTypesenseDoc(e['document'] as Map))
        .toList();

    return hits;
  }

  Future<List<User?>?> searchUsers(
      String query, Client client, String exclude, int limit) async {
    final doc = await client.collection('users').documents.search({
      'q': query,
      'query_by':
          'handle, name, fraternity, postGrad, intramuralSport,thirdUndergrad,secondUndergrad,firstUndergrad,firstStudentOrg ,secondStudentOrg,thirdStudentOrg, worstDorm, assosiatedDorm, favoriteSpot, favoriteBar',
      'page': '1',
      'per_page': '${limit.toString()}',
      'sort_by': 'votes:desc',
      'filter_by': '$exclude',
    });
    final hits = (doc['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<User?>> getLeaderboardUsers(User user) async {
    String ignore = StaticTSStrings.setBlockedUsers(user);

    String filter = '';

    if (ignore.isNotEmpty) {
      filter += '($ignore) &&';
    }

    filter += 'finishedOnboarding:true && votes:>0';

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '5',
          'sort_by': 'votes:desc',
          'filter_by': filter,
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    //if there are no results, return an empty list

    List<User?> hits = TSRepoReturns.returnUsers(doc);

    return hits;
  }

  Future<List<User?>> getSimilarPups(
      {required User user, List<User?>? loaded}) async {
    String ignore = StaticTSStrings.setBlockedUsers(user);
    String similar = StaticTSStrings.setSimilarUsers(user);
    String loadedUsers = StaticTSStrings.setIgnoreUsers(loaded);

    String filterString = '';

    // filterString =
    //     '$loadedUsers ($ignore) && ($similar) && typsenseId:!=${user.id} && finishedOnboarding:true';

    if (ignore.isNotEmpty) {
      filterString += '$ignore && ';
    }
    if (similar.isNotEmpty) {
      filterString += '($similar) && ';
    }
    if (loadedUsers.isNotEmpty) {
      filterString += '$loadedUsers && ';
    }
    filterString += '(finishedOnboarding:true && typsenseId:!=${user.id})';
    //if 16m1SP25UQSoMDxRj9bhtbFmkfv2 is not in loaded, then add isRude:true to filter
    if (!loadedUsers.contains('16m1SP25UQSoMDxRj9bhtbFmkfv2')) {
      filterString += ' && isRude:true';
    }

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '20',
          'sort_by': 'votes:desc',
          'filter_by': filterString
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    //if there are no results, return an empty list

    List<User?> hits = TSRepoReturns.returnUsers(doc);

    return hits;
  }

  Future<List<User?>> getNonsimilarPups(
      {required User user, List<User?>? loaded}) async {
    String ignore = StaticTSStrings.setBlockedUsers(user);
    String loadedUsers = StaticTSStrings.setIgnoreUsers(loaded);

    String filterString = '';

    if (ignore.isNotEmpty) {
      filterString += '$ignore && ';
    }

    if (loadedUsers.isNotEmpty) {
      filterString += '$loadedUsers && ';
    }
    filterString += 'finishedOnboarding:true && typsenseId:!=${user.id}';

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '20',
          'sort_by': 'votes:desc',
          'filter_by': filterString
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    //if there are no results, return an empty list

    List<User?> hits = TSRepoReturns.returnUsers(doc);

    return hits;
  }

  Future<List<User?>> getSuperPups(User user) async {
    String ignore = StaticTSStrings.setBlockedUsers(user);

    String filterString = '';
    if (ignore.isNotEmpty) {
      filterString += '($ignore) && ';
    }
    filterString += 'finishedOnboarding:true && isPup:true';

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '5',
          'sort_by': 'votes:desc',
          'filter_by': filterString,
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    //if there are no results, return an empty list

    List<User?> hits = TSRepoReturns.returnUsers(doc);

    return hits;
  }

  Future<List<Wave?>> getWaveReplies(
      User user, List<Wave> waves, Wave replyingTo) async {
    String ignore = 'typesenseId:!=[';

    for (Wave wave in waves) {
      if (wave == waves.last) {
        ignore += '${wave.id}]';
      } else {
        ignore += '${wave.id},';
      }
    }

    List<dynamic> blocks = user.blockedUserIds + user.blockedBy;
    //create a string of blocks
    String ignoreUsers = 'senderId:!=[';

    if (blocks != []) {
      for (String block in blocks) {
        //add block in the form 'block,'. If it is the last block, do 'block]'
        if (block == blocks.last) {
          ignoreUsers += '$block]';
        } else {
          ignoreUsers += '$block,';
        }
      }
    }

    final search = {
      'searches': [
        {
          'collection': 'waves',
          'q': '*',
          'query_by': 'message',
          'page': '1',
          'per_page': '5',
          'sort_by': 'popularity:desc',
          'filter_by': '($ignore) && $ignoreUsers && replyTo:${replyingTo.id}'
        }
      ]
    };

    //perform the search
    final doc = await tsClient.multiSearch.perform(search);

    //transform the results into a list of waves
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => Wave.waveFromTypesenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<Wave?>> getWaveReplySquared(User user, Wave replyingTo) async {
    List<dynamic> blocks = user.blockedUserIds + user.blockedBy;
    //create a string of blocks
    String ignoreUsers = 'senderId:!=[';

    for (String block in blocks) {
      //add block in the form 'block,'. If it is the last block, do 'block]'
      if (block == blocks.last) {
        ignoreUsers += '$block]';
      } else {
        ignoreUsers += '$block,';
      }
    }

    final search = {
      'searches': [
        {
          'collection': 'waves',
          'q': '*',
          'query_by': 'message',
          'page': '1',
          'per_page': '1',
          'sort_by': 'popularity:desc',
          'filter_by': '$ignoreUsers && replyTo:${replyingTo.id}'
        }
      ]
    };

    //perform the search
    final doc = await tsClient.multiSearch.perform(search);

    //transform the results into a list of waves
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => Wave.waveFromTypesenseDoc(e))
        .toList();

    return hits;
  }

  Future<List<User?>> getUsersFromWaves(
      {required List<String> posterIds}) async {
    String allIds = '';

    for (int i = 0; i < posterIds.length; i++) {
      //if the id is not the first id, add &&
      if (i != 0) {
        allIds += ' || ';
      }
      allIds += 'typsenseId:== ${posterIds[i]}';
    }

    //set a string as waves length
    String wavesLength = posterIds.length.toString();

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '$wavesLength',
          'sort_by': '_eval(isRude:true):desc, votes:desc, randomInt:desc',
          'filter_by': '$allIds',
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);
    //if there are no results, return an empty list

    List<User?> hits = TSRepoReturns.returnUsers(doc);

    return hits;
  }

  Future<List<Wave?>> getFeaturedWaves({
    required List<Wave?> waves,
    required List<Stingray?> stingrays,
    required String sortType,
  }) async {
    String ignore = '';

    //remove the stingray with id 'featured' from the stingrays list
    stingrays.removeWhere((element) => element!.id == 'featured');

    if (waves.isNotEmpty) {
      ignore = '(typesenseId:!=[';

      for (Wave? wave in waves) {
        if (wave == waves.last) {
          ignore += '${wave!.id}]) &&';
        } else {
          ignore += '${wave!.id},';
        }
      }
    }

    String stingrayIds = (stingrays.isEmpty) ? '' : '(';

    // Make it such that for each stingray, make it stringrayIds + stingray.id ||. If it is the last stingray, do stingrayIds + stingray.id] &&
    for (Stingray? stingray in stingrays) {
      if (stingray == stingrays.last) {
        stingrayIds += 'senderId: ${stingray!.id}) &&';
      } else {
        stingrayIds += 'senderId: ${stingray!.id} || ';
      }
    }

    String filter = '$ignore $stingrayIds replyTo:null && type:default';

    String _sortParam =
        (sortType == TsKeywords.newParam) ? 'createdAt:desc' : 'likes:desc';

    if (sortType == TsKeywords.hotParam) {
      final now = DateTime.now();
      final yesterday = now.subtract(Duration(days: 1));
      final startOfYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day);
      final endOfYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);

      final startUnix = startOfYesterday.millisecondsSinceEpoch ~/ 1000;
      final endUnix = endOfYesterday.millisecondsSinceEpoch ~/ 1000;

      String _time = '&& createdAt:>=$startUnix && createdAt:<=$endUnix';
      filter += _time;
    }

    final search = {
      'searches': [
        {
          'collection': 'waves',
          'q': '*',
          'query_by': 'message',
          'page': '1',
          'per_page': '15',
          'sort_by': _sortParam,
          'filter_by': filter,
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);

    List<Wave> hits = TSRepoReturns.returnWaves(doc);

    return hits;
  }

  Future<List<Wave?>> getVideoWaves({
    required List<String> waveIds,
    required User user,
  }) async {
    String blocked = StaticTSStrings.setBlockedWaveUsers(user);
    String ignore = StaticTSStrings.ignoreWaves(waveIds);

    String filter =
        '$ignore replyTo:null && videoUrl:!=noVideo && videoUrl:!=null';

    String fullFilter = blocked + filter;

    final search = {
      'searches': [
        {
          'collection': 'waves',
          'q': '*',
          'query_by': 'message',
          'page': '1',
          'per_page': '5',
          'sort_by': 'popularity:desc',
          'filter_by': fullFilter,
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);

    List<Wave> hits = TSRepoReturns.returnWaves(doc);

    return hits;
  }

  Future<List<Wave?>> getSeaReals({
    required List<String> waveIds,
    required User user,
  }) async {
    String blocked = StaticTSStrings.setBlockedWaveUsers(user);
    String ignore = StaticTSStrings.ignoreWaves(waveIds);

    String filter = '$ignore replyTo:null && style:${Wave.seaRealStyle} ';

    String fullFilter = blocked + filter;

    final search = {
      'searches': [
        {
          'collection': 'waves',
          'q': '*',
          'query_by': 'message',
          'page': '1',
          'per_page': '5',
          'sort_by': 'popularity:desc',
          'filter_by': fullFilter,
        }
      ]
    };

    final doc = await tsClient.multiSearch.perform(search);

    List<Wave> hits = TSRepoReturns.returnWaves(doc);

    return hits;
  }
}

class TsKeywords {
  static String newParam = 'new';
  static String hotParam = 'hot';
}
