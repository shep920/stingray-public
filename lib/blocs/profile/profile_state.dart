part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final bool? isViewingTutorial;

  const ProfileLoaded({required this.user, this.isViewingTutorial});

  @override
  List<Object?> get props => [user, isViewingTutorial];


  //make a copywith method
  ProfileLoaded copyWith({
    User? user,
    bool? isViewingTutorial,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isViewingTutorial: isViewingTutorial ?? this.isViewingTutorial,
    );
  }
}
