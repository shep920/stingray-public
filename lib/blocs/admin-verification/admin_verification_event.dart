part of 'admin_verification_bloc.dart';

abstract class AdminVerificationEvent extends Equatable {
  const AdminVerificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminVerification extends AdminVerificationEvent {
  const LoadAdminVerification();

  @override
  List<Object?> get props => [];
}

class CloseAdminVerification extends AdminVerificationEvent {
  const CloseAdminVerification();

  @override
  List<Object?> get props => [];
}

class UpdateAdminVerification extends AdminVerificationEvent {
  final List<UserVerification> verifications;

  const UpdateAdminVerification({required this.verifications});

  @override
  List<Object> get props => [verifications];
}

class RejectVerification extends AdminVerificationEvent {
  final String reason;
  final UserVerification verification;

  const RejectVerification({required this.reason, required this.verification});

  @override
  List<Object> get props => [reason, verification];
}

class AcceptVerification extends AdminVerificationEvent {
  final UserVerification verification;
  final User verifiedAs;

  const AcceptVerification(
      {required this.verification, required this.verifiedAs});

  @override
  List<Object> get props => [verification, verifiedAs];
}
