import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/swipe/swipe_bloc.dart' as swipe;
import 'package:hero/models/stingray_model.dart';
import 'package:hero/screens/onboarding/onboarding_screens/birthDate_screen.dart';
import 'package:typesense/typesense.dart';

import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../../../models/user_search_view_model.dart';
import '../../../models/user_searchable.dart';
import '../../../models/waves_meta_model.dart';
import '../../../models/posts/wave_model.dart';
import '../../../repository/typesense_repo.dart';
import '../../user discovery swiping/user_discovery_bloc.dart';
import '../../wave/wave_bloc.dart' as wave;
import '../../wave/wave_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TypesenseRepository _typesenseRepository;
  SearchBloc({required TypesenseRepository typesenseRepository})
      : _typesenseRepository = typesenseRepository,
        super(QueryLoaded(
          query: '',
          users: [],
          client: Client(
            Configuration(
              '9rHIq6T6IPos3KZwhWtUNFbAhS8NqKZb',
              nodes: {
                Node(Protocol.https, ,
                    port: 443)
              },
              numRetries: 3,
            ),
          ),
          discoverableUsers: [],
        )) {
    on<SearchUsers>(_searchUsers);

    on<QueryDiscoverableUsers>(_queryDiscoverableUsers);
    on<QuerySwipeUsers>(_querySwipeUsers);
    on<ReloadSwipeUsers>(_reloadSwipeUsers);
    
    on<RefreshStingrayWavesSearch>(_refreshStingrayWaves);
    on<PaginateUsers>(_paginateUsers);
    on<InitializeClient>(_initializeClient);
  }

  void _initializeClient(
    InitializeClient event,
    Emitter<SearchState> emit,
  ) {
    if (this.state is SearchInitial) {
      final state = this.state as SearchInitial;
    }

    if (this.state is QueryLoaded) {
      final state = this.state as QueryLoaded;
    }
  }

  Future<void> _searchUsers(
    SearchUsers event,
    Emitter<SearchState> emit,
  ) async {
    final state = this.state as QueryLoaded;

    String exclude = '';
    //if event.user is not null, and user.blockedUsers is not empty, and user.blockedBy is not empty, add those values to the string
    exclude = makeBlockedExclusionString(event, exclude);

    final hits = await _typesenseRepository.searchUsers(
        event.query, state.client, exclude, event.limit);

    emit(state.copyWith(users: hits, query: event.query));
  }

  String makeBlockedExclusionString(SearchUsers event, String exclude) {
    if (event.searcher != null) {
      if (event.searcher!.blockedBy.isNotEmpty) {
        //for each blockedBy value, add it to the string in the following format: 'typsenseId:!blockedByValue &&' and if it is the last value, add 'typsenseId:!blockedByValue'
        exclude += event.searcher!.blockedBy
            .map((uid) => 'typsenseId:!=$uid')
            .join(' && ');
      }
      if (event.searcher!.blockedUsers.isNotEmpty) {
        //for each blockedUsers value, add it to the string in the following format: 'typsenseId:!blockedUsersValue &&' and if it is the last value, add 'typsenseId:!blockedUsersValue'
        exclude += event.searcher!.blockedUsers
            .map((handle) => 'handle:!=$handle')
            .join(' && ');
      }
      //if the string is not empty, add ' && onboardingFinished:true' to the end of the string. else, add 'onboardingFinished:true'
      exclude = exclude.isNotEmpty
          ? exclude + ' && finishedOnboarding:true'
          : 'finishedOnboarding:true';
    }
    return exclude;
  }

  void _queryDiscoverableUsers(
      QueryDiscoverableUsers event, Emitter<SearchState> emit) async {
    final state = this.state as QueryLoaded;
    final doc = await state.client.collection('users').documents.search({
      'q': '*',
      'query_by': 'name',
      'page': '1',
      'per_page': '${event.user.discoveriesRemaning}',
      'sort_by': '_eval(isRude:true):desc, votes:desc, randomInt:desc',
      'filter_by':
          'typsenseId:!=[${event.seenIds}] && finishedOnboarding:true && typsenseId:!=${event.user.id}',
    });

    final hits = (doc['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    BlocProvider.of<UserDiscoveryBloc>(event.context)
        .add(LoadUsers(users: hits));

    emit(QueryLoaded(
        users: state.users,
        query: state.query,
        discoverableUsers: hits,
        client: state.client));
  }

  void _querySwipeUsers(
      QuerySwipeUsers event, Emitter<SearchState> emit) async {
    final state = this.state as QueryLoaded;
    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '10',
          'sort_by': '_eval(isRude:true):desc, votes:desc, randomInt:desc',
          'filter_by':
              'finishedOnboarding:true && wantsToTalk:true && typsenseId:!=${event.user.id} && stingrays:== ${event.user.id}',
        }
      ]
    };

    final doc = await state.client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    BlocProvider.of<swipe.SwipeBloc>(event.context)
        .add(swipe.LoadTypesenseUsers(users: hits));
  }

  void _reloadSwipeUsers(
      ReloadSwipeUsers event, Emitter<SearchState> emit) async {
    final state = this.state as QueryLoaded;
    //map the ids of the users from the event into a list of strings

    final search = {
      'searches': [
        {
          'collection': 'users',
          'q': '*',
          'query_by': 'name',
          'page': '1',
          'per_page': '10',
          'sort_by': '_eval(isRude:true):desc, votes:desc, randomInt:desc',
          'filter_by':
              'finishedOnboarding:true && wantsToTalk:true && typsenseId:!=${event.swiper.id} && stingrays:== ${event.swiper.id} && typsenseId:!=[${event.removedUserId}] && typsenseId:!=[${event.remainingUserId}]'
        }
      ]
    };

    final doc = await state.client.multiSearch.perform(search);
    List<dynamic> results = doc['results'] as List<dynamic>;
    Map result = results[0] as Map;

    final hits = (result['hits'] as List)
        .cast<Map>()
        .map((e) => User.userFromTypsenseDoc(e))
        .toList();

    final users = event.users;
    final newUsers = users.addAll(hits);

    BlocProvider.of<swipe.SwipeBloc>(event.context)
        .add(swipe.LoadTypesenseUsers(users: users));
  }

  
  void _refreshStingrayWaves(
      RefreshStingrayWavesSearch event, Emitter<SearchState> emit) async {
    final state = this.state as QueryLoaded;
    //map the ids of the users from the event into a list of strings

    //for each stingray in event.stingrays, add a stingray:== stingray.id to the filter_by
    //
  }

  void _paginateUsers(PaginateUsers event, Emitter<SearchState> emit) async {
    final state = this.state as QueryLoaded;
    //map the ids of the users from the event into a list of strings

    //for each stingray in event.stingrays, add a stingray:== stingray.id to the filter_by
    // WavesMeta? wavesList = null;

    // final waveState = BlocProvider.of<WaveBloc>(event.context, listen: false)
    //     .state as WaveLoaded;
    // final WavesMeta wavesMeta = waveState.wavesMeta
    //     .firstWhere((element) => element.stingray.id == event.stingray.id);
    // List<String> waveIds = wavesMeta.waves.map((e) => e!.id).toList();

    // final stingray = event.stingray;
    // String nullString = 'null';

    // final search = {
    //   'searches': [
    //     {
    //       'collection': 'waves',
    //       'q': '*',
    //       'query_by': 'message',
    //       'page': '1',
    //       'per_page': '5',
    //       'sort_by': 'createdAt:desc',
    //       'filter_by':
    //           'senderId:==${stingray.id} && typesenseId:!=[${waveIds}] && replyTo:==$nullString'
    //     }
    //   ]
    // };
    // final doc = await state.client.multiSearch.perform(search);
    // List<Wave?> results =
    //     (((doc['results'] as List<dynamic>)[0])['hits'] as List)
    //         .cast<Map>()
    //         .map((e) => Wave.waveFromTypesenseDoc(e))
    //         .toList();

    // bool hasMore = (results.length < 5) ? false : true;

    // wavesList = WavesMeta(stingray: stingray, waves: results, hasMore: hasMore);

    // BlocProvider.of<wave.WaveBloc>(event.context)
    //     .add(wave.PaginateWaves(waves: wavesList, stingray: stingray));
  }
}
