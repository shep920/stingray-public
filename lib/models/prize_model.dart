import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Prize extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String prizeValue;
  final int remaining;
  final String functionName;

  Prize(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.prizeValue,
      required this.remaining,
      required this.functionName});

  @override
  List<Object?> get props => [id, name, description, imageUrl, prizeValue];

  static Prize prizeFromMap(Map<String, dynamic> map) {
    return Prize(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      prizeValue: map['prizeValue'],
      remaining: map['remaining'],
      functionName: map['functionName'],
    );
  }

  static List<Prize> prizeListFromMap(List<dynamic> mappedPrizes) {
    List<Prize> prizeList = [];
    for (Map<String, dynamic> prize in mappedPrizes) {
      prizeList.add(Prize.prizeFromMap(prize));
    }
    return prizeList;
  }

  static List<Prize> prizeListFromQuerySnapshot(QuerySnapshot querySnapshot) {
    List<Prize> prizeList = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      prizeList.add(Prize.prizeFromMap(doc.data() as Map<String, dynamic>));
    }

    return prizeList;
  }

  static Prize prizeFromTypesenseDoc(Map<dynamic, dynamic> e) {
    Map<String, dynamic> map = e['document'] as Map<String, dynamic>;
    return Prize(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      prizeValue: map['prizeValue'],
      remaining: map['remaining'],
      functionName: map['functionName'],
    );
  }

  static Prize genericPrize(
      {String? id,
      String? name,
      String? description,
      String? imageUrl,
      String? prizeValue,
      int? remaining,
      String? functionName}) {
    final String newId = Uuid().v4();
    return Prize(
      id: (id == null) ? newId : id,
      name: name ?? 'Generic Prize',
      description: description ?? 'Generic Description',
      imageUrl: imageUrl ?? '',
      prizeValue: prizeValue ?? ironValue,
      remaining: remaining ?? 0,
      functionName: functionName ?? validateFunction,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'prizeValue': prizeValue,
        'remaining': remaining,
        'functionName': functionName,
      };

  //write a copyWith method
  Prize copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? prizeValue,
    int? remaining,
    String? functionName,
  }) {
    return Prize(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prizeValue: prizeValue ?? this.prizeValue,
      remaining: remaining ?? this.remaining,
      functionName: functionName ?? this.functionName,
    );
  }

  static const String goldValue = 'Gold';
  static const String silverValue = 'Silver';
  static const String bronzeValue = 'Bronze';
  static const String ironValue = 'Iron';

  static const String addTenVotesFunction = 'addTenVotes';
  static const String addFiveVotesFunction = 'addFiveVotes';
  static const String addThreeVotesFunction = 'addThreeVotes';
  static const String addTwoVotesFunction = 'addTwoVotes';
  static const String validateFunction = 'validate';

  static const String goldToken = 'goldTokens';
  static const String silverToken = 'silverTokens';
  static const String bronzeToken = 'bronzeTokens';
  static const String ironToken = 'ironTokens';

  static List<Prize> examplePrizes = [
    Prize(
      id: Uuid().v4(),
      name: 'Gold coin',
      description: 'Gets you ten extra votes when you use it.',
      imageUrl:
          'http://darksouls.wikidot.com/local--files/consumables/gold-coin.png',
      prizeValue: Prize.goldValue,
      remaining: 5,
      functionName: addTenVotesFunction,
    ),
    Prize(
      id: Uuid().v4(),
      name: 'Silver Coin',
      description: 'Gets you five extra votes when you use it.',
      imageUrl:
          "https://darksouls2.wiki.fextralife.com/file/Dark-Souls-2/silver_talisman.png",
      prizeValue: Prize.silverValue,
      remaining: 10,
      functionName: addFiveVotesFunction,
    ),
    Prize(
        id: Uuid().v4(),
        name: 'Bronze coin',
        description: 'Gets you three extra votes when you use it.',
        imageUrl:
            "https://demonssouls.wiki.fextralife.com/file/Demons-Souls/gold-coin.png",
        prizeValue: Prize.bronzeValue,
        remaining: 15,
        functionName: addThreeVotesFunction),
    Prize(
        id: Uuid().v4(),
        name: 'Iron coin',
        description: 'Gives you two extra votes',
        imageUrl:
            "https://static.wikia.nocookie.net/darksouls/images/b/b7/Rusted_Gold_Coin.png/revision/latest?cb=20160614120722",
        prizeValue: Prize.ironValue,
        remaining: 20,
        functionName: addTwoVotesFunction),
  ];
}

//make the class BackpackItem. It has the same fields as the Prize class, with a String ownerId field

