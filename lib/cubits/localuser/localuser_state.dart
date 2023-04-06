part of 'localuser_cubit.dart';

enum LocaluserStatus { initial, submitting, success, error }

class LocaluserState extends Equatable {
  final User? user;
  final LocaluserStatus status;

  const LocaluserState({
    required this.user,
    required this.status,
  });

  factory LocaluserState.initial() {
    return LocaluserState(
      user: null,
      status: LocaluserStatus.initial,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [user, status];

    LocaluserState copyWith({
    User? user,
    LocaluserStatus? status,
  }) {
    return LocaluserState(
      user: user?? this.user,
      status: status ?? this.status,
    );
  }

}
