part of 'editbio_cubit.dart';

enum EditbioStatus { initial, submitting, success, error }

class EditbioState extends Equatable {
  final String bio;
    final String interest;

  final EditbioStatus status;

  bool get isFormValid => bio.isNotEmpty||interest.isNotEmpty;

  const EditbioState({
    required this.bio,
        required this.interest,

    required this.status,
  });

  factory EditbioState.initial() {
    return EditbioState(
      bio: '',
      interest: '',
      status: EditbioStatus.initial,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [bio, status, interest];

  EditbioState copyWith({
    String? bio,
    EditbioStatus? status, String? interest,
  }) {
    return EditbioState(
      bio: bio ?? this.bio,
      status: status ?? this.status,
      interest: interest?? this.interest,
    );
  }
}
