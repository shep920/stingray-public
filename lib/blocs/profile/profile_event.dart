part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}



class LoadDiscovery extends ProfileEvent {
  final BuildContext context;

  const LoadDiscovery({required this.context});

  @override
  List<Object> get props => [context];
}

class UpdateProfile extends ProfileEvent {
  final User user;

  const UpdateProfile({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteProfile extends ProfileEvent {
  final User user;

  const DeleteProfile({required this.user});

  @override
  List<Object> get props => [user];
}

class EditProfile extends ProfileEvent {
  final User editedUser;
  

  const EditProfile({required this.editedUser});

  @override
  List<Object> get props => [editedUser];
}

//close profile class
class CloseProfile extends ProfileEvent {
  const CloseProfile();

  @override
  List<Object> get props => [];
}

class ViewingTutorial extends ProfileEvent {
  const ViewingTutorial({required});

  @override
  List<Object> get props => [];
}

class CloseTutorial extends ProfileEvent {
  const CloseTutorial();

  @override
  List<Object> get props => [];
}

//make a blockUser class that takes in a user, blockUser
class BlockUserHandle extends ProfileEvent {
  final User user;
  final BuildContext context;

  const BlockUserHandle({
    required this.user,
    required this.context,
  });

  @override
  List<Object> get props => [user, context];
}

//unblock user class
class UnblockUserHandle extends ProfileEvent {
  final String blockedHandle;
  final BuildContext context;

  const UnblockUserHandle({
    required this.blockedHandle,
    required this.context,
  });

  @override
  List<Object> get props => [blockedHandle, context];
}


//updateBackpack class that takes a prize object
class UpdateBackpack extends ProfileEvent {
  final Prize prize;

  const UpdateBackpack({required this.prize});

  @override
  List<Object> get props => [prize];
}

//dropStingray event, no arguments
class DropStingray extends ProfileEvent {
  const DropStingray();

  @override
  List<Object> get props => [];
}