import 'package:equatable/equatable.dart';

abstract class Post extends Equatable {
  String id;
  String senderId;
  DateTime createdAt;
  Post({
    required this.id,
    required this.senderId,
    required this.createdAt,
  });

  

  @override
  List<Object> get props => [id, senderId, createdAt];
}


//make the class Seareal that extends Post. Seareal has a String text property


