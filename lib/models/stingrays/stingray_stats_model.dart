//a class, stingrayStats, that has an int likes, and an int dislikes and an int replies and an int wavesPosted and a string stingrayId
import 'package:equatable/equatable.dart';

class StingrayStats extends Equatable {
  final String stingrayId;
  final int likes;
  final int dislikes;
  
  final int totalScore;

  StingrayStats(
      {required this.stingrayId,
      required this.likes,
      required this.dislikes,
       required this.totalScore});

  @override
  List<Object?> get props => [
        stingrayId,
        likes,
        dislikes,
        
        totalScore
      ];
}
