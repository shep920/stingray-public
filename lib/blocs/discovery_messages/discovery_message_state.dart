part of 'discovery_message_bloc.dart';

abstract class DiscoveryMessageState extends Equatable {
  const DiscoveryMessageState();

  @override
  List<Object?> get props => [];
}

class DiscoveryMessageLoading extends DiscoveryMessageState {}

class DiscoveryMessageLoaded extends DiscoveryMessageState {
  final DiscoveryMessageDocument? discoveryMessageDocument;
  final User matchedUser;
  final List<DiscoveryMessage?> discoveryMessages;
  

  const DiscoveryMessageLoaded(
      {required this.discoveryMessageDocument,
      required this.matchedUser,
      required this.discoveryMessages,
      });

  @override
  List<Object?> get props => [
        matchedUser,
        discoveryMessageDocument,
        discoveryMessages,
        
      ];


      //make a copywith
      DiscoveryMessageLoaded copyWith({
        DiscoveryMessageDocument? discoveryMessageDocument,
        User? matchedUser,
        List<DiscoveryMessage?>? discoveryMessages,
        
      }) {
        return DiscoveryMessageLoaded(
          discoveryMessageDocument: discoveryMessageDocument ?? this.discoveryMessageDocument,
          matchedUser: matchedUser ?? this.matchedUser,
          discoveryMessages: discoveryMessages ?? this.discoveryMessages,
          
        );
      }
}
