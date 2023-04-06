import 'package:equatable/equatable.dart';
import 'package:hero/models/user_model.dart';

class Team extends Equatable {
  final int id;
  final String name;
  final int age;
  final String imageUrls;
  final String charity;
  final String description;
  final bool isStingray;
  final List<User>? members;
  final String charityImgUrl;

  const Team(
      {required this.id,
      required this.name,
      required this.age,
      required this.imageUrls,
      required this.charity,
      required this.description,
      required this.members,
      this.isStingray = false,
      this.charityImgUrl =
          'https://upload.wikimedia.org/wikipedia/commons/4/48/BLANK_ICON.png'});

  @override
  List<Object?> get props =>
      [id, name, age, imageUrls, charity, description, isStingray];


}
