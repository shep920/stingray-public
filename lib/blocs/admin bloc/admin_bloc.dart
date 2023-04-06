import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/static_data/report_stuff.dart';

import '../../models/report_model.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final FirestoreRepository _firestoreRepository;
  late StreamSubscription _userListener;
  late StreamSubscription _reportListener;

  AdminBloc({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(AdminLoading()) {
    on<LoadAdmin>(_onLoadAdmin);
    on<UpdateAdmin>(_onUpdateAdmin);
    on<LoadAdminUserFromFirestore>(_loadUserFromFirestore);
    on<UpdateUserFromFirestore>(_updateUserFromFirestore);
    on<CloseUser>(_onCloseUser);
    on<CloseReports>(_onCloseReports);
    on<IgnoreReport>(_onIgnoreReport);
    on<DeleteWave>(_onDeleteWave);
  }

  void _onLoadAdmin(
    LoadAdmin event,
    Emitter<AdminState> emit,
  ) {
    _reportListener = _firestoreRepository.reports.listen((reports) {
      add(
        UpdateAdmin(reports: reports),
      );
    });
  }

  void _onUpdateAdmin(
    UpdateAdmin event,
    Emitter<AdminState> emit,
  ) {
    final List<Report?> stingrayReports = event.reports
        .where((report) => report?.type == 'stingray report')
        .toList();

    final List<Report?> waveReports =
        event.reports.where((report) => report?.type == 'wave').toList();

    final List<Report?> chatReports =
        event.reports.where((report) => report?.type == 'chat report').toList();

    final List<Report?> storyReports = event.reports
        .where((report) => report?.type == ReportStuff.story_type)
        .toList();
    emit(AdminLoaded(
        verifiedAs: null,
        user: null,
        reports: event.reports,
        stingrayReports: stingrayReports,
        chatReports: chatReports,
        waveReports: waveReports,
        storyReports: storyReports));
  }

  _loadUserFromFirestore(
    LoadAdminUserFromFirestore event,
    Emitter<AdminState> emit,
  ) async {
    try {
      {
        User _user = await _firestoreRepository.getFutureUser(event.userId);

        add(
          UpdateUserFromFirestore(user: _user),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  _updateUserFromFirestore(
    UpdateUserFromFirestore event,
    Emitter<AdminState> emit,
  ) {
    try {
      final state = this.state as AdminLoaded;
      User? _verifiedAs;
      if (event.user.verified) {
        
      }
      emit(AdminLoaded(
          user: event.user,
          stingrayReports: state.stingrayReports,
          chatReports: state.chatReports,
          reports: state.reports,
          waveReports: state.waveReports,
          storyReports: state.storyReports,
          verifiedAs: _verifiedAs));
    } catch (e) {
      print(e);
    }
  }

  void _onCloseUser(
    CloseUser event,
    Emitter<AdminState> emit,
  ) {
    try {
      this._userListener.cancel();
      print('user closed');
    } catch (e) {
      print(e);
    }
  }

  void _onCloseReports(
    CloseReports event,
    Emitter<AdminState> emit,
  ) {
    try {
      this._reportListener.cancel();
      print('reports closed');
    } catch (e) {
      print(e);
    }
  }

  void _onIgnoreReport(
    IgnoreReport event,
    Emitter<AdminState> emit,
  ) {
    try {
      _firestoreRepository.ignoreReport(event.report);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onDeleteWave(
    DeleteWave event,
    Emitter<AdminState> emit,
  ) async {
    try {
      _firestoreRepository.deleteWave(event.report.wave!);
      if (event.report.wave!.replyTo != 'null') {
        await _firestoreRepository
            .decrementWaveReplies(event.report.wave!.replyTo!);
      }
      _firestoreRepository.ignoreReport(event.report);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
