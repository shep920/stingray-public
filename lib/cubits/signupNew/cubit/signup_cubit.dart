import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hero/repository/auth_repository.dart';

import '../../../helpers/errror_dialoge.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void signUpWithCredentials() async {
    try {
      if (!state.email.contains('@'))
        throw CustomException('bruh what the hell kind of email is that');

      //trim any space on the end or beginning of the email
      String email = state.email.trim();

      if (state.email.substring(state.email.indexOf('@')) != '@mix.wvu.edu') {
        if (state.email.substring(state.email.indexOf('@')) !=
            '@matoitechnology.com') {
          if (state.email.substring(state.email.indexOf('@')) !=
              '@mail.wvu.edu') {
            throw CustomException('bruh what the hell kind of email is that');
          }
        }
      }
      await _authRepository.signUp(email: email, password: state.password);
      emit(
        state.copyWith(status: SignupStatus.success),
      );
    } catch (e) {
      {
        if (e is CustomException) {
          emit(state.sendError(status: SignupStatus.error, error: e.cause));
        } else {
          FirebaseAuthException me = e as FirebaseAuthException;
          print(me.code);
          emit(state.sendError(
              status: SignupStatus.error,
              error: ErrorHandler.getMessageFromSignupErrorCode(me)));
        }
      }
    }
  }
}

class CustomException implements Exception {
  String cause;
  CustomException(this.cause);
}
