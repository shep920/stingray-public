part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  

  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  SearchInitial()
      : super();
}

class QueryLoaded extends SearchState {
  final List<User>? discoverableUsers;
  final Client client;
  final String query;
  final List<User?> users;
  

  QueryLoaded(
      {required this.discoverableUsers, required this.client, required this.query, required this.users})
      : super();

      //make a copywith method
  QueryLoaded copyWith({
    List<User>? discoverableUsers,
    Client? client,
    String? query,
    List<User?>? users,
  }) {
    return QueryLoaded(
      discoverableUsers: discoverableUsers ?? this.discoverableUsers,
      client: client ?? this.client,
      query: query ?? this.query,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [discoverableUsers, client, query, users];
}
