import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/helpers/errror_dialoge.dart';
import 'package:hero/repository/auth_repository.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository _authRepository;

  SigninCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SigninState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SigninStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SigninStatus.initial));
  }

  String? sendError(e) {
    emit(state.sendError(error: e));
    return state.errorMessage;
  }

  void signInWithCredentials() async {
    try {
      String email = state.email.trim();
      await _authRepository.signInWithEmailAndPassword(
          email: email, password: state.password);
      emit(
        state.copyWith(status: SigninStatus.success),
      );
    } catch (e) {
      print(e);
      emit(state.sendError(
          status: SigninStatus.error,
          error: ErrorHandler.getMessageFromErrorCode(e)));
    }
  }
}
