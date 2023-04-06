part of 'comment_cubit.dart';

enum CommentStatus { initial, submitting, success, error }

class CommentState extends Equatable {
  final String comment;

  final CommentStatus status;

  bool get isFormValid => comment.isNotEmpty;

  const CommentState({
    required this.comment,
    required this.status,
  });

  factory CommentState.initial() {
    return CommentState(
      comment: '',
      status: CommentStatus.initial,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [comment, status];

  CommentState copyWith({
    String? comment,
    CommentStatus? status,
    String? interest,
  }) {
    return CommentState(
      comment: comment ?? this.comment,
      status: status ?? this.status,
    );
  }
}
