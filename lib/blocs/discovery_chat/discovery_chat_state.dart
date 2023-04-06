part of 'discovery_chat_bloc.dart';

abstract class DiscoveryChatState extends Equatable {
  const DiscoveryChatState();

  @override
  List<Object?> get props => [];
}

class DiscoveryChatLoading extends DiscoveryChatState {}

class DiscoveryChatLoaded extends DiscoveryChatState {
  final List<DiscoveryChat?> chats;
  
  final bool chatLoading;
  final bool chatHasMore;

  

  

  final List<User?> userPool;

  const DiscoveryChatLoaded(
      {required this.chats,
      
      
      
      
      required this.chatLoading,
      required this.chatHasMore,
      
      required this.userPool,
      
      });

  @override
  List<Object?> get props => [
        chats,
        
      
        
        
        
      
        chatLoading,
        chatHasMore,

        
        userPool,
      
        

      ];

  DiscoveryChatLoaded copyWith({
    List<DiscoveryChat?>? chats,
    
    


    List<DiscoveryChat?>? judgeableChats,
    bool? chatLoading,
    bool? chatHasMore,
    
    

    List<User?>? userPool,
  }) {
    return DiscoveryChatLoaded(
      chats: chats ?? this.chats,
      
      
      
      
    
      
      chatLoading: chatLoading ?? this.chatLoading,
      chatHasMore: chatHasMore ?? this.chatHasMore,
    
      userPool: userPool ?? this.userPool,
      
    


    );
  }

  @override
  bool get stringify => true;
}

//make a copyWith method to make it easier to update the state
 

