import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/repository/auth_repository.dart';

part 'editbio_state.dart';

class EditbioCubit extends Cubit<EditbioState> {
  EditbioCubit() : super(EditbioState.initial());

  void bioChanged(String value) {
    emit(state.copyWith(bio: value, status: EditbioStatus.initial));
  }

  void interestChanged(String value) {
    emit(state.copyWith(interest: value, status: EditbioStatus.initial));
  }

  void EditbioWithCredentials() {
    if (!state.isFormValid || state.status == EditbioStatus.submitting) return;
    emit(
      state.copyWith(status: EditbioStatus.submitting),
    );
    try {
      emit(
        state.copyWith(status: EditbioStatus.success),
      );
    } catch (_) {}
  }

    @override
  Future<void> close() async {
    super.close();
  }
}
