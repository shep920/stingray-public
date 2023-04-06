part of 'user_verification_bloc.dart';

abstract class UserVerificationState extends Equatable {
  const UserVerificationState();

  @override
  List<Object> get props => [];
}

class UserVerificationLoading extends UserVerificationState {}

class UserVerificationInitial extends UserVerificationState {
  final UserVerification userVerification;

  const UserVerificationInitial({required this.userVerification});

  @override
  List<Object> get props => [userVerification];
}

class UserVerificationPending extends UserVerificationState {
  final UserVerification userVerification;

  const UserVerificationPending({required this.userVerification});

  @override
  List<Object> get props => [userVerification];
}

class UserVerificationRejected extends UserVerificationState {
  final UserVerification userVerification;

  const UserVerificationRejected({required this.userVerification});

  @override
  List<Object> get props => [userVerification];
}

class UserVerificationAccepted extends UserVerificationState {
  final UserVerification userVerification;

  const UserVerificationAccepted({required this.userVerification});

  @override
  List<Object> get props => [userVerification];
}
