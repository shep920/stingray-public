part of 'discovery_chat_pending_bloc.dart';

abstract class DiscoveryChatPendingState extends Equatable {
  const DiscoveryChatPendingState();

  @override
  List<Object?> get props => [];
}

class DiscoveryChatPendingLoading extends DiscoveryChatPendingState {}

class DiscoveryChatPendingLoaded extends DiscoveryChatPendingState {
  

  final List<DiscoveryChat?> pending;
  
  final bool pendingLoading;
  final bool pendingHasMore;
  final DocumentSnapshot? lastPendingDoc;

  
  final List<User?> userPool;

  const DiscoveryChatPendingLoaded(
      {
      
      required this.pending,
      
      required this.pendingLoading,
      required this.pendingHasMore,
      
      
      
      
      
      
      required this.userPool,
      required this.lastPendingDoc,
      });

  @override
  List<Object?> get props => [
       
        
        pending,
        
       
        
        pendingLoading,
        pendingHasMore,
       
        userPool,
        lastPendingDoc,
       

      ];

  DiscoveryChatPendingLoaded copyWith({
    
    
    List<DiscoveryChat?>? pending,
    bool? pendingLoading,
    bool? pendingHasMore,
    DocumentSnapshot? pendingLastDoc,


    

    List<User?>? userPool,
  }) {
    return DiscoveryChatPendingLoaded(
      
      
      pending: pending ?? this.pending,
      
      pendingLoading: pendingLoading ?? this.pendingLoading,
      pendingHasMore: pendingHasMore ?? this.pendingHasMore,
      
      
      
      userPool: userPool ?? this.userPool,
      lastPendingDoc: pendingLastDoc ?? this.lastPendingDoc,
      


    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

