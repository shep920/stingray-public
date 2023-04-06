part of 'prizes_bloc.dart';

abstract class PrizesState extends Equatable {
  const PrizesState();

  @override
  List<Object?> get props => [];
}

class PrizesLoading extends PrizesState {}

class PrizesLoaded extends PrizesState {
  final List<Prize> prizes;
  

  const PrizesLoaded({required this.prizes});

  @override
  List<Object?> get props => [prizes];


  //make a copywith method
  PrizesLoaded copyWith({
    List<Prize>? prizes,
    
  }) {
    return PrizesLoaded(
      prizes: prizes ?? this.prizes,
    );
  }
}
