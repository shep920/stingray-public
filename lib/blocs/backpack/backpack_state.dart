part of 'backpack_bloc.dart';

abstract class BackpackState extends Equatable {
  const BackpackState();

  @override
  List<Object?> get props => [];
}

class BackpackLoading extends BackpackState {}

class BackpackLoaded extends BackpackState {
  final List<BackpackItem> backpack;
  

  const BackpackLoaded({required this.backpack});

  @override
  List<Object?> get props => [backpack];


  //make a copywith method
  BackpackLoaded copyWith({
    List<BackpackItem>? backpack,
    
  }) {
    return BackpackLoaded(
      backpack: backpack ?? this.backpack,
    );
  }
}
