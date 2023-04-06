part of 'swipe_bloc.dart';

abstract class SwipeEvent extends Equatable {
  const SwipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends SwipeEvent {
  final String userId;

  LoadUsers({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class LoadTypesenseUsers extends SwipeEvent {
  
  final List<User> users;

  LoadTypesenseUsers({
    
    required this.users,
  });

  @override
  List<Object?> get props => [users];
}

class UpdateHome extends SwipeEvent {
  final List<User>? users;

  UpdateHome({
    required this.users,
  });

  @override
  List<Object?> get props => [
        users,
      ];
}

class SwipeLeft extends SwipeEvent {
  final User user;
  final String stingrayId;
  final User swiper;
  final BuildContext context;

  SwipeLeft({
    required this.user,
    required this.stingrayId,
    required this.swiper,
    required this.context,
  });

  @override
  List<Object?> get props => [user, stingrayId, swiper, context];
}

class SwipeRight extends SwipeEvent {
  final User user;
  final String? id;
  final String stingrayImageUrl;
  final String stingrayId;
  final BuildContext context;
  final User swiper;

  SwipeRight(
      {required this.user,
      this.id,
      required this.stingrayImageUrl,
      required this.stingrayId,
      required  this.context,
      required this.swiper
      });

  @override
  List<Object?> get props => [user, id, stingrayImageUrl, stingrayId, context, swiper];
}

class IncrementSwipeImageUrlIndex extends SwipeEvent {

  const IncrementSwipeImageUrlIndex();

  @override
  List<Object> get props => [];
}

class DecrementSwipeImageUrlIndex extends SwipeEvent {

  const DecrementSwipeImageUrlIndex();

  @override
  List<Object> get props => [];
}
