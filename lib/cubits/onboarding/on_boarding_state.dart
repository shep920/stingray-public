part of 'on_boarding_cubit.dart';

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object?> get props => [];
}

class OnBoardingInitial extends OnBoardingState {}

class OnBoaringLoaded extends OnBoardingState {
  final User user;
  

  const OnBoaringLoaded({required this.user});

  @override
  List<Object> get props => [user];
}
