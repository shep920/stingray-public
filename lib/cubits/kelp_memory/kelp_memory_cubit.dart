import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:hero/repository/firestore_repository.dart';

part 'kelp_memory_state.dart';

class KelpMemoryCubit extends Cubit<KelpMemoryState> {
  final FirestoreRepository _firestoreRepository;
  KelpMemoryCubit({
    required FirestoreRepository firestoreRepository,
  })  : _firestoreRepository = firestoreRepository,
        super(KelpMemoryInitial(memories: []));

  //a method, update memory, that takes in a List of Strings called memories
  void updateMemory(List<String> memories) {
    //add the memories to the state
    final state = this.state as KelpMemoryInitial;
    List<String> newMemories = [...state.memories, ...memories];
    emit(KelpMemoryInitial(memories: newMemories));
  }

  void clearMemory(String userId) {
    if (state is KelpMemoryInitial) {
      final state = this.state as KelpMemoryInitial;

      if (state.memories.isNotEmpty) {
        final state = this.state as KelpMemoryInitial;
        List<String> memories = state.memories;

        emit(KelpMemoryInitial(memories: []));

        _firestoreRepository.setSeenVideoIds(userId: userId, waveIds: memories);
      }
    }
  }
}
