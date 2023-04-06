part of 'user_verification_bloc.dart';

abstract class UserVerificationEvent extends Equatable {
  const UserVerificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserVerification extends UserVerificationEvent {
  final User user;
  const LoadUserVerification({required this.user});

  @override
  List<Object?> get props => [user];
}

class CloseUserVerification extends UserVerificationEvent {
  const CloseUserVerification();

  @override
  List<Object?> get props => [];
}

class UpdateUserVerification extends UserVerificationEvent {
  final UserVerification verification;

  const UpdateUserVerification({required this.verification});

  @override
  List<Object> get props => [verification];
}

class SendUserVerification extends UserVerificationEvent {
  final UserVerification verification;
  final File image;

  const SendUserVerification({required this.verification, required this.image});

  @override
  List<Object> get props => [verification, image];
}

class CancelUserVerification extends UserVerificationEvent {
  const CancelUserVerification();

  @override
  List<Object> get props => [];
}

class RestartVerification extends UserVerificationEvent {
  const RestartVerification();

  @override
  List<Object> get props => [];
}
