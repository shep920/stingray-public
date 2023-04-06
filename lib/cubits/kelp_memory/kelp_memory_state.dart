part of 'kelp_memory_cubit.dart';

abstract class KelpMemoryState extends Equatable {
  const KelpMemoryState();

  @override
  List<Object> get props => [];
}

class KelpMemoryInitial extends KelpMemoryState {
  //give kelp memory an initial state of a list of Strings called memories
  final List<String> memories;

  const KelpMemoryInitial({required this.memories});

  @override
  List<Object> get props => [memories];
}
