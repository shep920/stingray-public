part of 'admin_verification_bloc.dart';

abstract class AdminVerificationState extends Equatable {
  const AdminVerificationState();

  @override
  List<Object> get props => [];
}

class AdminVerificationLoading extends AdminVerificationState {}

class AdminVerificationInitial extends AdminVerificationState {
  const AdminVerificationInitial();

  @override
  List<Object> get props => [];
}

class AdminVerificationLoaded extends AdminVerificationState {
  final List<UserVerification> verifications;
  final List<User> users;

  const AdminVerificationLoaded(
      {required this.verifications, required this.users});

  @override
  List<Object> get props => [verifications, users];
}
