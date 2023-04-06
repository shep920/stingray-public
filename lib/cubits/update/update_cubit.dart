import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/repository/firestore_repository.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  final FirestoreRepository _firestoreRepository;

  UpdateCubit({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(UpdateState.initial());

  void bioChanged(String value) {
    emit(state.copyWith(bio: value, status: UpdateStatus.initial));
  }

  // void passwordChanged(String value) {
  //   emit(state.copyWith(password: value, status: UpdateStatus.initial));
  // }

  // void signInWithCredentials() async {
  //   try {
  //     await _firestoreRepository.signInWithEmailAndPassword(
  //         email: state.email, password: state.password);
  //     emit(
  //       state.copyWith(status: UpdateStatus.success),
  //     );
  //   } catch (_) {}
  // }
}
