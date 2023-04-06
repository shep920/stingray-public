import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/prize_model.dart';

class BackpackItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String prizeValue;
  final String ownerId;
  final bool used;
  final DateTime? usedAt;
  final String functionName;

  BackpackItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.prizeValue,
    required this.ownerId,
    required this.used,
    this.usedAt,
    required this.functionName,
  });

  //make all the same methods as the Prize class
  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        prizeValue,
        ownerId,
        used,
        usedAt,
        functionName,
      ];

  @override
  bool get stringify => true;

  BackpackItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? prizeValue,
    String? ownerId,
    bool? used,
    DateTime? usedAt,
    String? functionName,
  }) {
    return BackpackItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prizeValue: prizeValue ?? this.prizeValue,
      ownerId: ownerId ?? this.ownerId,
      used: used ?? this.used,
      usedAt: usedAt ?? this.usedAt,
      functionName: functionName ?? this.functionName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'prizeValue': prizeValue,
      'ownerId': ownerId,
      'used': used,
      'usedAt': usedAt?.toIso8601String(),
      'functionName': functionName,
    };
  }

  //fromMap method
  factory BackpackItem.fromMap(Map<String, dynamic> map) {
    return BackpackItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      prizeValue: map['prizeValue'] ?? '',
      ownerId: map['ownerId'] ?? '',
      used: map['used'] ?? false,
      usedAt: map['usedAt'] != null
          ? Timestamp.fromDate(DateTime.now()).toDate()
          : null,
      functionName: map['functionName'],
    );
  }

  factory BackpackItem.fromPrize(Prize prize, String ownerId) {
    return BackpackItem(
      id: prize.id,
      name: prize.name,
      description: prize.description,
      imageUrl: prize.imageUrl,
      prizeValue: prize.prizeValue,
      ownerId: ownerId,
      used: false,
      usedAt: null,
      functionName: prize.functionName,
    );
  }
}
