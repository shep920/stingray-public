part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchUsers extends SearchEvent {
  final String query;
  final User? searcher;
  final int limit;

  SearchUsers({
    required this.query,
    required this.searcher,
    required this.limit,
  });

  @override
  List<Object?> get props => [query, searcher, limit];
}

class QueryDiscoverableUsers extends SearchEvent {
  final List<dynamic> seenIds;
  final String userId;
  final BuildContext context;
  final User user;

  QueryDiscoverableUsers(
      {required this.seenIds,
      required this.userId,
      required this.context,
      required this.user});

  @override
  List<Object> get props => [seenIds, userId, context, user];
}

class QuerySwipeUsers extends SearchEvent {
  final BuildContext context;
  final User user;

  QuerySwipeUsers({required this.context, required this.user});

  @override
  List<Object> get props => [context, user];
}

class ReloadSwipeUsers extends SearchEvent {
  final User swiper;
  final List<User> users;
  final BuildContext context;
  final String removedUserId;
  final String remainingUserId;

  ReloadSwipeUsers(
      {required this.swiper,
      required this.context,
      required this.users,
      required this.removedUserId,
      required this.remainingUserId});

  @override
  List<Object> get props =>
      [swiper, context, users, removedUserId, remainingUserId];
}

class LoadInitialWaves extends SearchEvent {
  final List<Stingray?> stingrays;
  final BuildContext context;

  LoadInitialWaves({required this.stingrays, required this.context});

  @override
  List<Object> get props => [stingrays, context];
}

class RefreshStingrayWavesSearch extends SearchEvent {
  final Stingray? stingray;
  final BuildContext context;

  RefreshStingrayWavesSearch({required this.context, required this.stingray});

  @override
  List<Object> get props => [context];
}

class PaginateUsers extends SearchEvent {
  final Stingray stingray;

  final BuildContext context;

  PaginateUsers({
    required this.context,
    required this.stingray,
  });

  @override
  List<Object> get props => [context, stingray];
}

class InitializeClient extends SearchEvent {
  InitializeClient();

  @override
  List<Object> get props => [];
}
