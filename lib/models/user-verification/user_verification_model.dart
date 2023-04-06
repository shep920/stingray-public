import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/user_model.dart';

class UserVerification extends Equatable {
  final String id;
  final User? verifiedAs;
  final String verificationStatus;
  final Timestamp? createdAt;
  final String imageUrl;
  final Timestamp verifiedOn;
  final String rejectionReason;

  UserVerification({
    required this.id,
    required this.verifiedAs,
    required this.verificationStatus,
    required this.createdAt,
    required this.imageUrl,
    required this.verifiedOn,
    required this.rejectionReason,
  });

  @override
  List<Object?> get props => [
        id,
        verifiedAs,
        verificationStatus,
        createdAt,
        imageUrl,
        verifiedOn,
        rejectionReason
      ];

  //make a copywith
  UserVerification copyWith({
    String? id,
    User? verifiedAs,
    String? verificationStatus,
    Timestamp? createdAt,
    String? imageUrl,
    Timestamp? verifiedOn,
    String? rejectionReason,
  }) {
    return UserVerification(
      id: id ?? this.id,
      verifiedAs: verifiedAs ?? this.verifiedAs,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      verifiedOn: verifiedOn ?? this.verifiedOn,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  //make a static tojson that takes in a UserVerification and returns a map
  static Map<String, dynamic> toJson(UserVerification? verification) => {
        'id': verification?.id,
        'verifiedAs': //use the User.toJson method to convert the User to a map
            verification?.verifiedAs != null
                ? User.toJson(verification!.verifiedAs!)
                : null,
        'verificationStatus': verification?.verificationStatus,
        'createdAt': verification?.createdAt,
        'imageUrl': verification?.imageUrl,
        'verifiedOn': verification?.verifiedOn,
        'rejectionReason': verification?.rejectionReason,
      };

  //make a fromDocSnapshot that takes in a doc snapshot and returns a UserVerification
  static UserVerification fromDocSnapshot(dynamic verification) {
    return UserVerification(
      id: verification['id'],
      verifiedAs: //use the User.fromMap method to convert the map to a User
          verification['verifiedAs'] != null
              ? User.fromDynamic(verification['verifiedAs'])
              : null,
      verificationStatus: verification['verificationStatus'] ?? pending,
      createdAt: verification?['createdAt'] ?? null,
      imageUrl: verification['imageUrl'] ?? '',
      verifiedOn: verification['verifiedOn'] ?? Timestamp.now(),
      rejectionReason: verification['rejectionReason'] ?? '',
    );
  }

  //make a static genericVerification method that takes in a string id and returns a UserVerification
  static UserVerification genericVerification(String id) {
    return UserVerification(
      id: id,
      verifiedAs: null,
      verificationStatus: initial,
      createdAt: Timestamp.now(),
      imageUrl: '',
      verifiedOn: Timestamp.now(),
      rejectionReason: '',
    );
  }

  static String initial = 'initial';
  static String pending = 'pending';
  static String accepted = 'accepted';
  static String rejected = 'rejected';
}
