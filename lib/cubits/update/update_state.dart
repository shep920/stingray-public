part of 'update_cubit.dart';

enum UpdateStatus { initial, submitting, success, error }

class UpdateState extends Equatable {
  final String bio;
  final UpdateStatus status;

  bool get isFormValid => bio.isNotEmpty;

  const UpdateState({
    required this.bio,
    required this.status,
  });

  factory UpdateState.initial() {
    return UpdateState(
      bio: '',
      status: UpdateStatus.initial,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [bio, status];

  UpdateState copyWith({
    String? bio,
    UpdateStatus? status,
  }) {
    return UpdateState(
      bio: bio?? this.bio,
      status: status ?? this.status,
    );
  }
}
