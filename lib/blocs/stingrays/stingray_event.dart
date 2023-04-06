part of 'stingray_bloc.dart';

abstract class StingrayEvent extends Equatable {
  const StingrayEvent();

  @override
  List<Object?> get props => [];
}

class LoadStingray extends StingrayEvent {
  final User user;
  final String sortOrder;
  const LoadStingray({
    required this.user,
    required this.sortOrder,
  });

  @override
  List<Object> get props => [sortOrder, user];
}

class UpdateStingray extends StingrayEvent {
  final List<Stingray?> stingrays;
  final String sortOrder;
  final int selectedIndex;
  final List<String?> sortedStingrayIds;

  const UpdateStingray({
    required this.stingrays,
    required this.sortOrder,
    required this.selectedIndex,
    required this.sortedStingrayIds,
  });

  @override
  List<Object> get props =>
      [stingrays, sortOrder, selectedIndex, sortedStingrayIds];
}

class IncrementImageUrlIndex extends StingrayEvent {
  final int imageUrlIndex;
  final int stingrayIndex;

  const IncrementImageUrlIndex({
    required this.imageUrlIndex,
    required this.stingrayIndex,
  });

  @override
  List<Object> get props => [imageUrlIndex, stingrayIndex];
}

class DecrementImageUrlIndex extends StingrayEvent {
  final int imageUrlIndex;
  final int stingrayIndex;

  const DecrementImageUrlIndex({
    required this.imageUrlIndex,
    required this.stingrayIndex,
  });

  @override
  List<Object> get props => [imageUrlIndex, stingrayIndex];
}

class UpdateSortOrder extends StingrayEvent {
  final String sortOrder;

  final List<Stingray?> stingrays;

  const UpdateSortOrder({
    required this.sortOrder,
    required this.stingrays,
  });

  @override
  List<Object?> get props => [sortOrder, stingrays];
}

class UpdateSelectedIndex extends StingrayEvent {
  final int selectedIndex;

  const UpdateSelectedIndex({
    required this.selectedIndex,
  });

  @override
  List<Object> get props => [selectedIndex];
}

class UpdateSelectedStingray extends StingrayEvent {
  final BuildContext context;
  const UpdateSelectedStingray({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}

//close stingray class
class CloseStingray extends StingrayEvent {
  const CloseStingray();

  @override
  List<Object?> get props => [];
}

//refresh stingray class

//remove stingray class
class RemoveStingray extends StingrayEvent {
  final User user;
  const RemoveStingray({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class UploadStory extends StingrayEvent {
  final File file;
  final String stingrayId;
  const UploadStory({
    required this.file,
    required this.stingrayId,
  });

  @override
  List<Object?> get props => [file, stingrayId];
}

class ViewStory extends StingrayEvent {
  final Story story;

  const ViewStory({
    required this.story,
  });

  @override
  List<Object?> get props => [story];
}

class ReportStory extends StingrayEvent {
  final Story story;
  final User reporter;
  final User reportedUser;

  const ReportStory({
    required this.story,
    required this.reporter,
    required this.reportedUser,
  });

  @override
  List<Object?> get props => [story, reporter];
}

class DeleteStory extends StingrayEvent {
  final Story story;

  const DeleteStory({
    required this.story,
  });

  @override
  List<Object?> get props => [story];
}
