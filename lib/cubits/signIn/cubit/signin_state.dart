part of 'signin_cubit.dart';

enum SigninStatus { initial, submitting, success, error }

class SigninState extends Equatable {
  final String email;
  final String password;
  final SigninStatus status;
  final String? errorMessage;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const SigninState({
    required this.email,
    required this.password,
    required this.status,
    this.errorMessage,
  });

  factory SigninState.initial() {
    return SigninState(
      email: '',
      password: '',
      status: SigninStatus.initial,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  SigninState copyWith({
    String? email,
    String? password,
    SigninStatus? status,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  SigninState sendError(
      {String? email, String? password, SigninStatus? status, String? error}) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: error,
    );
  }
}
