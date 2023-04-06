part of 'stingray_bloc.dart';

abstract class StingrayState extends Equatable {
  const StingrayState();

  @override
  List<Object?> get props => [];
}

class StingrayLoading extends StingrayState {}

class StingrayLoaded extends StingrayState {
  final List<Stingray?> stingrays;

  final int selectedIndex;

  final List<String?> sortedStingrayIds;
  final Map<String, List<Story>> storiesMap;
  final List<String> seenStoryIds;

  const StingrayLoaded({
    required this.stingrays,
    required this.selectedIndex,
    required this.sortedStingrayIds,
    required this.storiesMap,
    required this.seenStoryIds,
  });

  @override
  List<Object?> get props => [
        stingrays,
        selectedIndex,
        sortedStingrayIds,
        storiesMap,
        seenStoryIds,
      ];

  //make a copyWith
  StingrayLoaded copyWith({
    List<Stingray?>? stingrays,
    int? selectedIndex,
    List<String?>? sortedStingrayIds,
    Map<String, List<Story>>? storiesMap,
    List<String>? seenStoryIds,
  }) {
    return StingrayLoaded(
      stingrays: stingrays ?? this.stingrays,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      sortedStingrayIds: sortedStingrayIds ?? this.sortedStingrayIds,
      storiesMap: storiesMap ?? this.storiesMap,
      seenStoryIds: seenStoryIds ?? this.seenStoryIds,
    );
  }
}
