import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentState.initial());

  void commentChanged(String value) {
    emit(state.copyWith(comment: value, status: CommentStatus.initial));
  }


  void CommentWithCredentials() {
    if (!state.isFormValid || state.status == CommentStatus.submitting) return;
    emit(
      state.copyWith(status: CommentStatus.submitting),
    );
    try {
      emit(
        state.copyWith(status: CommentStatus.success),
      );
    } catch (_) {}
  }

    @override
  Future<void> close() async {
    super.close();
  }
}