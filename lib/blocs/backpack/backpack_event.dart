part of 'backpack_bloc.dart';

abstract class BackpackEvent extends Equatable {
  const BackpackEvent();

  @override
  List<Object?> get props => [];
}

class LoadBackpack extends BackpackEvent {
  final String id;

  const LoadBackpack({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateBackpack extends BackpackEvent {
  final List<BackpackItem> backpack;

  const UpdateBackpack({required this.backpack});

  @override
  List<Object> get props => [backpack];
}


class CloseBackpack extends BackpackEvent {
  const CloseBackpack();

  @override
  List<Object> get props => [];
}

//class UseItme takes a string userId and a BackpackItem item
class UseItem extends BackpackEvent {
  final String userId;
  final BackpackItem item;

  const UseItem({required this.userId, required this.item});

  @override
  List<Object> get props => [userId, item];
}