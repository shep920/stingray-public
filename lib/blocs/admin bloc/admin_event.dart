part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdmin extends AdminEvent {
  const LoadAdmin();

  @override
  List<Object> get props => [];
}

class UpdateAdmin extends AdminEvent {
  final List<Report?> reports;
  const UpdateAdmin({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class LoadAdminUserFromFirestore extends AdminEvent {
  final String? userId;

  LoadAdminUserFromFirestore(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserFromFirestore extends AdminEvent {
  final User user;

  const UpdateUserFromFirestore({required this.user});

  @override
  List<Object> get props => [user];
}

class CloseUser extends AdminEvent {
  const CloseUser();

  @override
  List<Object?> get props => [];
}

class CloseReports extends AdminEvent {
  const CloseReports();

  @override
  List<Object?> get props => [];
}

class IgnoreReport extends AdminEvent {
  final Report report;

  const IgnoreReport({required this.report});

  @override
  List<Object?> get props => [report];
}

class DeleteWave extends AdminEvent {
  final Report report;

  const DeleteWave({required this.report});

  @override
  List<Object?> get props => [report];
}
