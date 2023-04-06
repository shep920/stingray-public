import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';

part 'localuser_state.dart';

class LocaluserCubit extends Cubit<LocaluserState> {
  LocaluserCubit() : super((LocaluserState.initial()));
  void userChanged(User? user) {
    emit(state.copyWith(user: user));
  }
}
