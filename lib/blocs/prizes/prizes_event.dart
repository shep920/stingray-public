part of 'prizes_bloc.dart';

abstract class PrizesEvent extends Equatable {
  const PrizesEvent();

  @override
  List<Object?> get props => [];
}

class LoadPrizes extends PrizesEvent {}

class UpdatePrizes extends PrizesEvent {
  final List<Prize> prizes;

  const UpdatePrizes({required this.prizes});

  @override
  List<Object> get props => [prizes];
}

//close profile class
class ClosePrizes extends PrizesEvent {
  const ClosePrizes();

  @override
  List<Object> get props => [];
}

class CreatePrize extends PrizesEvent {
  final Prize prize;
  final File? image;

  const CreatePrize({required this.prize, this.image});

  @override
  List<Object?> get props => [prize, image];
}

class DeletePrize extends PrizesEvent {
  final Prize prize;

  const DeletePrize({required this.prize});

  @override
  List<Object> get props => [prize];
}

class ChangePrizeRemaining extends PrizesEvent {
  final Prize prize;
  final int remaining;

  const ChangePrizeRemaining({required this.prize, required this.remaining});

  @override
  List<Object> get props => [prize, remaining];
}
