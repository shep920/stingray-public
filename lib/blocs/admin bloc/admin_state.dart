part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<Report?> reports;
  final List<Report?> stingrayReports;
  final List<Report?> chatReports;
  final List<Report?> waveReports;
  final List<Report?> storyReports;
  final User? user;
  final User? verifiedAs;

  const AdminLoaded(
      {required this.reports,
      required this.stingrayReports,
      required this.chatReports,
      required this.user,
      required this.waveReports,
      required this.storyReports,
      
      required this.verifiedAs});

  @override
  List<Object?> get props =>
      [reports, stingrayReports, chatReports, user, waveReports, storyReports, verifiedAs];
}
